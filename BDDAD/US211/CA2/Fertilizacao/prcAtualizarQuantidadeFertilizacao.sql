CREATE OR REPLACE PROCEDURE prcAtualizarQuantidadeFertilizacao(id_fertilizacao_param FERTILIZACAO.ID_FERTILIZACAO_PK%TYPE,
                                                         quantidade_param FERTILIZACAO.QUANTIDADE%TYPE) AS

    fertilizacao_para_atualizar FERTILIZACAO%ROWTYPE;


    fertilizacao_invalida EXCEPTION;
    quantidade_invalida EXCEPTION;
    fertilizacao_ja_realizada EXCEPTION;

BEGIN

    --dá throw a NO_DATA_FOUND caso não encontre nada
SELECT * INTO fertilizacao_para_atualizar FROM FERTILIZACAO
WHERE ID_FERTILIZACAO_PK = id_fertilizacao_param;

IF (quantidade_param <= 0 ) THEN
        RAISE quantidade_invalida;
END IF;

    IF(fertilizacao_para_atualizar.DATA_APLICACAO <= SYSDATE)THEN
        RAISE fertilizacao_ja_realizada;
end if;

UPDATE FERTILIZACAO
SET QUANTIDADE = quantidade_param
WHERE ID_FERTILIZACAO_PK = id_fertilizacao_param;

DBMS_OUTPUT.PUT_LINE('Operação realizada com sucesso.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Não existe uma fertilização com este id.');
WHEN quantidade_invalida THEN
        DBMS_OUTPUT.PUT_LINE('A nova quantidade aplicada tem de ser maior que 0.');
WHEN fertilizacao_ja_realizada THEN
        DBMS_OUTPUT.PUT_LINE('Uma fertilização já realizada não pode ser atualizada.');
END;