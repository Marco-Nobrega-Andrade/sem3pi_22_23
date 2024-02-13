CREATE OR REPLACE PROCEDURE prcListarPorEstado(p_status ENCOMENDA.STATUS%TYPE) AS
    c_data_registo ENCOMENDA.DATA_REGISTo%TYPE;
    c_id_encomenda ENCOMENDA.ID_DISTRIBUICAO_FK%TYPE;
    c_valor ENCOMENDA.VALOR%TYPE;
    c_status ENCOMENDA.STATUS%TYPE;
    c_cliente DISTRIBUICAO.ID_UTILIZADOR_CLIENTE_FK%TYPE;

    CURSOR list_estado IS
        SELECT ENCOMENDA.DATA_REGISTO, ENCOMENDA.ID_DISTRIBUICAO_FK, ENCOMENDA.VALOR, ENCOMENDA.STATUS, DISTRIBUICAO.ID_UTILIZADOR_CLIENTE_FK AS CLIENTE
        FROM ENCOMENDA
                 INNER JOIN DISTRIBUICAO ON ENCOMENDA.ID_DISTRIBUICAO_FK = DISTRIBUICAO.ID_DISTRIBUICAO_PK
        WHERE ENCOMENDA.STATUS = p_status;
BEGIN
    OPEN list_estado;
    LOOP
        FETCH list_estado INTO c_data_registo,c_id_encomenda, c_valor,c_status, c_cliente;
        EXIT WHEN list_estado%notfound;
        DBMS_OUTPUT.PUT_LINE(' ID DO CLIENTE: '|| c_cliente || ' || ID DA ENCOMENDA: ' || c_id_encomenda|| ' || VALOR: ' ||c_valor|| ' || DATA DE REGISTO: ' || c_data_registo||' || STATUS: ' || c_status);
    END LOOP;
    CLOSE list_estado;
END;