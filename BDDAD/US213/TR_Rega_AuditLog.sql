CREATE or replace TRIGGER TR_REGA_AUDITLOG after Insert or Update or Delete ON Rega
REFERENCING NEW AS NEW OLD AS OLD
For each row

    DECLARE 
    v_user varchar2 (30);
    v_time timeStamp;
    v_operacao varchar2 (6);
    v_table varchar(12) := 'Rega';
    v_Parcela_id Parcela.id_parcela_pk%type;
    
BEGIN
    SELECT user,systimestamp INTO v_user, v_time  FROM dual; 
    IF DELETING THEN 
        v_Parcela_id := :OLD.id_parcela_fk;       
        v_operacao := 'DELETE';
    END IF;

    IF INSERTING THEN 
        v_Parcela_id := :NEW.id_parcela_fk;       
        v_operacao := 'INSERT';
    END IF;
        
    IF UPDATING THEN
        v_Parcela_id := :NEW.id_parcela_fk;       
        v_operacao := 'UPDATE';
    END IF;
    
    insert into Auditlog (id_audit_log_pk,id_parcela_fk,data_audit_log,operacao,tabela,utilizador) values (DEFAULT,v_parcela_id,v_time,v_operacao,v_table,v_user);

end;
