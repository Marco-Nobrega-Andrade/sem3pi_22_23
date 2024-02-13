CREATE OR REPLACE PROCEDURE prcCompararVendasAnos(id_ano1 DIMANO.ID_DIM_ANO_PK%TYPE,
                                                  id_ano2 DIMANO.ID_DIM_ANO_PK%TYPE) AS
    sum_valor_ano1 FACTVENDAS.VALOR%TYPE;
    sum_valor_ano2 FACTVENDAS.VALOR%TYPE;
    count_vendas_ano1 NUMBER;
    count_vendas_ano2 NUMBER;
    dif_valor FACTVENDAS.VALOR%TYPE;
    this_year varchar(255);
    this_year_number number;
    e_data_final_maior_inicial EXCEPTION;
    e_data_maior_atual EXCEPTION;
    e_datas_iguais EXCEPTION;
BEGIN
    SELECT to_char(sysdate, 'YYYY') INTO this_year FROM DUAL;
    this_year_number := CAST(this_year AS NUMBER);

    IF this_year < id_ano1 OR this_year < id_ano2 THEN
        RAISE e_data_maior_atuaL;
    END IF;

    IF id_ano2 < id_ano1 THEN
        RAISE e_data_final_maior_inicial;
    END IF;

    IF id_ano2 = id_ano1 THEN
        RAISE e_datas_iguais;
    END IF;


    SELECT SUM(FACTVENDAS.VALOR) INTO sum_valor_ano1 FROM FACTVENDAS
                                                          INNER JOIN DIMTEMPO ON FACTVENDAS.ID_DIM_TEMPO_FK = DIMTEMPO.ID_DIM_TEMPO_PK
                                                          INNER JOIN DIMANO ON DIMTEMPO.ID_DIM_ANO_FK = DIMANO.ID_DIM_ANO_PK
    WHERE DIMANO.ID_DIM_ANO_PK = id_ano1;

    SELECT SUM(FACTVENDAS.VALOR) INTO sum_valor_ano2 FROM FACTVENDAS
                                                          INNER JOIN DIMTEMPO ON FACTVENDAS.ID_DIM_TEMPO_FK = DIMTEMPO.ID_DIM_TEMPO_PK
                                                          INNER JOIN DIMANO ON DIMTEMPO.ID_DIM_ANO_FK = DIMANO.ID_DIM_ANO_PK
    WHERE DIMANO.ID_DIM_ANO_PK = id_ano2;
    SELECT COUNT(FACTVENDAS.ID_FACT_VENDAS_PK) INTO count_vendas_ano1 FROM FACTVENDAS
                                                          INNER JOIN DIMTEMPO ON FACTVENDAS.ID_DIM_TEMPO_FK = DIMTEMPO.ID_DIM_TEMPO_PK
                                                          INNER JOIN DIMANO ON DIMTEMPO.ID_DIM_ANO_FK = DIMANO.ID_DIM_ANO_PK
    WHERE DIMANO.ID_DIM_ANO_PK = id_ano1;

    SELECT COUNT(FACTVENDAS.ID_FACT_VENDAS_PK) INTO count_vendas_ano2 FROM FACTVENDAS
                                                          INNER JOIN DIMTEMPO ON FACTVENDAS.ID_DIM_TEMPO_FK = DIMTEMPO.ID_DIM_TEMPO_PK
                                                          INNER JOIN DIMANO ON DIMTEMPO.ID_DIM_ANO_FK = DIMANO.ID_DIM_ANO_PK
    WHERE DIMANO.ID_DIM_ANO_PK = id_ano2;


    IF count_vendas_ano1 = 0 THEN
	    sum_valor_ano1 := 0;
    END IF;
    IF count_vendas_ano2 = 0 THEN
	        sum_valor_ano2 := 0;
    END IF;

    dif_valor := sum_valor_ano2 - sum_valor_ano1;
    dif_valor := dif_valor / 1000;
    SELECT ROUND(dif_valor, 2) INTO dif_valor FROM DUAL;

    IF dif_valor < 0 THEN
	    DBMS_OUTPUT.PUT_LINE('Em '|| id_ano2 || ' foram vendidos ' || dif_valor ||' mil € do que em ' || id_ano1);
    ELSE
	    IF dif_valor = 0 THEN
	 	    DBMS_OUTPUT.PUT_LINE('Foi vendido o mesmo valor em ambos os anos');
        ELSE
		    DBMS_OUTPUT.PUT_LINE('Em '|| id_ano2 || ' foram vendidos +' || dif_valor || 'mil € do que em ' || id_ano1);
        END IF;
    END IF;

EXCEPTION
    WHEN e_data_maior_atual THEN
        dbms_output.put_line('Erro: Um dos anos inseridos é superior ao atual.');
    WHEN e_data_final_maior_inicial THEN
        dbms_output.put_line('Erro: O ano final inserido é inferior ao inicial.');
    WHEN e_datas_iguais THEN
        dbms_output.put_line('Erro: Os anos que inseriu são os mesmos.');
END;
