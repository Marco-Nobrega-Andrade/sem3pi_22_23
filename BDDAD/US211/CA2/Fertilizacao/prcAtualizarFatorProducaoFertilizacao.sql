CREATE OR REPLACE PROCEDURE prcAtualizarFatorProducaoFertilizacao(id_fertilizacao_param FERTILIZACAO.ID_FERTILIZACAO_PK%TYPE,
                                                         id_fator_producao_param FERTILIZACAO.ID_FATOR_PRODUCAO_FK%TYPE) AS

    fertilizacao_para_atualizar FERTILIZACAO%ROWTYPE;
    plantacao_fertilizada PLANTACAO%ROWTYPE;
    contador_fator_producao NUMBER;


    fertilizacao_invalida EXCEPTION;
    fator_producao_invalido EXCEPTION;
    fertilizacao_ja_realizada EXCEPTION;
    restricao_ativa EXCEPTION;
BEGIN

    --dá throw a NO_DATA_FOUND caso não encontre nada
SELECT * INTO fertilizacao_para_atualizar FROM FERTILIZACAO
WHERE ID_FERTILIZACAO_PK = id_fertilizacao_param;

SELECT COUNT(*) INTO contador_fator_producao FROM FATORPRODUCAO
WHERE ID_FATOR_PRODUCAO_PK = id_fator_producao_param;

IF (contador_fator_producao = 0) THEN
        RAISE fator_producao_invalido;
END IF;

    IF(fertilizacao_para_atualizar.DATA_APLICACAO <= SYSDATE)THEN
        RAISE fertilizacao_ja_realizada;
end if;



SELECT * INTO plantacao_fertilizada FROM PLANTACAO
WHERE ID_PLANTACAO_PK = fertilizacao_para_atualizar.ID_PLANTACAO_FK;



FOR restricao IN (
        SELECT * FROM restricaofatorproducao
        WHERE (restricaofatorproducao.id_parcela_fk = plantacao_fertilizada.ID_PARCELA_FK AND restricaofatorproducao.id_fator_producao_fk = id_fator_producao_param))
        LOOP
            IF(restricao.data_inicio <= fertilizacao_para_atualizar.DATA_APLICACAO AND restricao.data_fim >= fertilizacao_para_atualizar.DATA_APLICACAO) THEN
                RAISE restricao_ativa;
END IF;
END LOOP;


UPDATE FERTILIZACAO
SET ID_FATOR_PRODUCAO_FK = id_fator_producao_param
WHERE ID_FERTILIZACAO_PK = id_fertilizacao_param;

DBMS_OUTPUT.PUT_LINE('Operação realizada com sucesso.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Não existe uma fertilização com este id.');
WHEN fator_producao_invalido THEN
        DBMS_OUTPUT.PUT_LINE('Não existe um fator de produção com este id.');
WHEN fertilizacao_ja_realizada THEN
        DBMS_OUTPUT.PUT_LINE('Uma fertilização já realizada não pode ser atualizada.');
WHEN restricao_ativa THEN
        DBMS_OUTPUT.PUT_LINE('Não foi possivel atualizar a fertilização porque exite uma restrição de fertilização nessa parcela para essa data.');
END;
