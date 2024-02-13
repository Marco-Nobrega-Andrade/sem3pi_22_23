CREATE OR REPLACE procedure prcAdicionarFertilizacao (id_plantacao IN fertilizacao.id_plantacao_fk%type,
                                                        id_fator_producao IN fertilizacao.id_fator_producao_fk%type,
                                                        quantidade_param in fertilizacao.quantidade%type,
                                                        data_param IN VARCHAR2
                                                        ) AS
 
ID_Parcela Parcela.id_parcela_pk%type;
ID_Fertilizacao Fertilizacao.id_fertilizacao_pk%type;
restricao_ativa exception;
BEGIN
    SAVEPOINT BEFORECALL;
    
    Select plantacao.id_parcela_fk into ID_PARCELA from plantacao Where (plantacao.id_plantacao_pk = id_plantacao);
    
    
    FOR restricao IN (
        SELECT *
          FROM restricaofatorproducao
         WHERE (restricaofatorproducao.id_parcela_fk = id_parcela and restricaofatorproducao.id_fator_producao_fk = id_fator_producao))
   LOOP
      IF (restricao.data_inicio <= TO_DATE(data_param, 'dd-mm-yyyy') and restricao.data_fim >= TO_DATE(data_param, 'dd-mm-yyyy')) then
            raise restricao_ativa;
      end if;
   END LOOP;
    
    insert into Fertilizacao (id_fertilizacao_pk,id_plantacao_fk, id_fator_producao_fk, data_aplicacao, quantidade)
    values (DEFAULT,id_plantacao, id_fator_producao, TO_DATE(data_param, 'dd-mm-yyyy'), quantidade_param);
    
    Select Fertilizacao.id_fertilizacao_pk into ID_Fertilizacao from fertilizacao where(id_plantacao_fk = id_plantacao 
    and id_fator_producao_fk = id_fator_producao 
    and data_aplicacao = TO_DATE(data_param, 'dd-mm-yyyy')
    and quantidade = quantidade_param
    ); 
    DBMS_OUTPUT.PUT_LINE('Foi adicionado uma fertilizacao com o id: ' || id_fertilizacao);
EXCEPTION
    when restricao_ativa then
    ROLLBACK TO SAVEPOINT BEFORECALL;
    DBMS_OUTPUT.PUT_LINE('Não foi possivel adicionar a fertilização devido a existir uma restrição nessa data');
    WHEN OTHERS THEN
    ROLLBACK TO SAVEPOINT BEFORECALL;
    DBMS_OUTPUT.PUT_LINE('Não foi possivel adicionar a fertilização');
end;

Set serveroutput on    
begin
    prcAdicionarFertilizacao(1,1,2000,'09-02-2023');
end;
