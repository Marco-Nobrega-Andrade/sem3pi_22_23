#ifndef CHECKS_H
#define CHECKS_H
char check_data_value(char value, int i, Sensor s);
unsigned char check_reseted_data_value(unsigned char value, Sensor s);
void reset_data_values_with_dependencies(Sensor s);
#endif
