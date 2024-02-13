#ifndef SENSOR_STRUCT_H
#define SENSOR_STRUCT_H
typedef struct {
	unsigned short id;
	unsigned char sensor_type;
	unsigned short max_limit; 
	unsigned short min_limit;
	unsigned long frequency;
	unsigned long readings_size;
	unsigned short *readings; 
	unsigned int consecutive_errors;
	unsigned short* error_ocurrences;
	unsigned short error_ocurrences_index;
 } Sensor;
#endif
