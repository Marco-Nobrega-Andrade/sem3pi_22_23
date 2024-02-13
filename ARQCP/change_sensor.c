#include <stdio.h>
#include <stdlib.h>
#include "sensor_struct.h"
int menuRemoveSensor(int counter, Sensor * ptr){
	int chosen_option;
	int correct_counter = 0;
	Sensor * new_ptr = NULL;
	if(ptr == NULL){
		printf("Não existem sensores para serem removidos!\n\n");
	}else{
		printf("Qual o sensor deseja remover? (digite o número da opção)\n"); 
		for(int i = 1; i <= counter; i++){
			printf("%d - Id do Sensor: %d\n", i, ptr[i-1].id);
		}
		scanf("%d", &chosen_option);
		printf("\n");
		if(counter > 1){
			new_ptr = (Sensor *) calloc((counter-1),sizeof(Sensor));
            free((ptr+(chosen_option - 1))->readings);
			if(new_ptr != NULL){
				for(int j = 0; j < counter; j++){
					if(j != (chosen_option - 1)){
						*(new_ptr+correct_counter) = *(ptr+j);
						correct_counter++;
					}
				}
				ptr = (Sensor *) realloc(ptr,(counter-1) * sizeof(Sensor));
				for(int j = 0; j < counter - 1; j++){
					*(ptr+j) = *(new_ptr+j);
				}
			}else{
				printf("O seu sensor não foi removido com sucesso!\n\n");
				return counter;
			}
			free(new_ptr);
		}
		counter--;
		printf("O seu sensor foi removido com sucesso!\n\n");
	}
	return counter;
}

void menu_change_frequency(int counter, Sensor * ptr, int max_generating_time){
	
	int chosen_option;
	unsigned long new_frequency = 0;
	unsigned long new_readings_size = 0;
	
	if(ptr == NULL){
		printf("Não existem sensores para serem removidos!\n\n");
	}else{
		do{
		printf("Qual o sensor que deseja alterar a frequência? (digite o número da opção)\n"); 
		for(int i = 1; i <= counter; i++){
			printf("%d - Id do Sensor: %d\n", i, ptr[i-1].id);
		}
		scanf("%d", &chosen_option);
		if((chosen_option<1 || chosen_option>counter)) printf("\nDeve escolher uma das opções apresentadas! \n");
		}while(chosen_option<1 || chosen_option>counter);
		
		do{
		printf("\nIntroduza a nova frequência: \n");
		scanf("%ld", &new_frequency);
		if(new_frequency<0) printf("\nA frequêcnia não pode ter valor negativo! \n");
		}while(new_frequency<0);
		
		ptr[chosen_option-1].frequency = new_frequency;
		new_readings_size = max_generating_time/new_frequency;
		ptr[chosen_option-1].readings_size = new_readings_size;
		free(ptr[chosen_option-1].readings);
		ptr[chosen_option-1].readings = (unsigned short *) calloc(ptr[chosen_option-1].readings_size,sizeof(unsigned short));
		printf("\nA frequência do sensor foi alterada!\n");
		printf("O vetor de readings foi alterado em conformidade com a nova frequência!\n\n");

    }
}