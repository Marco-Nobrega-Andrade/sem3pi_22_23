CREATE OR REPLACE FUNCTION compute_risk_factor(p_id_cliente Cliente.ID_UTILIZADOR_CLIENTE_FK%type)
    RETURN NUMBER
    IS
    v_data_incidente INCIDENTE.DATA_INCIDENTE%TYPE;
    v_valor_incidente INCIDENTE.VALOR_INCIDENTE%TYPE;
    v_data_registo_encomenda ENCOMENDA.DATA_REGISTO%type;

    v_valor_total_incidentes NUMBER := 0;
    v_contador_total_encomendas NUMBER := 0;
    v_incidente_mais_recente INCIDENTE.DATA_INCIDENTE%TYPE := TO_DATE('01/01/1971', 'DD/MM/YYYY');
    CURSOR c_incidentes is
        SELECT DATA_INCIDENTE, VALOR_INCIDENTE
        FROM INCIDENTE
        WHERE (ID_UTILIZADOR_CLIENTE_FK = p_id_cliente AND DATA_INCIDENTE > add_months(sysdate, -12));


        CURSOR c_encomendas is
        SELECT  DATA_REGISTO
        FROM ENCOMENDA
        WHERE ID_DISTRIBUICAO_FK IN (SELECT ID_DISTRIBUICAO_PK
                                     FROM DISTRIBUICAO
                                     WHERE ((ID_UTILIZADOR_CLIENTE_FK = 3) AND (STATUS != 'PAGA')));
BEGIN

    OPEN c_incidentes;
    LOOP
        FETCH c_incidentes INTO v_data_incidente, v_valor_incidente;
        EXIT WHEN c_incidentes%NOTFOUND;
        if (v_data_incidente > v_incidente_mais_recente) then
            v_incidente_mais_recente := v_data_incidente;
        end if;
        v_valor_total_incidentes := v_valor_total_incidentes + v_valor_incidente;
    END LOOP;
   close c_incidentes;
    dbms_output.put_line( 'v_incidente_mais_recente: ' || v_incidente_mais_recente || ' v_valor_total_incidentes: ' || v_valor_total_incidentes);

    open c_encomendas;
    LOOP
        FETCH c_encomendas INTO  v_data_registo_encomenda;
        EXIT WHEN c_encomendas%NOTFOUND;
        if (v_data_registo_encomenda > v_incidente_mais_recente) then
            v_contador_total_encomendas := v_contador_total_encomendas + 1;
        end if;
    END LOOP;
    close c_encomendas;
    dbms_output.put_line( 'encomendas totais feitas posteriormente ao ultimo incidente: ' || v_contador_total_encomendas);

    return v_valor_total_incidentes / v_contador_total_encomendas;
end;

-- Drop the function

DROP FUNCTION compute_risk_factor;


SELECT DATA_INCIDENTE, VALOR_INCIDENTE
FROM INCIDENTE
WHERE (ID_UTILIZADOR_CLIENTE_FK = 3 AND DATA_INCIDENTE > add_months(sysdate, -12));