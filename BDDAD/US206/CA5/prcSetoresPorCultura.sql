CREATE OR REPLACE PROCEDURE prcSetoresPorCultura(id_caderno_campo_param PARCELA.ID_CADERNO_CAMPO_FK%TYPE) AS

    CURSOR c_output IS
SELECT  PARCELA.ID_PARCELA_PK,PARCELA.DESIGNACAO, C.ESPECIE, C.TIPO_CULTURA, P.ID_PLANTACAO_PK FROM PARCELA
INNER JOIN PLANTACAO P ON PARCELA.ID_PARCELA_PK = P.ID_PARCELA_FK
INNER JOIN CULTURA C ON P.ID_CULTURA_FK = C.ID_CULTURA_PK
WHERE ID_CADERNO_CAMPO_FK = id_caderno_campo_param
ORDER BY ID_CULTURA_FK;

id_parcela PARCELA.ID_PARCELA_PK%TYPE;
    designacao PARCELA.DESIGNACAO%TYPE;
    especie CULTURA.ESPECIE%TYPE;
    tipo_cultura CULTURA.TIPO_CULTURA%TYPE;
    id_plantacao PLANTACAO.ID_PLANTACAO_PK%TYPE;
    contador number;
    id_invalido EXCEPTION;
BEGIN
SELECT COUNT(*) INTO contador FROM PARCELA
                                       INNER JOIN PLANTACAO P ON PARCELA.ID_PARCELA_PK = P.ID_PARCELA_FK
                                       INNER JOIN CULTURA C ON P.ID_CULTURA_FK = C.ID_CULTURA_PK
WHERE ID_CADERNO_CAMPO_FK = id_caderno_campo_param;
if (contador = 0) THEN
        RAISE id_invalido;
END IF;
OPEN c_output;
LOOP
FETCH c_output INTO id_parcela,designacao,especie,tipo_cultura,id_plantacao;
        EXIT WHEN c_output%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID do Setor: ' || id_parcela || ' | Designação do Setor :  ' || designacao || ' | Espécie da Cultura : ' || especie || ' | Tipo da cultura : ' || tipo_cultura || ' | ID da Plantacão : ' || id_plantacao);
END LOOP;
CLOSE c_output;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Parâmetro inválido.');
END;