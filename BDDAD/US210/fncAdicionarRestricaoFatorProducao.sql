CREATE OR REPLACE FUNCTION fncAdicionarRestricaoFatorProducao (id_parcela IN RestricaoFatorProducao.id_parcela_fk%type,
                                                        id_fator_producao IN RestricaoFatorProducao.id_fator_producao_fk%type,
                                                        data_inicio_param IN VARCHAR2,
                                                        data_fim_param IN varchar2) RETURN RestricaoFatorProducao.id_restricao_fator_producao_pk%type AS
                                                        
ID_RESTRICAO RestricaoFatorProducao.id_restricao_fator_producao_pk%type;                                                        
BEGIN
    SAVEPOINT BEFORECALL;
    
    insert into RestricaoFatorProducao (id_restricao_fator_producao_pk, id_parcela_fk, id_fator_producao_fk, data_inicio,data_fim)
    values (DEFAULT, id_parcela,id_fator_producao, TO_DATE(data_inicio_param, 'dd-mm-yyyy'), TO_DATE(data_fim_param, 'dd-mm-yyyy'));
    
    Select RestricaoFatorProducao.id_restricao_fator_producao_pk into ID_RESTRICAO from RestricaoFatorProducao
        where (id_parcela =  restricaofatorproducao.id_parcela_fk 
        and id_fator_producao = restricaofatorproducao.id_fator_producao_fk and 
        TO_DATE(data_inicio_param, 'dd-mm-yyyy') = restricaofatorproducao.data_inicio and 
         TO_DATE(data_fim_param, 'dd-mm-yyyy') = restricaofatorproducao.data_fim);
    DBMS_OUTPUT.PUT_LINE('Restrição de aplicação  do Fator de Producao Adicionado com o seguinte id: ');
    RETURN ID_RESTRICAO;
EXCEPTION
     When too_many_rows then
     DBMS_OUTPUT.PUT_LINE('Essa restrição ja existe com o seguinte id: ');
     ROLLBACK TO SAVEPOINT BEFORECALL;
     Select RestricaoFatorProducao.id_restricao_fator_producao_pk into ID_RESTRICAO from RestricaoFatorProducao
        where (id_parcela =  restricaofatorproducao.id_parcela_fk 
        and id_fator_producao = restricaofatorproducao.id_fator_producao_fk and 
        TO_DATE(data_inicio_param, 'dd-mm-yyyy') = restricaofatorproducao.data_inicio and 
         TO_DATE(data_fim_param, 'dd-mm-yyyy') = restricaofatorproducao.data_fim);
    RETURN ID_RESTRICAO;
    WHEN OTHERS THEN
    ROLLBACK TO SAVEPOINT BEFORECALL;
    DBMS_OUTPUT.PUT_LINE('Não foi possivel adicionar');
    ID_RESTRICAO :=-1;
    RETURN ID_RESTRICAO;
end;

set serveroutput on
begin
    DBMS_OUTPUT.PUT_LINE(fncAdicionarRestricaoFatorProducao(1,1,'18-07-2023','29-06-2023'));
end;
