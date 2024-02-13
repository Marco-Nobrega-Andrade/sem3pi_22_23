create or replace PROCEDURE prcDeleteElemento(ID_Elemento in ELEMENTO.ID_ELEMENTO_PK%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    DELETE FROM Elemento where id_elemento_pk = id_elemento;
    DBMS_OUTPUT.PUT_LINE('Foi eliminado com sucesso');
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Não foi possivel eliminar o elemento');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcDeleteFichaTecnica(id_fator in ELEMENTO.ID_FATOR_PRODUCAO_FK%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    DELETE FROM Elemento where id_fator_producao_fk = id_fator;
    DBMS_OUTPUT.PUT_LINE('Foi eliminado com sucesso');
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Não foi possivel eliminar a ficha tecnica');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;
