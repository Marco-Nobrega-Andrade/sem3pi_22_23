#ifndef MATRIZ_H
#define MATRIZ_H
#define numberOfSensors 6
#define numColumns 3
extern double matrix[numberOfSensors][numColumns];

void matrixGeneral(Sensor *sensor1, int sensor1_count,
                     Sensor *sensor2,int sensor2_count,
                     Sensor *sensor3, int sensor3_count,
                     Sensor *sensor4, int sensor4_count,
                     Sensor *sensor5, int sensor5_count,
                     Sensor *sensor6, int sensor6_count);
                     
#endif