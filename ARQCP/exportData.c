//
// Created by David Dias-1211415.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sensor_struct.h"

char* toStringData(Sensor *s){

    unsigned short id = s->id;
    unsigned char sensor_type = s->sensor_type;
    unsigned short max_limit = s->max_limit;
    unsigned short min_limit = s->min_limit;
    unsigned long frequency = s->frequency;
    unsigned long readings_size = s->readings_size;
    unsigned short *readings = s->readings;

    //convert to string all the data
    char *string = (char*)malloc(sizeof(id)+sizeof(sensor_type)+sizeof(max_limit)+sizeof(min_limit)+sizeof(frequency)+sizeof(readings_size)+sizeof(readings_size));

    sprintf(string, "%hu", id);
    strcat(string, ";");

    //identify sensor_type and convert to string
    switch (sensor_type) {
        case 1:
            strcat(string, "TA");
            break;
        case 2:
            strcat(string, "VV");
            break;
        case 3:
            strcat(string, "DV");
            break;
        case 4:
            strcat(string, "HA");
            break;
        case 5:
            strcat(string, "HS");
            break;
        case 6:
            strcat(string, "PL");
            break;
        default:
            strcat(string, "Unknown");
            break;
    }
    strcat(string, ";");

    sprintf(string + strlen(string), "%hu", max_limit);
    strcat(string, ";");
    sprintf(string + strlen(string), "%hu", min_limit);
    strcat(string, ";");
    sprintf(string + strlen(string), "%lu", frequency);
    strcat(string, ";");
    sprintf(string + strlen(string), "%lu", readings_size);
    strcat(string, ";");

    for (int i = 0; i < readings_size; i++) {
        sprintf(string + strlen(string), "%hu", *(readings+i));
        if(i!=readings_size-1){
            strcat(string, "-");
        }
    }
    return string;
}

char** toStringAllData(Sensor *s1,Sensor *s2,Sensor *s3,Sensor *s4,Sensor *s5,Sensor *s6, int numS){

    //create a loop to send all the sensors to the toStringData function
    char** data;
    data = malloc(numS*sizeof(char*));

    if (data == NULL) {
        fprintf(stderr, "Erro: não foi possível alocar a memória\n");
        return NULL;
    }

    char *string = toStringData(s1);
    *(data + 0) = malloc(sizeof(string));
    if (*(data + 0) == NULL) {
        fprintf(stderr, "Erro: não foi possível alocar a memória\n");
        return NULL;
    }
    strcpy(*(data + 0), string);
    free(string);

    string = toStringData(s2);
    *(data+1) = malloc(sizeof(string));
    if (*(data+1) == NULL) {
        fprintf(stderr, "Erro: não foi possível alocar a memória\n");
        return NULL;
    }
    strcpy(*(data+1), string);
    free(string);

    string = toStringData(s3);
    *(data+2) = malloc(sizeof(string));
    if (*(data+2) == NULL) {
        fprintf(stderr, "Erro: não foi possível alocar a memória\n");
        return NULL;
    }
    strcpy(*(data+2), string);
    free(string);

    string = toStringData(s4);
    *(data+3) = malloc(sizeof(string));
    if (*(data+3) == NULL) {
        fprintf(stderr, "Erro: não foi possível alocar a memória\n");
        return NULL;
    }
    strcpy(*(data+3), string);
    free(string);

    string = toStringData(s5);
    *(data+4) = malloc(sizeof(string));
    if (*(data+4) == NULL) {
        fprintf(stderr, "Erro: não foi possível alocar a memória\n");
        return NULL;
    }
    strcpy(*(data+4), string);
    free(string);

    string = toStringData(s6);
    *(data+5) = malloc(sizeof(string));
    if (*(data+5) == NULL) {
        fprintf(stderr, "Erro: não foi possível alocar a memória\n");
        return NULL;
    }
    strcpy(*(data+5), string);
    free(string);

    return data;
}

int exportData(char *filename, Sensor *s1,Sensor *s2,Sensor *s3,Sensor *s4,Sensor *s5,Sensor *s6, int numS){

    // get the data
    char** data = toStringAllData(s1,s2,s3,s4,s5,s6,numS);

    if(data==NULL){
        fprintf(stderr, "Erro: não foi possível obter os dados\n");
    }

    // open the file in write mode
    FILE* fp = fopen(filename, "w");

    // check if file it's open
    if (fp == NULL) {
        perror("Erro ao tentar abrir o ficheiro");
        return 1;
    }

    fprintf(fp,"%s","id;tipo sensor;limite max;limite min;frequencia;tamanho leitura;leituras");
    fprintf(fp, "\n");
    //
    for (int i = 0; i < numS; i++) {
        fprintf(fp, "%s", *(data+i));
        // Adiciona um enter depois de cada linha
        fprintf(fp, "\n");
    }

    // Fecha o ficheiro
    fclose(fp);

    // Liberta a memória
    for (int i = 0; i < numS; i++) {
        free(*(data+i));
    }
    free(data);
    return 0;
}