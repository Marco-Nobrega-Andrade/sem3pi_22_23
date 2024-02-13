CREATE OR REPLACE PROCEDURE prclistarSetoresPorQuantidadeCultura(id_cultura CULTURA.ID_CULTURA_PK%TYPE) AS
    crs_id_parcela PARCELA.ID_PARCELA_PK%TYPE;
    crs_designacao PARCELA.DESIGNACAO%TYPE;
    crs_qtd PLANTACAO.QUANTIDADE_COLHIDA%TYPE;
    v_cultura CULTURA.ESPECIE%TYPE;
CURSOR crs_ids_parcela IS
SELECT DISTINCT ID_PARCELA_PK FROM PARCELA;
v_id_parcela PARCELA.ID_PARCELA_PK%TYPE;
    quantidade_total PLANTACAO.QUANTIDADE_COLHIDA%TYPE;

CURSOR list_setores_quantidade IS
SELECT DISTINCT PC.ID_PARCELA_PK, PC.DESIGNACAO, P.QUANTIDADE_COLHIDA
FROM CULTURA C
         INNER JOIN PLANTACAO P on C.ID_CULTURA_PK = P.ID_CULTURA_FK
         INNER JOIN PARCELA PC on P.ID_PARCELA_FK = PC.ID_PARCELA_PK
WHERE C.ID_CULTURA_PK=id_cultura
ORDER BY P.QUANTIDADE_COLHIDA DESC;
BEGIN

SELECT C.ESPECIE INTO v_cultura
FROM CULTURA C
WHERE C.ID_CULTURA_PK= id_cultura;

OPEN list_setores_quantidade;
OPEN crs_ids_parcela;
LOOP
FETCH list_setores_quantidade INTO crs_id_parcela, crs_designacao, crs_qtd;
FETCH crs_ids_parcela INTO v_id_parcela;
EXIT WHEN list_setores_quantidade%notfound;
        EXIT WHEN crs_ids_parcela%notfound;
SELECT SUM (P.QUANTIDADE_COLHIDA) INTO quantidade_total
FROM CULTURA C
         INNER JOIN PLANTACAO P on C.ID_CULTURA_PK = P.ID_CULTURA_FK
         INNER JOIN PARCELA PC on P.ID_PARCELA_FK = PC.ID_PARCELA_PK
WHERE C.ID_CULTURA_PK=id_cultura AND PC.ID_PARCELA_PK=v_id_parcela;

IF (quantidade_total IS null) THEN
            DBMS_OUTPUT.PUT_LINE('Não existem registos de quantidades colhidas nesta parcela!');
ELSE
            DBMS_OUTPUT.PUT_LINE(' ID DO SETOR: '|| crs_id_parcela || ' || DESIGNAÇÃO: ' || crs_designacao|| ' || QUANTIDADE COLHIDA ' ||quantidade_total || ' || CULTURA ' ||v_cultura);
END IF;
END LOOP;
CLOSE list_setores_quantidade;
CLOSE crs_ids_parcela;

END;