CREATE OR REPLACE PROCEDURE prcSetoresPorArea(id_caderno_campo_param PARCELA.ID_CADERNO_CAMPO_FK%TYPE,
                                                            ordem varchar2) AS
    parcela_dummy PARCELA%ROWTYPE;
CURSOR c_parcelas_asc IS
SELECT * FROM PARCELA
WHERE ID_CADERNO_CAMPO_FK = id_caderno_campo_param
ORDER BY AREA;
CURSOR c_parcelas_desc IS
SELECT * FROM PARCELA
WHERE ID_CADERNO_CAMPO_FK = id_caderno_campo_param
ORDER BY AREA DESC;
ordem_invalida EXCEPTION;
    id_invalido EXCEPTION;
    contador number;
BEGIN
SELECT COUNT(*) INTO contador FROM PARCELA
WHERE ID_CADERNO_CAMPO_FK = id_caderno_campo_param;
if (contador = 0) THEN
        RAISE id_invalido;
END IF;
    IF (UPPER(ordem) = 'ASC' OR UPPER(ordem) = 'ASCENDENTE') THEN
        OPEN c_parcelas_asc;
        DBMS_OUTPUT.PUT_LINE('Setores por ordem ascendente de áreas :');
        LOOP
FETCH c_parcelas_asc INTO parcela_dummy;
            EXIT WHEN c_parcelas_asc%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('ID : ' || parcela_dummy.ID_PARCELA_PK || ' | Designação :  ' || parcela_dummy.DESIGNACAO || ' | Área : ' || parcela_dummy.AREA);
END LOOP;
CLOSE c_parcelas_asc;
ELSIF (UPPER(ordem) = 'DESC' OR UPPER(ordem) = 'DESCENDENTE') THEN
        OPEN c_parcelas_desc;
        DBMS_OUTPUT.PUT_LINE('Setores por ordem descendente de áreas :');
        LOOP
FETCH c_parcelas_desc INTO parcela_dummy;
            EXIT WHEN c_parcelas_desc%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('ID : ' || parcela_dummy.ID_PARCELA_PK || ' | Designação :  ' || parcela_dummy.DESIGNACAO || ' | Área : ' || parcela_dummy.AREA);
END LOOP ;
CLOSE c_parcelas_desc;
ELSE
        RAISE ordem_invalida;
END IF;
EXCEPTION
    WHEN ordem_invalida THEN
        DBMS_OUTPUT.PUT_LINE('Parâmetro de ordenação inválida.');
WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Parâmetros inválidos.');
END;