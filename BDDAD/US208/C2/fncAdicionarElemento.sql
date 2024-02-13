CREATE OR REPLACE FUNCTION fncAdicionarElemento (id_fator IN ELEMENTO.ID_FATOR_PRODUCAO_FK%type,
                                                        subs IN ELEMENTO.SUBSTANCIA%type,
                                                        qtd IN ELEMENTO.QUANTIDADE%type,
                                                        uni IN ElEMENTO.UNIDADE%type,
                                                        ctg IN ELEMENTO.CATEGORIA%type) RETURN ELEMENTO.ID_ELEMENTO_PK%type AS
ID_ELEMENTO ELEMENTO.ID_ELEMENTO_PK%type;                                                        
BEGIN
    SAVEPOINT BEFORECALL;
    INSERT INTO ELEMENTO (ID_ELEMENTO_PK,ID_FATOR_PRODUCAO_FK,SUBSTANCIA,QUANTIDADE,UNIDADE,CATEGORIA)
    VALUES (DEFAULT,id_fator,subs, qtd,uni,ctg);
    UPDATE Elemento
    SET categoria = LOWER(categoria), substancia = LOWER(substancia);
    Select id_elemento_pk into id_elemento from elemento
        where (id_fator_producao_fk =  id_fator 
        and lower(substancia) = lower(subs)
        and lower (categoria) = lower(ctg));
    DBMS_OUTPUT.PUT_LINE('Elemento Adicionado com o seguinte id:');
    RETURN id_elemento;
EXCEPTION
    When too_many_rows then
     DBMS_OUTPUT.PUT_LINE('Esse Elemento já existe com o seguinte id:');
     ROLLBACK TO SAVEPOINT BEFORECALL;
     Select id_elemento_pk into id_elemento from elemento
        where (id_fator_producao_fk =  id_fator 
        and lower(substancia) = lower(subs)
        and lower (categoria) = lower(ctg));
     RETURN id_elemento;
    WHEN OTHERS THEN
    ROLLBACK TO SAVEPOINT BEFORECALL;
    DBMS_OUTPUT.PUT_LINE('Não foi possivel adicionar o Elemento');
    id_elemento :=-1;
    RETURN ID_FATOR;
end;
