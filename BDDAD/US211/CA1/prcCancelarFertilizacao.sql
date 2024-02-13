CREATE OR REPLACE PROCEDURE prcCancelarFertilizacao(id_fertilizacao_param FERTILIZACAO.ID_FERTILIZACAO_PK%TYPE) AS

    fertilizacao_para_atualizar FERTILIZACAO%ROWTYPE;

    fertilizacao_ja_realizada EXCEPTION;

BEGIN

    --dá throw a NO_DATA_FOUND caso não encontre nada
SELECT * INTO fertilizacao_para_atualizar FROM FERTILIZACAO
WHERE ID_FERTILIZACAO_PK = id_fertilizacao_param;


IF(fertilizacao_para_atualizar.DATA_APLICACAO <= SYSDATE)THEN
        RAISE fertilizacao_ja_realizada;
end if;

DELETE FROM FERTILIZACAO
WHERE ID_FERTILIZACAO_PK = id_fertilizacao_param;

DBMS_OUTPUT.PUT_LINE('Operação realizada com sucesso.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Não existe uma fertilização com este id.');
WHEN fertilizacao_ja_realizada THEN
        DBMS_OUTPUT.PUT_LINE('Uma fertilização já realizada não pode ser cancelada.');
END;