CREATE OR REPLACE PROCEDURE prcRegistarPedidoAEntregarEmHub(id_cliente IN DISTRIBUICAO.ID_UTILIZADOR_CLIENTE_FK%TYPE,
                                                            id_plantacao IN DISTRIBUICAO.ID_PLANTACAO_FK%TYPE,
                                                            id_gestor_distribuicao IN DISTRIBUICAO.ID_UTILIZADOR_GESTOR_DISTRIBUICAO_FK%TYPE,
                                                            param_id_hub_entrega HUB.loc_id_pk%TYPE,
                                                            valor ENCOMENDA.valor%TYPE) AS

    valor_encomendas_total CLIENTE.VALOR_ENCOMENDAS%TYPE;
    plafond_cliente CLIENTE.PLAFOND%TYPE;
    id_distribuicao DISTRIBUICAO.ID_DISTRIBUICAO_PK%TYPE;
    id_hub_entrega HUB.loc_id_pk%TYPE := param_id_hub_entrega;

    contador_hubs NUMBER;
    contador_cliente NUMBER;
    contador_gestor_dist NUMBER;
    contador_plantacao NUMBER;

    e_limite_plafond_atingido EXCEPTION;
    nenhum_hub_para_associar EXCEPTION;
    hub_invalido EXCEPTION;
    cliente_invalido EXCEPTION;
    plantacao_invalida EXCEPTION;
    gestor_dist_invalido EXCEPTION;
    valor_invalido EXCEPTION;
BEGIN

SELECT COUNT(*) INTO contador_cliente FROM CLIENTE
WHERE ID_UTILIZADOR_CLIENTE_FK = id_cliente;
IF (contador_cliente = 0) THEN
        -- Se não existir
        RAISE cliente_invalido;
END IF;

SELECT COUNT(*) INTO contador_plantacao FROM PLANTACAO
WHERE ID_PLANTACAO_PK = id_plantacao;
IF (contador_plantacao = 0) THEN
        -- Se não existir
        RAISE plantacao_invalida;
END IF;

SELECT COUNT(*) INTO contador_gestor_dist FROM GESTORDISTRIBUICAO
WHERE ID_UTILIZADOR_GESTOR_DISTRIBUICAO_FK = id_gestor_distribuicao;
IF (contador_gestor_dist = 0) THEN
        -- Se não existir
        RAISE gestor_dist_invalido;
END IF;

    IF(valor <= 0) THEN
        RAISE valor_invalido ;
END IF;

    --Check para ver se foi passado um hub por parâmetro
    IF id_hub_entrega IS NULL THEN
        -- Se não, vamos buscar o hub default associado ao cliente
        -- Se não existir hub default (o select não retorna nada) -> exceção NO_DATA_FOUND
SELECT HUB_LOC_ID_FK INTO id_hub_entrega
FROM CLIENTE
         INNER JOIN HUB ON HUB.LOC_ID_PK = CLIENTE.HUB_LOC_ID_FK
WHERE CLIENTE.ID_UTILIZADOR_CLIENTE_FK = id_cliente;
ELSE
        -- Se sim, vamos ver se existe
SELECT COUNT(*) INTO contador_hubs FROM HUB
WHERE LOC_ID_PK = id_hub_entrega;
IF (contador_hubs = 0) THEN
            -- Se não existir
            RAISE hub_invalido;
END IF;
END IF;

SELECT CLIENTE.VALOR_ENCOMENDAS INTO valor_encomendas_total FROM CLIENTE
WHERE CLIENTE.ID_UTILIZADOR_CLIENTE_FK = id_cliente;

SELECT CLIENTE.PLAFOND INTO plafond_cliente FROM CLIENTE
WHERE CLIENTE.ID_UTILIZADOR_CLIENTE_FK = id_cliente;

IF valor_encomendas_total + valor >= plafond_cliente THEN
        RAISE e_limite_plafond_atingido;
END IF;

INSERT INTO DISTRIBUICAO(ID_DISTRIBUICAO_PK,
                         ID_PLANTACAO_FK, ID_UTILIZADOR_CLIENTE_FK,
                         ID_UTILIZADOR_GESTOR_DISTRIBUICAO_FK,
                         TIPO_DISTRIBUICAO) VALUES (DEFAULT, id_plantacao,id_cliente, id_gestor_distribuicao, 'ENCOMENDA') RETURNING ID_DISTRIBUICAO_PK INTO id_distribuicao ;

INSERT INTO ENCOMENDA(ID_DISTRIBUICAO_FK, ID_MORADA_ENTREGA_FK,HUB_LOC_ID_FK, DATA_ENTREGA, DATA_REGISTO, STATUS, VALOR)
VALUES (id_distribuicao, NULL, id_hub_entrega ,NULL, SYSDATE, 'REGISTADA', valor);
dbms_output.put_line('Encomenda registada com sucesso.');

EXCEPTION
    WHEN cliente_invalido THEN
        dbms_output.put_line('Não existe um cliente com este id.');

WHEN plantacao_invalida THEN
        dbms_output.put_line('Não existe uma plantação com este id.');

WHEN gestor_dist_invalido THEN
        dbms_output.put_line('Não existe um gestor de distribuição com este id.');

WHEN valor_invalido THEN
        dbms_output.put_line('O valor da encomenda tem de ser um valor positivo.');

WHEN hub_invalido THEN
        dbms_output.put_line('Não existe um hub com este id.');

WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Este cliente não têm um hub associado. É necessário associar um hub ao cliente ou fornecer um id de hub para realizar esta operação.');

WHEN e_limite_plafond_atingido THEN
        dbms_output.put_line('É necessário pagar algumas encomendas pendentes para prosseguir, porque já ultrapassou o seu plafond');
END;