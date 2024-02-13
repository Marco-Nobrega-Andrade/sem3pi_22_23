CREATE OR REPLACE PROCEDURE prcRegistarColheitaDePlantacao(id_plantacao PLANTACAO.ID_PLANTACAO_PK%TYPE,
                                                                data_colheita_param PLANTACAO.DATA_COLHEITA%TYPE,
                                                                quantidade_colhida_param PLANTACAO.QUANTIDADE_COLHIDA%TYPE) AS
id_plantacao_aux PLANTACAO.ID_PLANTACAO_PK%TYPE;
BEGIN
SAVEPOINT BEFORE_UPDATE;
SELECT PLANTACAO.ID_PLANTACAO_PK INTO id_plantacao_aux FROM PLANTACAO
WHERE ID_PLANTACAO_PK = id_plantacao;
UPDATE PLANTACAO
SET DATA_COLHEITA = data_colheita_param, QUANTIDADE_COLHIDA = quantidade_colhida_param
WHERE (ID_PLANTACAO_PK = id_plantacao);
DBMS_OUTPUT.PUT_LINE('Colheita registada com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT BEFORE_UPDATE;
        DBMS_OUTPUT.PUT_LINE('Não foi possível registar a colheita.');
END;