CREATE OR REPLACE procedure insert_all_input_sensor
    is
    n_total_registos_lidos  number := 0;
    n_registos_transferidos number := 0;
    n_registos_errados      number := 0;
    v_tuple                 array_t;
    v_input_sensor_atual    INPUTSENSOR.INPUT_STRING%type;
    v_contador              number := 0;
CURSOR c_input_sensor IS
SELECT *
FROM INPUTSENSOR;
begin
OPEN c_input_sensor;
LOOP
FETCH c_input_sensor into v_input_sensor_atual;
        EXIT WHEN c_input_sensor%notfound;
        v_tuple := input_string_to_tuple(v_input_sensor_atual);
        n_total_registos_lidos := n_total_registos_lidos + 1;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_tuple(1) || ' Tipo: ' || v_tuple(2) || ' Valor lido: ' || v_tuple(3) ||
                             ' Valor referencia: ' || v_tuple(4) || ' Data: ' || v_tuple(5) || ' Erros: ' ||
                             v_tuple(6));
        if (v_tuple(6) = '0') then
Select count(id_sensor_pk)
into v_contador
from Sensor
where to_number(id_sensor_pk) = to_number(v_tuple(1));
if (v_contador = 0) then
                insert into Sensor values (v_tuple(1), 1, v_tuple(2), v_tuple(4));
end if;
            n_registos_transferidos := n_registos_transferidos + 1;
insert into LeituraSensor
values (default, v_tuple(1), v_tuple(3), TO_DATE(v_tuple(5), 'DD/MM/YYYYHH24:MI'));
delete from InputSensor where input_string = v_input_sensor_atual;
else
            insert into Erro values (default, v_tuple(6), v_tuple(1));
            n_registos_errados := n_registos_errados + 1;
end if;
END LOOP;
CLOSE c_input_sensor;
DBMS_OUTPUT.PUT_LINE(SYSDATE);
    DBMS_OUTPUT.PUT_LINE('Total de registos lidos: ' || n_total_registos_lidos || 'Total de registos transferidos: ' ||
                         n_registos_transferidos || 'Total de registos errados: ' || n_registos_errados);
commit;
end;

drop procedure insert_all_input_sensor;