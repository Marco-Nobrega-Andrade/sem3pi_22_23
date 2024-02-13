#include <stdio.h>
#include "sensor_struct.h"
#define numberOfSensors 6
#define numColumns 3
extern double matrix[numberOfSensors][numColumns];


double calculateMaxInSensor(Sensor* sensor_array, int sensorTypeSize){
    double max = 0;
    for(int i = 0; i<sensorTypeSize; i++){
        unsigned short * ptr_array = sensor_array[i].readings;
        for(long j = 0; j < sensor_array[i].readings_size; j++){
            if(*(ptr_array + j) > max)
                max = (double)*(ptr_array + j);
        }
    }
    return max;
}

double calculateMinInSensor(Sensor* sensor_array, int sensorTypeSize){
    double min = 1.7976931348623157E+308;
    for(int i = 0; i<sensorTypeSize; i++){
        unsigned short * ptr_array = sensor_array[i].readings;
        for(long j = 0; j < sensor_array[i].readings_size; j++)
            if(*(ptr_array + j) < min)
                min = (double)*(ptr_array + j);
    }
    if(sensorTypeSize == 0){
        min = -1;
    }
    return min;
}

double calculateAverageInSensor(Sensor* sensor_array, int sensorTypeSize){
    double sum = 0;
    double counter;
    for(long i = 0; i<sensorTypeSize; i++){
        unsigned short * ptr_array = sensor_array[i].readings;
        for(long j = 0; j < sensor_array[i].readings_size; j++){
                sum += (double) *(ptr_array + j);
                counter++;
        }
    }
    if(sensorTypeSize == 0){
        return 0;
    }
    return sum/counter;
}
void insertInMatrix(int sensorNum, Sensor* sensor, int sensorSize){
    matrix[sensorNum - 1][0] = calculateMaxInSensor(sensor, sensorSize);
    matrix[sensorNum - 1][1] = calculateMinInSensor(sensor, sensorSize);
    matrix[sensorNum - 1][2] = calculateAverageInSensor(sensor, sensorSize);
}

void createMatrix(Sensor *sensor1, int sensor1_count,
                     Sensor *sensor2,int sensor2_count, 
                     Sensor *sensor3, int sensor3_count, 
                     Sensor *sensor4, int sensor4_count, 
                     Sensor *sensor5, int sensor5_count,
                     Sensor *sensor6, int sensor6_count){

    insertInMatrix(1, sensor1, sensor1_count);
    insertInMatrix(2, sensor2, sensor2_count);
    insertInMatrix(3, sensor3, sensor3_count);
    insertInMatrix(4, sensor4, sensor4_count);
    insertInMatrix(5, sensor5, sensor5_count);
    insertInMatrix(6, sensor6, sensor6_count);
}

void printMatrixValues(int i){
        printf("%7.1f",matrix[i][0]);
        for(int j=1;j<3;j++){
            printf("%9.1f",matrix[i][j]);
        }
        printf("\n");
}

void printMatrix(int sensor1_count, int sensor2_count, int sensor3_count, int sensor4_count, int sensor5_count, int sensor6_count){
    printf("--------------------------------------------------------\n");
    printf("                      | Máximo | Mínimo | Média |\n");
    for(int i = 0; i < numberOfSensors; i++){
     switch(i){
        case 0:
            if(sensor1_count > 0){
                printf("Temperatura:          ");
                printMatrixValues(i);
            }
            break;
        case 1:
            if(sensor2_count > 0){
                printf("Velocidade do vento:  ");
                printMatrixValues(i);
            }
            break;
        case 2:
            if(sensor3_count > 0){
                printf("Direção a vento:      ");
                printMatrixValues(i);
            }
            break;
        case 3:
            if(sensor4_count > 0){
                printf("Humidade atmosférica: ");
                printMatrixValues(i);
            }
            break;
        case 4:
            if(sensor5_count > 0){
                printf("Humidade do solo:     ");
                printMatrixValues(i);
            }
            break;
        case 5:
            if(sensor6_count > 0){
               printf("Pluviosidade:         ");
                printMatrixValues(i);
            }
            break;
        }
    }
}

void matrixGeneral(Sensor *sensor1, int sensor1_count,
                     Sensor *sensor2,int sensor2_count, 
                     Sensor *sensor3, int sensor3_count, 
                     Sensor *sensor4, int sensor4_count, 
                     Sensor *sensor5, int sensor5_count,
                     Sensor *sensor6, int sensor6_count){

    createMatrix(sensor1, sensor1_count,
                     sensor2, sensor2_count, 
                     sensor3, sensor3_count, 
                     sensor4, sensor4_count, 
                     sensor5, sensor5_count,
                     sensor6, sensor6_count);

    printMatrix(sensor1_count,sensor2_count,sensor3_count,sensor4_count,sensor5_count,sensor6_count);
}
