CREATE OR REPLACE PROCEDURE prcAtualizarTipoRega(id_rega_param Rega.id_rega_pk%TYPE,
                                                 tipo_rega_param Rega.tipo_rega%TYPE) AS

    rega_para_atualizar REGA%ROWTYPE;
    rega_ja_realizada EXCEPTION;
    tipo_rega_invalido EXCEPTION;

BEGIN
SELECT * INTO rega_para_atualizar FROM REGA
WHERE rega.id_rega_pk = id_rega_param;

IF(rega_para_atualizar.data_rega <= SYSDATE) THEN
        RAISE rega_ja_realizada;
END IF;

    IF (UPPER(tipo_rega_param) != 'BOMBEAMENTO' AND UPPER(tipo_rega_param) != 'GRAVIDADE' ) THEN
        RAISE tipo_rega_invalido;
END IF;

UPDATE REGA
SET tipo_rega = UPPER(tipo_rega_param)
WHERE id_rega_pk = id_rega_param;

DBMS_OUTPUT.PUT_LINE('Operação realizada com sucesso.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Não existe uma rega com este id.');
WHEN rega_ja_realizada THEN
        DBMS_OUTPUT.PUT_LINE('Uma rega já realizada não pode ser atualizada.');
WHEN tipo_rega_invalido THEN
        DBMS_OUTPUT.PUT_LINE('Uma rega apenas pode ser do tipo "bombeamento" ou "gravidade".');

END;