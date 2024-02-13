-- run insert client
declare
    id Utilizador.ID_UTILIZADOR_PK%TYPE;
begin
    id := insert_new_client('Manu', 234562133, 'manu@mail.ex', 'R Centieira 106,Portugal', '3420-457', 'R São Bento 89,Portugal', '4760-756' );
end;

-- run auto update client
begin
    UPDATE_NUMERO_ENCOMENDAS_E_VALOR_ENCOMENDAS(2);
    end;

-- update all clients
begin
    UPDATE_ALL_CLIENTES();
end;

-- compute risk factor
declare
    risk NUMBER;
begin
    risk := COMPUTE_RISK_FACTOR(3);
    dbms_output.put_line('risk factor: ' || risk);
end;