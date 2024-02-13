#include <stdio.h> 
#include <stdint.h>
#include "sensor_struct.h"
#include "sensores.h"
#include "demo_pcg.h"
#include "read_rnd.h"
#include <unistd.h>
#include "constants.h"

void reset_data_values(Sensor s)
{	
	
	int i = 0;
	int result = read_rnd();
	int type = s.sensor_type;
	unsigned short lastValue;
	
	
	if (result==0){
		while(i<s.error_ocurrences_index)
		{

			char rand = (char) pcg32_random_r();
			int ocurrence = s.error_ocurrences[i];
			
			switch(type){
				case 1: 
					if (ocurrence-1 == -1)
					{
						s.readings[ocurrence] = sens_temp((s.min_limit+s.max_limit)/2, rand);
					}else{
						s.readings[ocurrence] = sens_temp(s.readings[ocurrence-1], rand);
					}
					break;
				case 2: 
					if (ocurrence-1 == -1)
					{
						s.readings[ocurrence] = sens_velc_vento((s.min_limit+s.max_limit)/2, rand);
					}else{
						s.readings[ocurrence] = sens_velc_vento(s.readings[ocurrence-1], rand);
					}
					break;
				case 3: 
					
					if (ocurrence-1 == -1)
					{
						lastValue = sens_dir_vento((s.min_limit+s.max_limit)/2, rand);
						s.readings[ocurrence] = lastValue;
					}else{
						lastValue = sens_dir_vento(s.readings[ocurrence-1], rand);
						s.readings[ocurrence] = lastValue;
					}
					break;
			}
			
			
			printf("\n####Valor produzido para posição %d: %d####\n", s.error_ocurrences[i]+1, s.readings[ocurrence]);
			
			if(s.max_limit>=s.readings[ocurrence] && s.readings[ocurrence]>=s.min_limit)
			{
				i++;
			}
		
		}
	}
		
	s.consecutive_errors = 0;
	i=0;
	s.error_ocurrences_index = 0;
	
}

void reset_data_values_with_dependencies(Sensor s)
{	
	int i = 0;
	int result = read_rnd();
	char type = s.sensor_type;
	
	
	
	if (result==0)
	{
		while(i<s.error_ocurrences_index)
		{
			char rand = (char) pcg32_random_r();
			int ocurrence = s.error_ocurrences[i];
			
			switch(type){
				case 4: 
					if (ocurrence -1 ==-1)
					{
						s.readings[ocurrence] = sens_pluvio((s.min_limit+s.max_limit)/2, TEMP_DEFAULT, rand);
					}else{
						s.readings[ocurrence] = sens_pluvio(s.readings[ocurrence-1], TEMP_DEFAULT, rand);
					}
					break;
				case 5: 
					if (ocurrence -1 == -1) {
						s.readings[ocurrence] = sens_humd_atm((s.min_limit+s.max_limit)/2, PLUV_DEFAULT, rand);
					}else{
					s.readings[ocurrence] = sens_humd_atm(s.readings[ocurrence-1], PLUV_DEFAULT, rand);
					}
					break;
				case 6: 
					if (ocurrence -1 ==-1)
					{
						s.readings[ocurrence] = sens_humd_solo((s.min_limit+s.max_limit)/2, PLUV_DEFAULT, rand);
					}else{
						s.readings[ocurrence] = sens_humd_solo(s.readings[ocurrence-1], PLUV_DEFAULT, rand);
					}
					break;
			}
			
			printf("\n####Valor produzido para posição %d: %d####\n", ocurrence, s.readings[s.error_ocurrences[i]]);
			
			if(s.max_limit>=s.readings[ocurrence]&&s.readings[ocurrence]>=s.min_limit)
			{
				i++;
			}
			
			
			
		}
	}
		
	s.consecutive_errors = 0;
	i=0;
	s.error_ocurrences_index = 0;
	
}



