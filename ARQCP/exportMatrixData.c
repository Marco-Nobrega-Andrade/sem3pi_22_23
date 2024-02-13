//
// Created by David Dias-1211415.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define numberOfSensors 6
#define numColumns 3
int contador = 0;
extern double matrix[numberOfSensors][numColumns];

char* toStringMatrixData(int line){
    //convert to string all the values that the pointer matrix has with size numColum and store it in a string
    char *matrix_string = (char*)malloc(sizeof (matrix)*numColumns);
    contador++;
    switch (contador) {
        case 1:
            strcat(matrix_string, "TA");
            break;
        case 2:
            strcat(matrix_string, "VV");
            break;
        case 3:
            strcat(matrix_string, "DV");
            break;
        case 4:
            strcat(matrix_string, "HA");
            break;
        case 5:
            strcat(matrix_string, "HS");
            break;
        case 6:
            strcat(matrix_string, "PL");
            break;
    }
    strcat(matrix_string, ";");
    for (int i = 0; i < numColumns; i++) {
        sprintf(matrix_string + strlen(matrix_string), "%f", matrix[line][i]);
        if(i!=numColumns-1){
            strcat(matrix_string, ";");
        }
    }
    return matrix_string;
}

char** toStringAllMatrixData(){
    //create a string matrix
    char** stringMatrix = (char**)malloc(sizeof(char*)*numberOfSensors);
    for (int i = 0; i < numberOfSensors; i++) {
        *(stringMatrix+i) = (char*)malloc(sizeof(char)*numColumns);
        *(stringMatrix+i) = toStringMatrixData(i);
    }
    return stringMatrix;
}

int exportMatrixData(char *filename, int sensor1_count, int sensor2_count, int sensor3_count, int sensor4_count, int sensor5_count, int sensor6_count){

    char **data = toStringAllMatrixData();

    if (data == NULL) {
        fprintf(stderr, "Erro: não foi possível obter os dados da matriz\n");
    }

    FILE *fp = fopen(filename, "w");
    if (fp == NULL){
        perror("Erro ao tentar abrir o ficheiro");
        return -1;
    }

    fprintf(fp,"%s","tipo sensor;maximo;minimo;media");
    fprintf(fp, "\n");


    if (sensor1_count>0) {
        fprintf(fp, "%s", *(data + 0));
        // Adiciona um enter depois de cada linha
        fprintf(fp, "\n");
    }
    if (sensor2_count>0) {
        fprintf(fp, "%s", *(data + 1));
        // Adiciona um enter depois de cada linha
        fprintf(fp, "\n");
    }

    if (sensor3_count>0) {
        fprintf(fp, "%s", *(data + 2));
        // Adiciona um enter depois de cada linha
        fprintf(fp, "\n");
    }

    if (sensor4_count>0) {
        fprintf(fp, "%s", *(data + 3));
        // Adiciona um enter depois de cada linha
        fprintf(fp, "\n");
    }

    if (sensor5_count>0) {
        fprintf(fp, "%s", *(data + 4));
        // Adiciona um enter depois de cada linha
        fprintf(fp, "\n");
    }

    if (sensor6_count>0) {
        fprintf(fp, "%s", *(data + 5));
        // Adiciona um enter depois de cada linha
        fprintf(fp, "\n");
    }

    for (int i = 0; i < numberOfSensors; i++) {
        free(*(data+i));
    }
    free(data);
    contador=0;
    fclose(fp);
    return 0;
}