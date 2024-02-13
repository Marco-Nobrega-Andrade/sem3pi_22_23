CREATE OR REPLACE FUNCTION fncCriarSetor(id_caderno_campo PARCELA.ID_CADERNO_CAMPO_FK%TYPE,
                                            designacao_param PARCELA.designacao%TYPE,
                                            area_param PARCELA.area%TYPE) RETURN PARCELA.ID_PARCELA_PK%TYPE AS
    id_setor PARCELA.ID_PARCELA_PK%TYPE;
BEGIN
SAVEPOINT BEFORECALL;
id_setor := -1;
INSERT INTO PARCELA(ID_PARCELA_PK, ID_CADERNO_CAMPO_FK, DESIGNACAO, AREA) VALUES (DEFAULT,id_caderno_campo,designacao_param,area_param);
SELECT PARCELA.ID_PARCELA_PK into id_setor from PARCELA
WHERE (DESIGNACAO = designacao_param AND
       AREA = area_param AND
       ID_CADERNO_CAMPO_FK = id_caderno_campo);
DBMS_OUTPUT.PUT_LINE('Setor adicionado.');

RETURN id_setor;
EXCEPTION
    WHEN too_many_rows THEN
        DBMS_OUTPUT.PUT_LINE('Já existe um setor com estes dados. Id do setor:');
ROLLBACK TO SAVEPOINT BEFORECALL;
SELECT PARCELA.ID_PARCELA_PK into id_setor from PARCELA
WHERE (DESIGNACAO = designacao_param AND
       AREA = area_param AND
       ID_CADERNO_CAMPO_FK = id_caderno_campo);
RETURN id_setor;
WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT BEFORECALL;
        DBMS_OUTPUT.PUT_LINE('Não foi possível criar o setor.');
RETURN id_setor;
END;