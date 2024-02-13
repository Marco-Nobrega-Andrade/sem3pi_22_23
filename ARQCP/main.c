#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include "constants.h"
#include "sensor_struct.h"
#include "matriz.h"
#include "change_sensor.h"
#include "sensores.h"
#include "demo_pcg.h"
#include "read_rnd.h"
#include "checks.h"
#include "exportData.h"
#include "exportMatrixData.h"

double matrix[numberOfSensors][numColumns];

int main()
{
	FILE *arq;
	int result = read_rnd();

	Sensor *arr_sens_temp = NULL;
	int sens_temp_count = 0;

	Sensor *arr_sens_vel_vento = NULL;
	int sens_vel_vento_count = 0;

	Sensor *arr_sens_dir_vento = NULL;
	int sens_dir_vento_count = 0;

	Sensor *arr_sens_pluv = NULL;
	int sens_pluv_count = 0;

	Sensor *arr_sens_hum_atm = NULL;
	int sens_hum_atm_count = 0;

	Sensor *arr_sens_hum_solo = NULL;
	int sens_hum_solo_count = 0;

	int max_generating_time;
	int sensor_count = 0;
	int start_option;
	int num_errors;
	int option;

	printf("Durante quanto tempo deseja gerar valores para os sensores?(em segundos)\n");
	scanf("%d", &max_generating_time);
	printf("\n");
	while (max_generating_time < 0)
	{
		printf("O tempo deve ser um valor positivo.\n");
		scanf("%d", &max_generating_time);
		printf("\n");
	}

	do
	{	
		printf("\n");
		printf("Digite o número da opção que deseja\n");
		printf("1 - Criar novo sensor\n");
		printf("2 - Gerar valores para os sensores\n");
		printf("3 - Remover valores\n");
		printf("4 - Alterar frequência\n");
		printf("5 - Exportar dados dos sensores para ficheiro CSV\n");
		printf("6 - Exportar dados da matriz para um ficheiro CSV\n");
		printf("7 - Sair\n");
		scanf("%d", &start_option);
		printf("\n");

		while (start_option < 1 || start_option > 7)
		{
			printf("Não existe essa opção. Por favor insira novamente.\n");
			scanf("%d", &start_option);
			printf("\n");
		}

		switch (start_option)
		{
		case 1:;

			int create_option;
			printf("Qual o tipo de sensor deseja criar? (digite o número da opção)\n");
			printf("1 - Sensor de temperatura\n");
			printf("2 - Sensor de velocidade do vento\n");
			printf("3 - Sensor de direção do vento\n");
			printf("4 - Sensor de pluviosidade\n");
			printf("5 - Sensor de humidade da atmosfera\n");
			printf("6 - Sensor de humidade do solo\n");

			printf("7 - Voltar\n");

			scanf("%d", &create_option);
			printf("\n");

			while (create_option < 1 || create_option > 7)
			{
				printf("Não existe essa opção. Por favor insira novamente.\n");
				scanf("%d", &create_option);
				printf("\n");
			}
			if (create_option != 7)
			{
				short max_limit;
				short min_limit;
				long frequency;
				char flag_frequency = 0;

				printf("Insira o limite máximo do sensor:\n");
				max_limit = 20;
				scanf("%hd", &max_limit);
				printf("\n");

				printf("Insira o limite mínimo do sensor:\n");
				min_limit = 5;
				scanf("%hd", &min_limit);
				printf("\n");

				while (min_limit >= max_limit || min_limit < 0 || max_limit < 0)
				{
					printf("Valores inválidos.Verifique se os limites são positivos e se o limite mínimo é menor do que o limite máximo\n");
					printf("\n");

					printf("Insira o limite máximo do sensor:\n");
					scanf("%hd", &max_limit);
					printf("\n");

					printf("Insira o limite mínimo do sensor:\n");
					scanf("%hd", &min_limit);
					printf("\n");
				}

				int freq_option;
				do
				{
					printf("Como deseja inserir o valor da frequência? (Escolha a opção que deseja)\n");
					printf("1 - Ficheiro de configuração\n");
					printf("2 - Inserir manualmente\n");
					freq_option = 2;
					scanf("%d", &freq_option);
					printf("\n");
					while (freq_option < 1 || freq_option > 2)
					{
						printf("Não existe essa opção. Por favor insira novamente.\n");
						scanf("%d", &freq_option);
						printf("\n");
					}

					switch (freq_option)
					{
					case 1:

						arq = fopen("Config.txt", "rt");
						if (arq != NULL)
						{
							int line_to_read = create_option << 1;
							char keep_reading = 1;
							char buffer[MAX_LINE_SIZE];
							int current_line = 1;
							do
							{
								if (current_line == line_to_read)
								{
									fscanf(arq, "%ld", &frequency);
									keep_reading = 0;
								}
								fgets(buffer, MAX_LINE_SIZE, arq);
								current_line++;
							} while (keep_reading == 1);
							if (frequency >= 0)
							{
								flag_frequency = 1;
							}
							else
							{
								printf("O valor da freqência não pode ser negativo.\n");
							}
						}
						else
						{
							printf("Ocorreu um erro ao ler do ficheiro. Por favor tente novamente ou insira o valor manualmente.\n");
						}
						break;
					case 2:
						printf("Insira o valor da frequência (em segundos):\n");
						frequency = 5;
						scanf("%ld", &frequency);
						printf("\n");
						while (frequency <= 0)
						{
							printf("A frequẽncia tem de ser um valor maior que zero .\n");
							scanf("%ld", &frequency);
							printf("\n");
						}
						flag_frequency = 1;
						break;
					}
				} while (flag_frequency == 0);
				
				Sensor created_sens;
				created_sens.id = (unsigned short)sensor_count + 1;
				created_sens.sensor_type = (unsigned char)create_option;
				created_sens.max_limit = (unsigned short)max_limit;
				created_sens.min_limit = (unsigned short)min_limit;
				created_sens.frequency = (unsigned long)frequency;
				created_sens.consecutive_errors = 0;
				created_sens.readings_size = max_generating_time / frequency;
				created_sens.readings = (unsigned short *)calloc(created_sens.readings_size, sizeof(unsigned short));
				created_sens.error_ocurrences = (unsigned short *)calloc(10, sizeof(unsigned short));
				created_sens.error_ocurrences_index = 0;
				Sensor *temp_ptr;
				switch (create_option)
				{
				case 1:
					if (sens_temp_count == 0)
					{
						temp_ptr = (Sensor *)calloc(1, sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_temp = temp_ptr;
							*(arr_sens_temp + sens_temp_count) = created_sens;
							sens_temp_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					else
					{
						temp_ptr = (Sensor *)realloc(arr_sens_temp, (sens_temp_count + 1) * sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_temp = temp_ptr;
							*(arr_sens_temp + sens_temp_count) = created_sens;
							sens_temp_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					break;
				case 2:
					if (sens_vel_vento_count == 0)
					{
						temp_ptr = (Sensor *)calloc(1, sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_vel_vento = temp_ptr;
							*(arr_sens_vel_vento + sens_vel_vento_count) = created_sens;
							sens_vel_vento_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					else
					{
						temp_ptr = (Sensor *)realloc(arr_sens_vel_vento, (sens_vel_vento_count + 1) * sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_vel_vento = temp_ptr;
							*(arr_sens_vel_vento + sens_vel_vento_count) = created_sens;
							sens_vel_vento_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					break;
				case 3:
					if (sens_dir_vento_count == 0)
					{
						temp_ptr = (Sensor *)calloc(1, sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_dir_vento = temp_ptr;
							*(arr_sens_dir_vento + sens_dir_vento_count) = created_sens;
							sens_dir_vento_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					else
					{
						temp_ptr = (Sensor *)realloc(arr_sens_dir_vento, (sens_dir_vento_count + 1) * sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_dir_vento = temp_ptr;
							*(arr_sens_dir_vento + sens_dir_vento_count) = created_sens;
							sens_dir_vento_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					break;
				case 4:
					if (sens_pluv_count == 0)
					{
						temp_ptr = (Sensor *)calloc(1, sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_pluv = temp_ptr;
							*(arr_sens_pluv + sens_pluv_count) = created_sens;
							sens_pluv_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					else
					{
						temp_ptr = (Sensor *)realloc(arr_sens_pluv, (sens_pluv_count + 1) * sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_pluv = temp_ptr;
							*(arr_sens_pluv + sens_pluv_count) = created_sens;
							sens_pluv_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					break;
				case 5:
					if (sens_hum_atm_count == 0)
					{
						temp_ptr = (Sensor *)calloc(1, sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_hum_atm = temp_ptr;
							*(arr_sens_hum_atm + sens_hum_atm_count) = created_sens;
							sens_hum_atm_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					else
					{
						temp_ptr = (Sensor *)realloc(arr_sens_hum_atm, (sens_hum_atm_count + 1) * sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_hum_atm = temp_ptr;
							*(arr_sens_hum_atm + sens_hum_atm_count) = created_sens;
							sens_hum_atm_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					break;
				case 6:
					if (sens_hum_solo_count == 0)
					{
						temp_ptr = (Sensor *)calloc(1, sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_hum_solo = temp_ptr;
							*(arr_sens_hum_solo + sens_hum_solo_count) = created_sens;
							sens_hum_solo_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					else
					{
						temp_ptr = (Sensor *)realloc(arr_sens_hum_solo, (sens_hum_solo_count + 1) * sizeof(Sensor));
						if (temp_ptr != NULL)
						{
							arr_sens_hum_solo = temp_ptr;
							*(arr_sens_hum_solo + sens_hum_solo_count) = created_sens;
							sens_hum_solo_count++;
							printf("Sensor criado com sucesso.\n");
							sensor_count++;
						}
						else
						{
							printf("Não foi possível criar este sensor.\n");
						}
					}
					break;
				}

			}
			break;

		case 2:
			printf("Qual é o maximo numero de erros consecutivos necessarios para reiniciar um utilizador?\n");
			scanf("%d", &num_errors);
			printf("\n");
			while (num_errors < 0)
			{
				printf("Não existe essa opção. Por favor insira novamente.\n");
				scanf("%d", &num_errors);
				printf("\n");
			}

			Sensor temporary_sensor;
			int posicao_leitura;
			int ult_sens_temp = TEMP_DEFAULT;
			int ult_sens_pluv = PLUV_DEFAULT;
			int current_sensor;
			short generated_value;

			if (result == 0)
			{
				for (int j = 1; j <= max_generating_time; j++)
				{
	
					printf("Tempo: %d s\n",j);
					
					// sensor temperatura
					for (current_sensor = 0; current_sensor < sens_temp_count; current_sensor++)
					{
						
						temporary_sensor = *(arr_sens_temp + current_sensor);

						if (j % temporary_sensor.frequency == 0)
						{
							char rand = (char)pcg32_random_r();
							posicao_leitura = j / temporary_sensor.frequency - 1;

							if (posicao_leitura == 0)
							{
								*(temporary_sensor.readings) = TEMP_DEFAULT;
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;

								ult_sens_temp = TEMP_DEFAULT;
								printf("Foi lido o valor da temperatura %d  para o sensor com o id %d \n", ult_sens_temp, temporary_sensor.id);
							}
							else
							{
								ult_sens_temp = sens_temp(*(temporary_sensor.readings + posicao_leitura - 1), rand);
								*(temporary_sensor.readings + posicao_leitura) = ult_sens_temp;
								printf("\nFoi lido o valor da temperatura %d para o sensor com o id %d \n", ult_sens_temp, temporary_sensor.id);
								if (temporary_sensor.max_limit < ult_sens_temp || ult_sens_temp < temporary_sensor.min_limit)
								{
									temporary_sensor.consecutive_errors = temporary_sensor.consecutive_errors + 1;
									temporary_sensor.error_ocurrences[temporary_sensor.error_ocurrences_index] = posicao_leitura;
									temporary_sensor.error_ocurrences_index = temporary_sensor.error_ocurrences_index + 1;
								}
								else
									temporary_sensor.consecutive_errors = 0;
							}

							if (temporary_sensor.consecutive_errors == num_errors)
							{
								printf("\n####A reiniciar o sensor de temperaturas com id %d ####\n",temporary_sensor.id);
								reset_data_values(temporary_sensor);
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;

							}
							*(arr_sens_temp + current_sensor) = temporary_sensor;
						}
					}

					// sensor velocidade do vento
					for (current_sensor = 0; current_sensor < sens_vel_vento_count; current_sensor++)
					{

						temporary_sensor = *(arr_sens_vel_vento + current_sensor);

						if (j % temporary_sensor.frequency == 0)
						{	
							char rand = (char)pcg32_random_r();
							posicao_leitura = j / temporary_sensor.frequency - 1;

							if (posicao_leitura == 0)
							{
								*(temporary_sensor.readings) = VEL_VENTO_DEFAULT;
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;

								printf("Foi lido o valor da velocidade do vento %d para o sensor com o id %d \n", *(temporary_sensor.readings), temporary_sensor.id);
							}
							else
							{
								generated_value = sens_velc_vento(*(temporary_sensor.readings + posicao_leitura - 1), rand);
								*(temporary_sensor.readings + posicao_leitura) = generated_value;
								printf("\nFoi lido o valor da velocidade do vento %d para o sensor com o id %d \n", generated_value, temporary_sensor.id);
								if (temporary_sensor.max_limit < generated_value || generated_value < temporary_sensor.min_limit)
								{
									temporary_sensor.consecutive_errors = temporary_sensor.consecutive_errors + 1;
									temporary_sensor.error_ocurrences[temporary_sensor.error_ocurrences_index] = posicao_leitura;
									temporary_sensor.error_ocurrences_index = temporary_sensor.error_ocurrences_index + 1;
								}
								else
									temporary_sensor.consecutive_errors = 0;
							}

							if (temporary_sensor.consecutive_errors == num_errors)
							{
								printf("\n####A reiniciar o sensor de velocidade do vento com id %d ####\n",temporary_sensor.id);
								reset_data_values(temporary_sensor);
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;

							}
							*(arr_sens_vel_vento + current_sensor) = temporary_sensor;
						}
					}

					// sensor direção do vento
					for (current_sensor = 0; current_sensor < sens_dir_vento_count; current_sensor++)
					{

						temporary_sensor = *(arr_sens_dir_vento + current_sensor);

						if (j % temporary_sensor.frequency == 0)
						{	
							char rand = (char)pcg32_random_r();
							posicao_leitura = j / temporary_sensor.frequency - 1;
							

							if (posicao_leitura == 0)
							{
								*(temporary_sensor.readings) = DIR_VENTO_DEFAULT;
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;
								printf("Foi lido o valor da direção do vento %d  para o sensor com o id %d \n", *(temporary_sensor.readings), temporary_sensor.id);
							}
							else
							{
								generated_value = sens_dir_vento(*(temporary_sensor.readings + posicao_leitura - 1), rand);
								*(temporary_sensor.readings + posicao_leitura) = generated_value;
								printf("\nFoi lido o valor da direção do vento %d para o sensor com o id %d \n", generated_value, temporary_sensor.id);
								if (temporary_sensor.max_limit < generated_value || generated_value < temporary_sensor.min_limit)
								{
									temporary_sensor.consecutive_errors = temporary_sensor.consecutive_errors + 1;
									temporary_sensor.error_ocurrences[temporary_sensor.error_ocurrences_index] = posicao_leitura;
									temporary_sensor.error_ocurrences_index = temporary_sensor.error_ocurrences_index + 1;
					
								}
								else
								{
									temporary_sensor.consecutive_errors = 0;
								}
							}

							if (temporary_sensor.consecutive_errors == num_errors)
							{
								printf("\n####A reiniciar o sensor da direção do vento com id %d ####\n",temporary_sensor.id);
								reset_data_values(temporary_sensor);
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;

							}
							*(arr_sens_dir_vento + current_sensor) = temporary_sensor;
						}
					}

					// sensor pluviosidade
					for (current_sensor = 0; current_sensor < sens_pluv_count; current_sensor++)
					{
						
						temporary_sensor = *(arr_sens_pluv + current_sensor);

						if (j % temporary_sensor.frequency == 0)
						{	
							char rand = (char)pcg32_random_r();
							posicao_leitura = j / temporary_sensor.frequency - 1;

							if (posicao_leitura == 0)
							{
								*(temporary_sensor.readings) = PLUV_DEFAULT;
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;
								ult_sens_pluv = PLUV_DEFAULT;
								printf("Foi lido o valor da pluviosidade de %d para o sensor com o id %d \n", ult_sens_pluv, temporary_sensor.id);
							}
							else
							{
								ult_sens_pluv = sens_pluvio(*(temporary_sensor.readings + posicao_leitura - 1), ult_sens_temp, rand);
								*(temporary_sensor.readings + posicao_leitura) = ult_sens_pluv;
								printf("\nFoi lido o valor da pluviosidade de %d para o sensor com o id %d \n", ult_sens_pluv, temporary_sensor.id);
								if (temporary_sensor.max_limit < ult_sens_pluv || ult_sens_pluv < temporary_sensor.min_limit)
								{
									temporary_sensor.consecutive_errors = temporary_sensor.consecutive_errors + 1;
									temporary_sensor.error_ocurrences[temporary_sensor.error_ocurrences_index] = posicao_leitura;
									temporary_sensor.error_ocurrences_index = temporary_sensor.error_ocurrences_index + 1;
								}
								else
									temporary_sensor.consecutive_errors = 0;
							}

							if (temporary_sensor.consecutive_errors == num_errors)
							{
								printf("\n####A reiniciar o sensor da pluviosidade com id %d ####\n",temporary_sensor.id);
								reset_data_values_with_dependencies(temporary_sensor);
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;

							}
							*(arr_sens_pluv + current_sensor) = temporary_sensor;
						}
					}

					// sensor humidade atmosferica
					for (current_sensor = 0; current_sensor < sens_hum_atm_count; current_sensor++)
					{
						
						temporary_sensor = *(arr_sens_hum_atm + current_sensor);

						if (j % temporary_sensor.frequency == 0)
						{	
							char rand = (char)pcg32_random_r();
							posicao_leitura = j / temporary_sensor.frequency - 1;

							if (posicao_leitura == 0)
							{
								*(temporary_sensor.readings) = HUM_ATM_DEFAULT;
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;
								printf("Foi lido o valor da humidade atmosferica de %d para o sensor com o id %d \n", *(temporary_sensor.readings), temporary_sensor.id);
							}
							else
							{
								printf("%d\n", ult_sens_temp);
								generated_value = sens_humd_atm(*(temporary_sensor.readings + posicao_leitura - 1), ult_sens_pluv, rand);
								*(temporary_sensor.readings + posicao_leitura) = generated_value;
								printf("Foi lido o valor da humidade atmosferica de %d para o sensor com o id %d \n", *(temporary_sensor.readings + posicao_leitura), temporary_sensor.id);
								if (temporary_sensor.max_limit < generated_value || generated_value < temporary_sensor.min_limit)
								{
									temporary_sensor.consecutive_errors = temporary_sensor.consecutive_errors + 1;
									temporary_sensor.error_ocurrences[temporary_sensor.error_ocurrences_index] = posicao_leitura;
									temporary_sensor.error_ocurrences_index = temporary_sensor.error_ocurrences_index + 1;
								}
								else
									temporary_sensor.consecutive_errors = 0;
							}

							if (temporary_sensor.consecutive_errors == num_errors)
							{
								printf("\n####A reiniciar o sensor da humidade atmosferica com id %d ####\n",temporary_sensor.id);
								reset_data_values_with_dependencies(temporary_sensor);
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;

							}
							*(arr_sens_hum_atm + current_sensor) = temporary_sensor;
						}
					}

					// sensor humidade solo
					for (current_sensor = 0; current_sensor < sens_hum_solo_count; current_sensor++)
					{

						temporary_sensor = *(arr_sens_hum_solo + current_sensor);

						if (j % temporary_sensor.frequency == 0)
						{	
							char rand = (char)pcg32_random_r();
							posicao_leitura = j / temporary_sensor.frequency - 1;

							if (posicao_leitura == 0)
							{
								*(temporary_sensor.readings) = HUM_SOLO_DEFAULT;
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;

								printf("Foi lido o valor da humidade do solo de %d para o sensor com o id %d \n", *(temporary_sensor.readings), temporary_sensor.id);
							}
							else
							{
								generated_value = sens_humd_solo(*(temporary_sensor.readings + posicao_leitura - 1), ult_sens_pluv, rand);
								*(temporary_sensor.readings + posicao_leitura) = generated_value;
								printf("Foi lido o valor da humidade do solo de %d para o sensor com o id %d \n", *(temporary_sensor.readings + posicao_leitura), temporary_sensor.id);
								if (temporary_sensor.max_limit < generated_value || generated_value < temporary_sensor.min_limit)
								{
									temporary_sensor.consecutive_errors = temporary_sensor.consecutive_errors + 1;
									temporary_sensor.error_ocurrences[temporary_sensor.error_ocurrences_index] = posicao_leitura;
									temporary_sensor.error_ocurrences_index = temporary_sensor.error_ocurrences_index + 1;
								}
								else
									temporary_sensor.consecutive_errors = 0;
							}

							if (temporary_sensor.consecutive_errors == num_errors)
							{
								printf("\n####A reiniciar o sensor da humidade do solo com id %d ####\n",temporary_sensor.id);
								reset_data_values_with_dependencies(temporary_sensor);
								temporary_sensor.consecutive_errors = 0;
								temporary_sensor.error_ocurrences_index=0;

							}
							*(arr_sens_hum_solo + current_sensor) = temporary_sensor;
						}
					}

					sleep(1);
					printf("-----------------------------------------------------\n");
				}
			}

			matrixGeneral(arr_sens_temp, sens_temp_count,
						  arr_sens_vel_vento, sens_vel_vento_count,
						  arr_sens_dir_vento, sens_dir_vento_count,
						  arr_sens_hum_atm, sens_hum_atm_count,
						  arr_sens_hum_solo, sens_hum_solo_count,
						  arr_sens_pluv, sens_pluv_count);

			break;

		case 3:
			do
			{
				printf("Qual o tipo de sensor deseja remover? (digite o número da opção)\n");
				printf("1 - Sensor de temperatura\n");
				printf("2 - Sensor de velocidade do vento\n");
				printf("3 - Sensor de direção do vento\n");
				printf("4 - Sensor de pluviosidade\n");
				printf("5 - Sensor de humidade da atmosfera\n");
				printf("6 - Sensor de humidade do solo\n");
				printf("7 - Sair\n");
				scanf("%d", &option);
				switch (option)
				{
				case 1:
					sens_temp_count = menuRemoveSensor(sens_temp_count, arr_sens_temp);
					if (sens_temp_count == 0)
					{
						arr_sens_temp = NULL;
					}
					break;
				case 2:;
					sens_vel_vento_count = menuRemoveSensor(sens_vel_vento_count, arr_sens_vel_vento);
					if (sens_vel_vento_count == 0)
					{
						arr_sens_vel_vento = NULL;
					}
					break;
				case 3:;
					sens_dir_vento_count = menuRemoveSensor(sens_dir_vento_count, arr_sens_dir_vento);
					if (sens_dir_vento_count == 0)
					{
						arr_sens_dir_vento = NULL;
					}
					break;
				case 4:;
					sens_pluv_count = menuRemoveSensor(sens_pluv_count, arr_sens_pluv);
					if (sens_pluv_count == 0)
					{
						arr_sens_pluv = NULL;
					}
					break;
				case 5:;
					sens_hum_atm_count = menuRemoveSensor(sens_hum_atm_count, arr_sens_hum_atm);
					if (sens_hum_atm_count == 0)
					{
						arr_sens_hum_atm = NULL;
					}
					break;
				case 6:;
					sens_hum_solo_count = menuRemoveSensor(sens_hum_solo_count, arr_sens_hum_solo);
					if (sens_hum_solo_count == 0)
					{
						arr_sens_hum_solo = NULL;
					}
					break;
				case 7:
					break;
				default:
					printf("Essa opção não existe!\n");
					break;
				}
			} while (option > 7 || option < 1);
			break;
		case 4:

			do
			{
				printf("Qual o tipo de sensor que deseja alterar a frequência (digite o número da opção)\n");
				printf("1 - Sensor de temperatura\n");
				printf("2 - Sensor de velocidade do vento\n");
				printf("3 - Sensor de direção do vento\n");
				printf("4 - Sensor de pluviosidade\n");
				printf("5 - Sensor de humidade da atmosfera\n");
				printf("6 - Sensor de humidade do solo\n");
				printf("7 - Sair\n");
				scanf("%d", &option);
				switch (option)
				{
				case 1:
					menu_change_frequency(sens_temp_count, arr_sens_temp, max_generating_time);
					break;
				case 2:;
					menu_change_frequency(sens_vel_vento_count, arr_sens_vel_vento, max_generating_time);
					break;
				case 3:;
					menu_change_frequency(sens_dir_vento_count, arr_sens_dir_vento, max_generating_time);
					break;
				case 4:;
					menu_change_frequency(sens_pluv_count, arr_sens_pluv, max_generating_time);
					break;
				case 5:;
					menu_change_frequency(sens_hum_atm_count, arr_sens_hum_atm, max_generating_time);
					break;
				case 6:;
					menu_change_frequency(sens_hum_solo_count, arr_sens_hum_solo, max_generating_time);
					break;
				case 7:
					break;
				default:
					printf("Essa opção não existe!\n");
					break;
				}
			} while (option > 7 || option < 1);
			break;
		case 5:;
			char *filenameSensor = malloc(sizeof(char) * 100);
			printf("Digite o nome do ficheiro: ");

			scanf("%s", filenameSensor);

			exportData(filenameSensor, arr_sens_temp, arr_sens_dir_vento, arr_sens_vel_vento, arr_sens_hum_atm, arr_sens_hum_solo, arr_sens_pluv, numberOfSensors);

			free(filenameSensor);
			break;
		case 6:;
			char *filenameMatrix = malloc(sizeof(char) * 100);
			if (filenameMatrix == NULL)
			{
				printf("Erro ao alocar memória");
				exit(1);
			}
			printf("Digite o nome do ficheiro: ");
			scanf("%s", filenameMatrix);
			// create a pointer to the matrix[6][3];
			exportMatrixData(filenameMatrix, sens_temp_count, sens_vel_vento_count, sens_dir_vento_count, sens_pluv_count, sens_hum_atm_count, sens_hum_solo_count);
			free(filenameMatrix);
			break;
		case 7:
			break;
		}
	} while (start_option != 7);

	return 0;
}
