CREATE OR REPLACE FUNCTION fncAdicionarRega (id_parcela IN Rega.id_parcela_fk%type,
                                                        tipo_rega_param IN rega.tipo_rega%type,
                                                        data_param IN VARCHAR2
                                                        ) RETURN Rega.id_rega_pk%type AS
                                                        
ID_REGA Rega.id_rega_pk%type;                                                        
BEGIN
    SAVEPOINT BEFORECALL;
    insert into Rega (id_rega_pk, id_parcela_fk, data_rega, tipo_rega)
    values (DEFAULT, 1,TO_DATE(data_param, 'dd-mm-yyyy'), 'GRAVIDADE');
    
    Select Rega.id_rega_pk into ID_REGA from Rega
        where (id_parcela =  rega.id_parcela_fk 
        and LOWER(tipo_rega_param) LIKE LOWER(rega.tipo_rega) and 
        TO_DATE(data_param, 'dd-mm-yyyy') = rega.data_rega);
    DBMS_OUTPUT.PUT_LINE('Rega adicionada com o seguinte id: ');
    RETURN ID_REGA;
EXCEPTION
     When too_many_rows then
     ROLLBACK TO SAVEPOINT BEFORECALL;
     DBMS_OUTPUT.PUT_LINE('Essa REGA ja existe com o seguinte id: ');
        Select Rega.id_rega_pk into ID_REGA from Rega
            where (id_parcela =  rega.id_parcela_fk 
            and lower(tipo_rega_param) like lower(rega.tipo_rega) and 
            TO_DATE(data_param, 'dd-mm-yyyy') = rega.data_rega);
    RETURN ID_REGA;
    WHEN OTHERS THEN
    ROLLBACK TO SAVEPOINT BEFORECALL;
    DBMS_OUTPUT.PUT_LINE('Não foi possivel adicionar');
    ID_REGA :=-1;
    RETURN ID_REGA;
end;