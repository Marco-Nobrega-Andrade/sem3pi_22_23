CREATE OR REPLACE PROCEDURE prclistarSetoresPorLucro(id_cultura CULTURA.ID_CULTURA_PK%TYPE) AS
    crs_id_parcela PARCELA.ID_PARCELA_PK%TYPE;
    crs_designacao PARCELA.DESIGNACAO%TYPE;
    crs_valor ENCOMENDA.VALOR%TYPE;
    v_cultura CULTURA.ESPECIE%TYPE;
CURSOR crs_ids_parcela IS
SELECT DISTINCT ID_PARCELA_PK FROM PARCELA;
v_id_parcela PARCELA.ID_PARCELA_PK%TYPE;
    sum_lucro ENCOMENDA.VALOR%TYPE;

CURSOR list_setores_lucros IS
SELECT DISTINCT PC.ID_PARCELA_PK, PC.DESIGNACAO, E.VALOR
FROM CULTURA C
         INNER JOIN PLANTACAO P on C.ID_CULTURA_PK = P.ID_CULTURA_FK
         INNER JOIN PARCELA PC on P.ID_PARCELA_FK = PC.ID_PARCELA_PK
         INNER JOIN DISTRIBUICAO D on P.ID_PLANTACAO_PK = D.ID_PLANTACAO_FK
         INNER JOIN ENCOMENDA E on E.ID_DISTRIBUICAO_FK = D.ID_DISTRIBUICAO_PK
WHERE C.ID_CULTURA_PK=id_cultura
ORDER BY E.VALOR DESC;

BEGIN

SELECT C.ESPECIE INTO v_cultura
FROM CULTURA C
WHERE C.ID_CULTURA_PK= id_cultura;

OPEN list_setores_lucros;
OPEN crs_ids_parcela;
LOOP
FETCH list_setores_lucros INTO crs_id_parcela, crs_designacao, crs_valor;
FETCH crs_ids_parcela INTO v_id_parcela;
EXIT WHEN list_setores_lucros%notfound;
        EXIT WHEN crs_ids_parcela%notfound;
SELECT SUM (E.VALOR) INTO sum_lucro
FROM CULTURA C
         INNER JOIN PLANTACAO P on C.ID_CULTURA_PK = P.ID_CULTURA_FK
         INNER JOIN PARCELA PC on P.ID_PARCELA_FK = PC.ID_PARCELA_PK
         INNER JOIN DISTRIBUICAO D on P.ID_PLANTACAO_PK = D.ID_PLANTACAO_FK
         INNER JOIN ENCOMENDA E on E.ID_DISTRIBUICAO_FK = D.ID_DISTRIBUICAO_PK
WHERE C.ID_CULTURA_PK=id_cultura AND PC.ID_PARCELA_PK=v_id_parcela;
IF (sum_lucro IS null) THEN
            DBMS_OUTPUT.PUT_LINE('Não existem registos de lucro nesta parcela!');
ELSE
            DBMS_OUTPUT.PUT_LINE(' ID DO SETOR: '|| crs_id_parcela || ' || DESIGNAÇÃO: ' || crs_designacao|| ' || LUCRO ' ||sum_lucro || ' || CULTURA ' ||v_cultura);
END IF;
END LOOP;
CLOSE list_setores_lucros;
CLOSE crs_ids_parcela;

END;