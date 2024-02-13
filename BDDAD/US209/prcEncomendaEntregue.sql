CREATE OR REPLACE PROCEDURE prcEncomendaEntregue(encomenda_id IN DISTRIBUICAO.ID_DISTRIBUICAO_PK%TYPE) AS
    e_encomenda_ja_entregue EXCEPTION;
    encomenda_estado ENCOMENDA.STATUS%TYPE;
BEGIN
    SELECT ENCOMENDA.STATUS INTO encomenda_estado FROM ENCOMENDA
    WHERE ENCOMENDA.ID_DISTRIBUICAO_FK = encomenda_id;

    IF encomenda_estado = 'ENTREGUE' THEN
        RAISE e_encomenda_ja_entregue;
    ELSE
        UPDATE ENCOMENDA
        SET DATA_ENTREGA = SYSDATE,
            STATUS = 'ENTREGUE'
        WHERE ENCOMENDA.ID_DISTRIBUICAO_FK = encomenda_id;
    END IF;
EXCEPTION
    WHEN e_encomenda_ja_entregue THEN
        dbms_output.put_line('Essa encomenda já foi entregue');
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Essa encomenda não existe');
END;