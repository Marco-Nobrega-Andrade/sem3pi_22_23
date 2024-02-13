create or replace procedure prcListarTodasAsOperacoesNumIntervaloDeTempoPorSetor(data_inicio in VARCHAR2,
                            data_fim in Varchar2,
                            ordem in Varchar2) as


cursor c_asc is (select * from
        (( select
          'Rega' as TableSource,
          id_rega_pk as id,
          data_rega as datainicial,
          id_parcela_fk as id_parcela
       from
          rega
       )
UNION
   ( select
          'Fertilizacao' as TableSource,
          id_fertilizacao_pk as id,
          data_aplicacao as datainicial,
          (select id_parcela_fk from plantacao where( id_plantacao_fk = plantacao.id_plantacao_pk)) as id_parcela
       from
          Fertilizacao 
      ))where (TO_DATE(data_INICIO, 'dd-mm-yyyy') <= datainicial and TO_DATE(data_fim, 'dd-mm-yyyy') >= datainicial)) order by id_parcela,datainicial;
      
cursor c_desc is (select * from
        (( select
          'Rega' as TableSource,
          id_rega_pk as id,
          data_rega as datainicial,
          id_parcela_fk as id_parcela
       from
          rega 
       ) 
UNION
   ( select
          'Fertilizacao' as TableSource,
          id_fertilizacao_pk as id,
          data_aplicacao as datainicial,
          (select id_parcela_fk from plantacao where( id_plantacao_fk = plantacao.id_plantacao_pk)) as id_parcela
       from
          Fertilizacao 
      ))where (TO_DATE(data_INICIO, 'dd-mm-yyyy') <= datainicial and TO_DATE(data_fim, 'dd-mm-yyyy') >= datainicial)) order by id_parcela,datainicial desc;      
      
dummy c_asc%Rowtype;
ordem_invalida EXCEPTION;
setor number :=0;
Begin
    
    IF (UPPER(ordem) = 'ASC' OR UPPER(ordem) = 'ASCENDENTE') THEN
        OPEN c_asc;
        DBMS_OUTPUT.PUT_LINE('Operações por ordem ascendente:');
        LOOP
        FETCH c_asc INTO dummy;
            EXIT WHEN c_asc%NOTFOUND;
                if(dummy.id_parcela != setor) then 
                    setor:= dummy.id_parcela;
                    DBMS_OUTPUT.PUT_LINE('');
                    DBMS_OUTPUT.PUT_LINE('Setor ' || setor);
                    DBMS_OUTPUT.PUT_LINE('');                    
                end if;
                IF (dummy.TableSource like 'Rega') then
                    DBMS_OUTPUT.PUT_LINE('Operação: ' || dummy.TableSource || '         | ID: ' || dummy.id || ' | Setor: ' || dummy.id_parcela || '| Data: ' || dummy.datainicial);
                    ElsIF (dummy.TableSource like 'Fertilizacao') then
                        DBMS_OUTPUT.PUT_LINE('Operação: ' || dummy.TableSource || ' | ID: ' || dummy.id || ' | Setor: ' || dummy.id_parcela || '| Data: ' || dummy.datainicial);
                end if;
            END LOOP;
            CLOSE c_asc;
    ELSIF(UPPER(ordem) = 'DESC' OR UPPER(ordem) = 'DESCENDENTE') THEN
        OPEN c_desc;
        DBMS_OUTPUT.PUT_LINE('Operações por ordem descendente:');
        LOOP
        FETCH c_desc INTO dummy;
            EXIT WHEN c_desc%NOTFOUND;
                if(dummy.id_parcela != setor) then 
                    setor:= dummy.id_parcela;
                    DBMS_OUTPUT.PUT_LINE('');
                    DBMS_OUTPUT.PUT_LINE('Setor ' || setor);
                    DBMS_OUTPUT.PUT_LINE('');
                end if;
                IF (dummy.TableSource like 'Rega') then
                     DBMS_OUTPUT.PUT_LINE('Operação: ' || dummy.TableSource || '         | ID: ' || dummy.id || ' | Setor: ' || dummy.id_parcela || '| Data: ' || dummy.datainicial);
                    ElsIF (dummy.TableSource like 'Fertilizacao') then
                        DBMS_OUTPUT.PUT_LINE('Operação: ' || dummy.TableSource || ' | ID: ' || dummy.id || ' | Setor: ' || dummy.id_parcela || '| Data: ' || dummy.datainicial);
                end if;
            END LOOP;
            CLOSE c_desc;
    ELSE
        RAISE ordem_invalida;
    END IF;

EXCEPTION
    WHEN ordem_invalida THEN
        DBMS_OUTPUT.PUT_LINE('Parâmetro de ordenação inválida. Por favor insira "descendente" ou "ascendente');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Parâmetros inválidos.');
end;

Set serveroutput on    
begin
    prcListarTodasAsOperacoesNumIntervaloDeTempoPorSetor('01-12-2022','01-12-2023','ASC');
end;

SELECT * from fertilizacao; 
select * from restricaofatorproducao;