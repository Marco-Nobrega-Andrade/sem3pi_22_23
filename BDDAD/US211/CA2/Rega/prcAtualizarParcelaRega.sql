CREATE OR REPLACE PROCEDURE prcAtualizarParcelaRega(id_rega_param Rega.id_rega_pk%TYPE,
                                                    id_parcela_param Rega.id_parcela_fk%TYPE) AS

    contador_parcela NUMBER;
    rega_para_atualizar REGA%ROWTYPE;
    rega_ja_realizada EXCEPTION;
    parcela_invalida EXCEPTION;

BEGIN

SELECT * INTO rega_para_atualizar FROM REGA
WHERE rega.id_rega_pk = id_rega_param;

IF(rega_para_atualizar.data_rega <= SYSDATE) THEN
        RAISE rega_ja_realizada;
END IF;

SELECT COUNT(*) INTO contador_parcela FROM PARCELA
WHERE PARCELA.id_parcela_pk = id_parcela_param;

IF (contador_parcela = 0) THEN
        RAISE parcela_invalida;
END IF;

UPDATE REGA
SET id_parcela_fk = id_parcela_param
WHERE id_rega_pk = id_rega_param;

DBMS_OUTPUT.PUT_LINE('Operação realizada com sucesso.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Não existe uma rega com este id.');
WHEN rega_ja_realizada THEN
        DBMS_OUTPUT.PUT_LINE('Uma rega já realizada não pode ser atualizada.');
WHEN parcela_invalida THEN
        DBMS_OUTPUT.PUT_LINE('Não exite uma parcela com este id.');

END;