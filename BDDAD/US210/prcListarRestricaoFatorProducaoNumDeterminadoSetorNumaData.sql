CREATE OR REPLACE procedure prcListarRestricaoFatorProducaoNumDeterminadoSetorNumaData(id_parcela IN restricaofatorproducao.id_parcela_fk%type,                                                      
                                                        data_param IN VARCHAR2
                                                        ) AS
 
BEGIN
    SAVEPOINT BEFORECALL;    
    FOR restricao IN (
        SELECT *
          FROM restricaofatorproducao
         WHERE (restricaofatorproducao.id_parcela_fk = id_parcela))
   LOOP
      IF (restricao.data_inicio <= TO_DATE(data_param, 'dd-mm-yyyy') and restricao.data_fim >= TO_DATE(data_param, 'dd-mm-yyyy')) then
            DBMS_OUTPUT.PUT_LINE('ID : ' || restricao.id_restricao_fator_producao_pk || ' | ID PARCELA :  ' || restricao.ID_PARCELA_FK || ' | ID FATOR PRODUCAO : ' || restricao.ID_Fator_producao_fk 
            || ' | DATA INICIO : ' || restricao.data_inicio|| ' | DATA INICIO : ' ||  restricao.data_fim);
      end if;
   END LOOP;

EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK TO SAVEPOINT BEFORECALL;
    DBMS_OUTPUT.PUT_LINE('Não foi listas as restrições');
end;