CREATE OR REPLACE PROCEDURE prcAtualizarPlantacaoFertilizacao(id_fertilizacao_param FERTILIZACAO.ID_FERTILIZACAO_PK%TYPE,
                                                         id_plantacao_param FERTILIZACAO.ID_PLANTACAO_FK%TYPE) AS

    fertilizacao_para_atualizar FERTILIZACAO%ROWTYPE;
    nova_plantacao PLANTACAO%ROWTYPE;
    contador_plantacoes  NUMBER;


    fertilizacao_invalida EXCEPTION;
    plantacao_invalida EXCEPTION;
    fertilizacao_ja_realizada EXCEPTION;
    restricao_ativa EXCEPTION;
BEGIN

    --dá throw a NO_DATA_FOUND caso não encontre nada
SELECT * INTO fertilizacao_para_atualizar FROM FERTILIZACAO
WHERE ID_FERTILIZACAO_PK = id_fertilizacao_param;

SELECT COUNT(*) INTO contador_plantacoes FROM PLANTACAO
WHERE ID_PLANTACAO_PK = id_plantacao_param;

IF (contador_plantacoes = 0) THEN
        RAISE plantacao_invalida;
END IF;

    IF(fertilizacao_para_atualizar.DATA_APLICACAO <= SYSDATE)THEN
        RAISE fertilizacao_ja_realizada;
end if;



SELECT * INTO nova_plantacao FROM PLANTACAO
WHERE ID_PLANTACAO_PK = id_plantacao_param;



FOR restricao IN (
        SELECT * FROM restricaofatorproducao
        WHERE (restricaofatorproducao.id_parcela_fk = nova_plantacao.ID_PARCELA_FK AND restricaofatorproducao.id_fator_producao_fk = fertilizacao_para_atualizar.ID_FATOR_PRODUCAO_FK))
        LOOP
            IF(restricao.data_inicio <= fertilizacao_para_atualizar.DATA_APLICACAO AND restricao.data_fim >= fertilizacao_para_atualizar.DATA_APLICACAO) THEN
                RAISE restricao_ativa;
END IF;
END LOOP;


UPDATE FERTILIZACAO
SET ID_PLANTACAO_FK = id_plantacao_param
WHERE ID_FERTILIZACAO_PK = id_fertilizacao_param;

DBMS_OUTPUT.PUT_LINE('Operação realizada com sucesso.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Não existe uma fertilização com este id.');
WHEN plantacao_invalida THEN
        DBMS_OUTPUT.PUT_LINE('Não existe uma plantação com este id.');
WHEN fertilizacao_ja_realizada THEN
        DBMS_OUTPUT.PUT_LINE('Uma fertilização já realizada não pode ser atualizada.');
WHEN restricao_ativa THEN
        DBMS_OUTPUT.PUT_LINE('Não foi possivel atualizar a fertilização porque exite uma restrição de fertilização nessa parcela para essa data.');
END;