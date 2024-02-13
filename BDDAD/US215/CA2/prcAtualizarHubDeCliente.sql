CREATE OR REPLACE PROCEDURE prcAtualizarHubDeCliente(id_cliente CLIENTE.ID_UTILIZADOR_CLIENTE_FK%TYPE,
                                                     id_hub HUB.loc_id_pk%TYPE) AS
    client_counter number;
    hub_counter number;
    invalid_client_id EXCEPTION;
    invalid_hub_id EXCEPTION;
BEGIN
SELECT COUNT(*) INTO client_counter FROM CLIENTE
WHERE ID_UTILIZADOR_CLIENTE_FK = id_cliente;
SELECT COUNT(*) INTO hub_counter FROM HUB
WHERE LOC_ID_PK = id_hub;
IF (client_counter = 0) THEN
        RAISE invalid_client_id;
END IF;
    IF (hub_counter = 0) THEN
        RAISE invalid_hub_id;
END IF;

UPDATE CLIENTE SET HUB_LOC_ID_FK = id_hub
WHERE ID_UTILIZADOR_CLIENTE_FK = id_cliente;
DBMS_OUTPUT.PUT_LINE('Hub do cliente atualizado com sucesso.');
EXCEPTION
    WHEN invalid_client_id THEN
        DBMS_OUTPUT.PUT_LINE('Não existe um cliente com este id.');
WHEN invalid_hub_id THEN
        DBMS_OUTPUT.PUT_LINE('Não existe um hub com este id.');
END;