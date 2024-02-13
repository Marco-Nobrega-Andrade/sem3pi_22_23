CREATE OR REPLACE PROCEDURE prcEvolucaoProducaoUltimosCincoAnos(id_cultura DimCultura.ID_DIM_CULTURA_PK%TYPE,
                                                  id_setor DimSetor.ID_DIM_SETOR_PK%TYPE) AS

    sum_producao_primeiro_ano FactProducao.quantidade%TYPE;
    sum_producao_segundo_ano FactProducao.quantidade%TYPE;
    primeiro_ano DIMANO.ID_DIM_ANO_PK%TYPE;
    segundo_ano DIMANO.ID_DIM_ANO_PK%TYPE;
    count_producao number;
    dif_producao FactProducao.quantidade%TYPE;
    this_year varchar(255);
    this_year_number number;
    counter_ano number;

BEGIN
SELECT to_char(sysdate, 'YYYY') INTO this_year FROM DUAL;
this_year_number := CAST(this_year AS NUMBER);
counter_ano := 0;
LOOP
EXIT WHEN primeiro_ano = this_year_number - 5;
    primeiro_ano := this_year_number - counter_ano - 1;
    segundo_ano := this_year_number - counter_ano;
    counter_ano:= counter_ano + 1;


-- PRIMEIRO ANO
----------------------------------//---------------------------------------
SELECT COUNT(F.quantidade) INTO count_producao FROM FactProducao F
                                                        INNER JOIN DIMTEMPO T ON F.ID_DIM_TEMPO_FK = T.ID_DIM_TEMPO_PK
                                                        INNER JOIN DIMPRODUTO P ON F.ID_DIM_PRODUTO_FK = P.ID_DIM_PRODUTO_PK
                                                        INNER JOIN DimSetor S ON F.id_dim_setor_fk = S.id_dim_setor_pk
WHERE T.id_dim_ano_fk = primeiro_ano AND P.ID_DIM_TIPO_CULTURA_FK = id_cultura AND F.id_dim_setor_fk = id_setor;

IF count_producao != 0 THEN
            -- SUM ANO
SELECT SUM(F.quantidade) INTO sum_producao_primeiro_ano FROM FactProducao F
                                                                 INNER JOIN DIMTEMPO T ON F.ID_DIM_TEMPO_FK = T.ID_DIM_TEMPO_PK
                                                                 INNER JOIN DIMPRODUTO P ON F.ID_DIM_PRODUTO_FK = P.ID_DIM_PRODUTO_PK
                                                                 INNER JOIN DimSetor S ON F.id_dim_setor_fk = S.id_dim_setor_pk
WHERE T.id_dim_ano_fk = primeiro_ano AND P.ID_DIM_TIPO_CULTURA_FK = id_cultura AND F.id_dim_setor_fk = id_setor;

ELSE sum_producao_primeiro_ano := 0;
END IF;

----------------------------------//---------------------------------------
-- SEGUNDO ANO
SELECT COUNT(F.quantidade) INTO count_producao FROM FactProducao F
                                                        INNER JOIN DIMTEMPO T ON F.ID_DIM_TEMPO_FK = T.ID_DIM_TEMPO_PK
                                                        INNER JOIN DIMPRODUTO P ON F.ID_DIM_PRODUTO_FK = P.ID_DIM_PRODUTO_PK
                                                        INNER JOIN DimSetor S ON F.id_dim_setor_fk = S.id_dim_setor_pk
WHERE T.id_dim_ano_fk = segundo_ano AND P.ID_DIM_TIPO_CULTURA_FK = id_cultura AND F.id_dim_setor_fk = id_setor;

IF count_producao != 0 THEN
            -- SUM ANO
SELECT SUM(F.quantidade) INTO sum_producao_segundo_ano FROM FactProducao F
                                                                INNER JOIN DIMTEMPO T ON F.ID_DIM_TEMPO_FK = T.ID_DIM_TEMPO_PK
                                                                INNER JOIN DIMPRODUTO P ON F.ID_DIM_PRODUTO_FK = P.ID_DIM_PRODUTO_PK
                                                                INNER JOIN DimSetor S ON F.id_dim_setor_fk = S.id_dim_setor_pk
WHERE T.id_dim_ano_fk = segundo_ano AND P.ID_DIM_TIPO_CULTURA_FK = id_cultura AND F.id_dim_setor_fk = id_setor;

ELSE sum_producao_segundo_ano := 0;
END IF;

----------------------------------//---------------------------------------


    dif_producao := sum_producao_segundo_ano - sum_producao_primeiro_ano;

    IF dif_producao < 0 THEN
	    DBMS_OUTPUT.PUT_LINE('Em '|| segundo_ano || ' foram produzidos ' || dif_producao || ' produtos da cultura ' || id_cultura || ' do que em ' || primeiro_ano);
ELSE
	    IF dif_producao = 0 THEN
	 	    DBMS_OUTPUT.PUT_LINE('Foi produzida a mesma quantidade em ' || segundo_ano || ' e ' || primeiro_ano);
ELSE
		    DBMS_OUTPUT.PUT_LINE('Em '|| segundo_ano || ' foram produzidos +' || dif_producao || ' produtos da cultura ' || id_cultura || ' do que em ' || primeiro_ano);
END IF;
END IF;
END LOOP;
END;