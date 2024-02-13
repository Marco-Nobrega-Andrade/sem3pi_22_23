CREATE OR REPLACE PROCEDURE prcEncomendaPaga(encomenda_id IN ENCOMENDA.ID_DISTRIBUICAO_FK%TYPE) AS
    e_encomenda_ja_entregue EXCEPTION;
    e_encomenda_ja_paga EXCEPTION;
    encomenda_estado ENCOMENDA.STATUS%TYPE;

BEGIN

    SELECT ENCOMENDA.STATUS INTO encomenda_estado FROM ENCOMENDA
    WHERE ENCOMENDA.ID_DISTRIBUICAO_FK = encomenda_id;


    IF encomenda_estado = 'ENTREGUE' THEN
        RAISE e_encomenda_ja_entregue;
    ELSE IF encomenda_estado = 'PAGA' THEN
        RAISE e_encomenda_ja_paga;
    ELSE
        UPDATE ENCOMENDA
        SET STATUS = 'PAGA'
        WHERE ID_DISTRIBUICAO_FK = encomenda_id;
    END IF;
    END IF;
    dbms_output.put_line('A encomenda foi paga com sucesso!');

EXCEPTION
    WHEN e_encomenda_ja_entregue THEN
        dbms_output.put_line('Essa encomenda já foi entregue!');
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Essa encomenda não existe!');
    WHEN e_encomenda_ja_paga THEN
        dbms_output.put_line('Essa encomenda já foi paga!');
end;