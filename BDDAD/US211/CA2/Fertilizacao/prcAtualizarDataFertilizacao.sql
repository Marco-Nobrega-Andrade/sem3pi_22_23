CREATE OR REPLACE PROCEDURE prcAtualizarDataFertilizacao(id_fertilizacao_param FERTILIZACAO.ID_FERTILIZACAO_PK%TYPE,
                                                         data_param FERTILIZACAO.DATA_APLICACAO%TYPE) AS

    fertilizacao_para_atualizar FERTILIZACAO%ROWTYPE;
        plantacao_fertilizada PLANTACAO%ROWTYPE;
        fertilizacao_invalida EXCEPTION;
        data_invalida EXCEPTION;
        fertilizacao_ja_realizada EXCEPTION;
        restricao_ativa EXCEPTION;
BEGIN

    --dá throw a NO_DATA_FOUND caso não encontre nada
SELECT * INTO fertilizacao_para_atualizar FROM FERTILIZACAO
WHERE ID_FERTILIZACAO_PK = id_fertilizacao_param;

IF (data_param <= SYSDATE) THEN
        RAISE data_invalida;
END IF;

    IF(fertilizacao_para_atualizar.DATA_APLICACAO <= SYSDATE)THEN
        RAISE fertilizacao_ja_realizada;
end if;



SELECT * INTO plantacao_fertilizada FROM PLANTACAO
WHERE ID_PLANTACAO_PK = fertilizacao_para_atualizar.ID_PLANTACAO_FK;

FOR restricao IN (
        SELECT * FROM restricaofatorproducao
        WHERE (restricaofatorproducao.id_parcela_fk = plantacao_fertilizada.ID_PARCELA_FK AND restricaofatorproducao.id_fator_producao_fk = fertilizacao_para_atualizar.ID_FATOR_PRODUCAO_FK))
    LOOP
        IF(restricao.data_inicio <= data_param AND restricao.data_fim >= data_param) THEN
            RAISE restricao_ativa;
END IF;
END LOOP;


UPDATE FERTILIZACAO
SET DATA_APLICACAO = data_param
WHERE ID_FERTILIZACAO_PK = id_fertilizacao_param;

DBMS_OUTPUT.PUT_LINE('Operação realizada com sucesso.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Não existe uma fertilização com este id.');
WHEN data_invalida THEN
        DBMS_OUTPUT.PUT_LINE('A nova data não pode ser anterior ou igual à data atual.');
WHEN fertilizacao_ja_realizada THEN
        DBMS_OUTPUT.PUT_LINE('Uma fertilização já realizada não pode ser atualizada.');
WHEN restricao_ativa THEN
        DBMS_OUTPUT.PUT_LINE('Não foi possivel atualizar a fertilização porque exite uma restrição de fertilização nessa parcela para essa data.');
END;