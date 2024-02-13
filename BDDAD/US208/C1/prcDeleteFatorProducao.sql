create or replace PROCEDURE prcDeleteFatorProducao(ID_FATOR in FATORPRODUCAO.ID_FATOR_PRODUCAO_PK%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    DELETE FROM Elemento where id_fator_producao_fk = ID_Fator;
    DELETE From fatorproducao where ID_FATOR_PRODUCAO_PK = ID_FATOR; 
    DBMS_OUTPUT.PUT_LINE('Foi eliminado com sucesso');
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Não foi possivel eliminar o fator de produção');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;
