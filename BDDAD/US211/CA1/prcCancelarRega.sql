CREATE OR REPLACE PROCEDURE prcCancelarRega(id_rega_param REGA.ID_REGA_PK%TYPE) AS

    rega_para_cancelar REGA%ROWTYPE;

    rega_ja_realizada EXCEPTION;

BEGIN

    --dá throw a NO_DATA_FOUND caso não encontre nada
SELECT * INTO rega_para_cancelar FROM REGA
WHERE ID_REGA_PK = id_rega_param;


IF(rega_para_cancelar.DATA_REGA <= SYSDATE)THEN
        RAISE rega_ja_realizada;
end if;

DELETE FROM REGA
WHERE ID_REGA_PK = id_rega_param;

DBMS_OUTPUT.PUT_LINE('Operação realizada com sucesso.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Não existe uma rega com este id.');
WHEN rega_ja_realizada THEN
        DBMS_OUTPUT.PUT_LINE('Uma rega já realizada não pode ser cancelada.');
END;