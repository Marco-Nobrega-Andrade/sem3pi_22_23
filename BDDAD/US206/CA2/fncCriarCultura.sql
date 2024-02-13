CREATE OR REPLACE FUNCTION fncCriarCultura(tipo_cultura_param CULTURA.TIPO_CULTURA%TYPE,
                                                especie_param CULTURA.ESPECIE%TYPE) RETURN CULTURA.ID_CULTURA_PK%TYPE AS

id_cultura CULTURA.ID_CULTURA_PK%TYPE := -1;
BEGIN
SAVEPOINT BEFORE_INSERT;
INSERT INTO CULTURA(ID_CULTURA_PK,TIPO_CULTURA,ESPECIE) VALUES (DEFAULT,UPPER(tipo_cultura_param),especie_param);
SELECT CULTURA.ID_CULTURA_PK into id_cultura from CULTURA
WHERE (TIPO_CULTURA = UPPER(tipo_cultura_param) AND
       ESPECIE = especie_param);
DBMS_OUTPUT.PUT_LINE('Cultura adicionada.');

RETURN id_cultura;
EXCEPTION
    WHEN too_many_rows THEN
        DBMS_OUTPUT.PUT_LINE('Já existe uma cultura com estes dados. Id da cultura:');
ROLLBACK TO SAVEPOINT BEFORE_INSERT;
SELECT CULTURA.ID_CULTURA_PK into id_cultura from CULTURA
WHERE (TIPO_CULTURA = UPPER(tipo_cultura_param) AND
       ESPECIE = especie_param);
RETURN id_cultura;
WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT BEFORE_INSERT;
        DBMS_OUTPUT.PUT_LINE('Não foi possível criar a cultura.');
RETURN id_cultura;
END;