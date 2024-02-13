CREATE OR REPLACE FUNCTION input_string_to_tuple(
    p_input_sensor INPUTSENSOR.INPUT_STRING%type
)
    RETURN array_t
    IS
    v_id_sensor        CHAR(5);
    v_tipo_sensor      char(2);
    v_valor_lido       char(3);
    v_valor_referencia char(3);
    v_dia        char(2);
    v_mes        char(2);
    v_ano        char(4);
    v_hora        char(2);
    v_minuto        char(2);
    v_data char(16);
    v_num_erros number(2);
    v_tuple array_t;
BEGIN
    v_num_erros := 0;
    if LENGTH(p_input_sensor) != 25 then
        v_num_erros := v_num_erros + 1;
        v_tuple := array_t();
        v_tuple.extend(6);
        v_tuple(1) := SUBSTR(p_input_sensor, 1, 5);
        v_tuple(2) := 'ERRO';
        v_tuple(3) := 'ERRO';
        v_tuple(4) := 'ERRO';
        v_tuple(5) := 'ERRO';
        v_tuple(6) := v_num_erros || '';
        return v_tuple;
    end if;
    v_id_sensor := SUBSTR(p_input_sensor, 1, 5);
    v_tipo_sensor := SUBSTR(p_input_sensor, 6, 2);
    v_valor_lido := SUBSTR(p_input_sensor, 8, 3);
    v_valor_referencia := SUBSTR(p_input_sensor, 11, 3);
    v_dia := SUBSTR(p_input_sensor, 14, 2);
    v_mes := SUBSTR(p_input_sensor, 16, 2);
    v_ano := SUBSTR(p_input_sensor, 18, 4);
    v_hora := SUBSTR(p_input_sensor, 22, 2);
    v_minuto := SUBSTR(p_input_sensor, 24, 2);
    v_data := v_dia || '/' || v_mes || '/' || v_ano || ' ' || v_hora || ':' || v_minuto;

    v_tuple := array_t();
    v_tuple.extend(6);
    v_tuple(1) := v_id_sensor;
    v_tuple(2) := v_tipo_sensor;
    v_tuple(3) := v_valor_lido;
    v_tuple(4) := v_valor_referencia;
    v_tuple(5) := v_dia || '/' || v_mes || '/' || v_ano || ' ' || v_hora || ':' || v_minuto;
    -- dbms_output.put_line('ID: ' || v_tuple(1) || ' Tipo: ' || v_tuple(2) || ' Valor lido: ' || v_tuple(3) || ' Valor referencia: ' || v_tuple(4) || ' Data: ' || v_tuple(5));

    -- verificar se v_tipo_sensor é válido
    if  UPPER(v_tipo_sensor) not in ('HS', 'PL', 'TS', 'VV', 'TA', 'HA', 'PA') then
        DBMS_OUTPUT.PUT_LINE( 'Tipo de sensor inválido');
        v_num_erros := v_num_erros + 1;
    end if;

    -- verificar se v_valor_lido é válido
    if to_number(v_valor_lido) < 0 or to_number(v_valor_lido) > 100 then
        DBMS_OUTPUT.PUT_LINE( 'Valor lido inválido');
        v_num_erros := v_num_erros + 1;
    end if;

    -- verificar se v_valor_referencia é válido
    if to_number(v_valor_referencia) < 0 or to_number(v_valor_referencia) > 100 then
        DBMS_OUTPUT.PUT_LINE( 'Valor de referencia inválido');
        v_num_erros := v_num_erros + 1;
    end if;

    -- verificar se v_data é válida
    if TO_DATE(v_data, 'DD/MM/YYYYHH24:MI') is null then
        raise_application_error(-20001, 'Data Invalida');
    end if;

    v_tuple(6) := v_num_erros || '';
    return v_tuple;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE( 'Data inválida');
        v_num_erros := v_num_erros + 1;
        v_tuple := array_t();
        v_tuple.extend(6);
        v_tuple(1) := SUBSTR(p_input_sensor, 1, 5);
        v_tuple(2) := 'ERRO';
        v_tuple(3) := 'ERRO';
        v_tuple(4) := 'ERRO';
        v_tuple(5) := 'ERRO';
        v_tuple(6) := v_num_erros || '';
        return v_tuple;
END;

CREATE OR REPLACE function get_tuple (p_input_sensor INPUTSENSOR.INPUT_STRING%type, p_n number)
    return varchar2
    is
    v_tuple array_t;
begin
    if p_n < 1 or p_n > 5 then
        raise_application_error(-20001, 'Número inválido');
    end if;
    v_tuple := input_string_to_tuple(p_input_sensor);
    return v_tuple(p_n);
end;

drop function get_tuple;
drop function input_string_to_tuple;