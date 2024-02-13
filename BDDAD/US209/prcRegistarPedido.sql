CREATE OR REPLACE PROCEDURE prcRegistarPedido(id_cliente IN DISTRIBUICAO.ID_UTILIZADOR_CLIENTE_FK%TYPE,
                                              v_morada_entrega IN CLIENTE.ID_MORADA_ENTREGA_FK%TYPE,
                                              v_valor IN ENCOMENDA.VALOR%TYPE,
                                              id_plantacao IN DISTRIBUICAO.ID_PLANTACAO_FK%TYPE,
                                              id_gestor_distribuicao IN DISTRIBUICAO.ID_UTILIZADOR_GESTOR_DISTRIBUICAO_FK%TYPE) AS

    valor_encomendas_total CLIENTE.VALOR_ENCOMENDAS%TYPE;
    plafond_cliente CLIENTE.PLAFOND%TYPE;
    e_limite_plafond_atingido EXCEPTION;
    id_distribuicao DISTRIBUICAO.ID_DISTRIBUICAO_PK%TYPE;
    p_v_morada_entrega CLIENTE.ID_MORADA_ENTREGA_FK%TYPE := v_morada_entrega;
BEGIN

    IF p_v_morada_entrega IS NULL THEN
        SELECT CLIENTE.ID_MORADA_ENTREGA_FK INTO p_v_morada_entrega
        FROM CLIENTE
                 INNER JOIN MORADA ON MORADA.ID_MORADA_PK = CLIENTE.ID_MORADA_ENTREGA_FK
        WHERE CLIENTE.ID_UTILIZADOR_CLIENTE_FK = id_cliente;
    end if;
    IF p_v_morada_entrega IS NULL THEN
        SELECT CLIENTE.ID_MORADA_ENTREGA_FK INTO p_v_morada_entrega
        FROM MORADA
                 INNER JOIN CLIENTE ON MORADA.ID_MORADA_PK = CLIENTE.ID_MORADA_PARTICULAR_FK
        WHERE CLIENTE.ID_UTILIZADOR_CLIENTE_FK = id_cliente;
    end if;


    SELECT CLIENTE.VALOR_ENCOMENDAS INTO valor_encomendas_total FROM CLIENTE
    WHERE CLIENTE.ID_UTILIZADOR_CLIENTE_FK = id_cliente;

    SELECT CLIENTE.PLAFOND INTO plafond_cliente FROM CLIENTE
    WHERE CLIENTE.ID_UTILIZADOR_CLIENTE_FK = id_cliente;

    IF valor_encomendas_total + v_valor >= plafond_cliente THEN
        RAISE e_limite_plafond_atingido;
    END IF;

    INSERT INTO DISTRIBUICAO(ID_DISTRIBUICAO_PK,
                             ID_PLANTACAO_FK, ID_UTILIZADOR_CLIENTE_FK,
                             ID_UTILIZADOR_GESTOR_DISTRIBUICAO_FK,
                             TIPO_DISTRIBUICAO) VALUES (DEFAULT, id_plantacao,id_cliente, id_gestor_distribuicao, 'ENCOMENDA') RETURNING ID_DISTRIBUICAO_PK INTO id_distribuicao ;

    INSERT INTO ENCOMENDA(ID_DISTRIBUICAO_FK, ID_MORADA_ENTREGA_FK, DATA_ENTREGA, DATA_REGISTO, STATUS, VALOR)
    VALUES (id_distribuicao, p_v_morada_entrega,NULL, SYSDATE, 'REGISTADA', v_valor);

EXCEPTION
    WHEN e_limite_plafond_atingido THEN
        dbms_output.put_line('É necessário pagar algumas encomendas pendentes para prosseguir, porque já ultrapassou o seu plafond');
END;