CREATE OR REPLACE PROCEDURE prcAtualizarDataRega(id_rega_param Rega.id_rega_pk%TYPE,
                                                 data_param Rega.data_rega%TYPE) AS

    rega_para_atualizar REGA%ROWTYPE;

    rega_ja_realizada EXCEPTION;
    data_invalida EXCEPTION;

BEGIN

SELECT * INTO rega_para_atualizar FROM REGA
WHERE rega.id_rega_pk = id_rega_param;

IF(rega_para_atualizar.data_rega <= SYSDATE) THEN
        RAISE rega_ja_realizada;
END IF;

    IF (data_param <= SYSDATE) THEN
        RAISE data_invalida;
END IF;

UPDATE REGA
SET data_rega = data_param
WHERE id_rega_pk = id_rega_param;

DBMS_OUTPUT.PUT_LINE('Operação realizada com sucesso.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Não existe uma rega com este id.');
WHEN rega_ja_realizada THEN
        DBMS_OUTPUT.PUT_LINE('Uma rega já realizada não pode ser atualizada.');
WHEN data_invalida THEN
        DBMS_OUTPUT.PUT_LINE('A nova data não pode ser anterior ou igual à data atual.');

END;