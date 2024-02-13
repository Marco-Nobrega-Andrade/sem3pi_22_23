prog: demo_pcg.o read_rnd.o main.o sensores.o checks.o matriz.o exportMatrixData.o change_sensor.o exportData.o
	gcc demo_pcg.o read_rnd.o main.o sensores.o exportMatrixData.o checks.o matriz.o change_sensor.o exportData.o -o prog

main.o: main.c
	gcc -g -Wall -c main.c -o main.o
	
read_rnd.o: read_rnd.c read_rnd.h
	gcc -g -Wall -c read_rnd.c -o read_rnd.o
	
checks.o: checks.c
	gcc -g -Wall -c checks.c -o checks.o

demo_pcg.o: demo_pcg.s demo_pcg.h
	gcc -g -Wall -c demo_pcg.s -o demo_pcg.o
	
sensores.o: sensores.s sensores.h
	gcc -g -Wall -c sensores.s -o sensores.o
matriz.o: matriz.c matriz.h
	gcc -g -Wall -c matriz.c -o matriz.o
	
exportMatrixData.o: exportMatrixData.c exportMatrixData.h
	gcc -g -Wall -c exportMatrixData.c -o exportMatrixData.o

change_sensor.o: change_sensor.c change_sensor.h
	gcc -g -Wall -c change_sensor.c -o change_sensor.o
	
exportData.o: exportData.c exportData.h
	gcc -g -Wall -c exportData.c -o exportData.o			

clean: 
	rm -f *.o prog

run: prog
	./prog

debug: prog
	gdb ./prog
