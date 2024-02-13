CREATE OR REPLACE PROCEDURE prcSetoresPorOrdemAlfabetica(id_caderno_campo_param PARCELA.ID_CADERNO_CAMPO_FK%TYPE) AS
    parcela_dummy PARCELA%ROWTYPE;
CURSOR c_parcela IS
SELECT * FROM parcela
WHERE ID_CADERNO_CAMPO_FK = id_caderno_campo_param
ORDER BY DESIGNACAO;
contador number;
    id_invalido EXCEPTION;
BEGIN
SELECT COUNT(*) INTO contador FROM PARCELA
WHERE ID_CADERNO_CAMPO_FK = id_caderno_campo_param;
if (contador = 0) THEN
        RAISE id_invalido;
END IF;
OPEN c_parcela;
LOOP
FETCH c_parcela INTO parcela_dummy;
        EXIT WHEN c_parcela%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID : ' || parcela_dummy.ID_PARCELA_PK || ' | Designação :  ' || parcela_dummy.DESIGNACAO || ' | Área : ' || parcela_dummy.AREA);
END LOOP;
CLOSE c_parcela;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Parâmetro inválido.');
END;