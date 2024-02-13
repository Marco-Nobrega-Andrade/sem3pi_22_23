CREATE OR REPLACE FUNCTION fncAdicionarFatorDeProducao (nomeComercial IN FATORPRODUCAO.NOME_COMERCIAL%type,
                                                        formul IN FATORPRODUCAO.FORMULACAO%type,
                                                        classi IN FATORPRODUCAO.CLASSIFICACAO%type,
                                                        forn IN FATORPRODUCAO.FORNECEDOR%type) RETURN FATORPRODUCAO.ID_FATOR_PRODUCAO_PK%type AS
ID_FATOR FATORPRODUCAO.ID_FATOR_PRODUCAO_PK%type;                                                        
BEGIN
    SAVEPOINT BEFORECALL;
    INSERT INTO FATORPRODUCAO (ID_FATOR_PRODUCAO_PK,NOME_COMERCIAL,FORMULACAO,CLASSIFICACAO,FORNECEDOR)
    VALUES (DEFAULT,nomeComercial, formul,classi,forn);
    UPDATE fatorproducao
    SET formulacao = LOWER(formulacao), classificacao = LOWER(classificacao);
    Select fatorproducao.id_fator_producao_pk into id_fator from fatorproducao
        where (nome_comercial =  nomecomercial 
        and lower(formulacao) = lower(formul)
        and lower (classificacao) = lower(classi)
        and fornecedor = forn);
    DBMS_OUTPUT.PUT_LINE('Fator de Produção Adicionado');
    RETURN ID_FATOR;
EXCEPTION
    When too_many_rows then
     DBMS_OUTPUT.PUT_LINE('Ja existe');
     ROLLBACK TO SAVEPOINT BEFORECALL;
     Select fatorproducao.id_fator_producao_pk into id_fator from fatorproducao
        where (nome_comercial =  nomecomercial 
        and lower(formulacao) = lower(formul)
        and lower (classificacao) = lower(classi)
        and fornecedor = forn);
     RETURN id_fator;
    WHEN OTHERS THEN
    ROLLBACK TO SAVEPOINT BEFORECALL;
    DBMS_OUTPUT.PUT_LINE('Não foi possivel adicionar o Fator de Produção');
    ID_FATOR :=-1;
    RETURN ID_FATOR;
end;