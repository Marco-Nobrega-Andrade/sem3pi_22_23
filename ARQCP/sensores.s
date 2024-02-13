.section .data
.section .text
	.global sens_temp
	.global sens_velc_vento
	.global sens_dir_vento
	.global sens_pluvio
	.global sens_humd_atm
	.global sens_humd_solo


#----------------------------------------sens_temp

sens_temp:
	
	movb %sil,%al
	movb $40, %bl				#a cada 40 valores a temperatura sobe ou desce 1 Grau
	cbtw
	idivb %bl
	addb %dil,%al				#soma o valor anterior mais o valor obtido
	
	jmp end
	
#----------------------------------------sens_velc_vento
	
sens_velc_vento:
	
	movb %sil,%al
	movb $10, %bl				#a cada 10 valores a velocidade do vento sobe ou desce 1 km/h
	cbtw
	idivb %bl

	addb %dil,%al				#soma o valor anterior mais o valor obtido
	cmpb $0,%al
	jge end
	movb $0,%al
	jmp end
	

#----------------------------------------sens_dir_vento	
sens_dir_vento:

	movsbw %sil,%ax
	movw $25, %bx				#a cada 25 valores a direção do vento anda 1 Grau
	cwtd
	idivw %bx
	
	addw %di,%ax				#soma o valor anterior com o valor obtido
	cmpw $359,%ax
	jg greater_than_359			#verifica se o valor da soma é maior que 359
	cmpw $0,%ax
	jl lower_than_0				#verifica se o valor da soma é inferior que 359
	
	jmp end
	
greater_than_359:
	
	movw $360, %cx
	subw %cx,%ax
	jmp end

lower_than_0:
	
	movw $360, %cx
	addw %cx,%ax
	jmp end


end:
	ret

#----------------------------------------sens_pluvio
 sens_pluvio:
	movb %dl,%al
	cmpb $28, %sil				#temperatura alta se > 28
	jg high_temp
	cmpb $17, %sil				#temperatura média se > 17
	jg medium_temp
	cbtw
	movb $10, %bl				
	idivb %bl					#reduzir o rand para ficar entre valores -5 e 5
	jmp add_rand
	
 high_temp:					
	movb $100, %bl
	cbtw
	idivb %bl					#reduzir o rand para não fazer muita diferença
	jmp add_rand
	
 medium_temp:					
	movb $35, %bl
	cbtw
	idivb %bl					#reduzir o rand para não fazer muita diferença
	jmp add_rand
	
 add_rand:						
	addb %al,%dil				#ultimo valor + rand
	movl $0,%eax				#limpar %rax para o return
	cmpb $0,%dil
	jg positive_value			
	movb $0,%al
	jmp end_pluv
 positive_value:
	movb %dil,%al
 end_pluv:
	ret

#----------------------------------------sens_humd_atm

 sens_humd_atm:
	movb %dl,%al
	cmpb $0, %sil				#hum não aumenta se pluv = 0
	je zero_pluv
	cmpb $25, %sil				#pluviosidade alta se > 25
	ja high_pluv
	movb $25, %bl
	cbtw
	idivb %bl
	jmp add_rand_hum_atm
	
 zero_pluv:
	movb $0,%al
	jmp add_rand_hum_atm
	
 high_pluv:
	movb $5, %bl
	cbtw
	idivb %bl
	
 add_rand_hum_atm:
	addb %al,%dil				#ultimo valor + rand
	movl $0,%eax				#limpar %rax para o return
	cmpb $100,%dil
	jg greater_than_100
	cmpb $0,%dil
	jl lower_than_0_hum_atm
	movb %dil,%al
	jmp end_hum_atm 
	
 greater_than_100:
	movb $100,%al
	jmp end_hum_atm	
	
 lower_than_0_hum_atm:
	movb $0,%al
	
 end_hum_atm:
	ret
	
#----------------------------------------sens_humd_solo

 sens_humd_solo:
	movb %dl,%al
	cmpb $0, %sil				#hum não aumenta se pluv = 0
	je zero_pluv_solo
	cmpb $25, %sil				#pluviosidade alta se > 25
	ja high_pluv_solo
	movb $25, %bl
	cbtw
	idivb %bl
	jmp add_rand_hum_solo
	
 zero_pluv_solo:
	movb $0,%al
	jmp add_rand_hum_solo
	
 high_pluv_solo:
	movb $5, %bl
	cbtw
	idivb %bl
	
 add_rand_hum_solo:
	addb %al,%dil				#ultimo valor + rand
	movl $0,%eax				#limpar %rax para o return
	cmpb $100,%dil
	jg greater_than_100_solo
	cmpb $0,%dil
	jl lower_than_0_hum_solo
	movb %dil,%al
	jmp end_hum_solo 
	
 greater_than_100_solo:
	movb $100,%al
	jmp end_hum_solo	
	
 lower_than_0_hum_solo:
	movb $0,%al
	
 end_hum_solo:
	ret
	







