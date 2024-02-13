declare
v array_t;
    n_esimo varchar2(255);
begin
    v := INPUT_STRING_TO_TUPLE('00002TS018020020720201215');
    dbms_output.put_line('ID: ' || v(1) || ' Tipo: ' || v(2) || ' Valor lido: ' || v(3) || ' Valor referencia: ' || v(4) || ' Data: ' || v(5));
    -- v := INPUT_STRING_TO_TUPLE('00002TS018020310220201215');
    v := INPUT_STRING_TO_TUPLE('00002XX018020020720201215');
    n_esimo := get_tuple('00002TS018020020720201215', 1);
    dbms_output.put_line('N-esimo: ' || n_esimo);
    n_esimo := get_tuple('00002TS018020020720201215', 2);
    dbms_output.put_line('N-esimo: ' || n_esimo);
    n_esimo := get_tuple('00002TS018020020720201215', 3);
    dbms_output.put_line('N-esimo: ' || n_esimo);

    n_esimo := get_tuple('00002TS018020020720201215', 4);
    dbms_output.put_line('N-esimo: ' || n_esimo);

    n_esimo := get_tuple('00002TS018020020720201215', 5);
    dbms_output.put_line('N-esimo: ' || n_esimo);

end;

begin
    insert_all_input_sensor;
end;
