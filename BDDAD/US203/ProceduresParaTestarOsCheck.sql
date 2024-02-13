create or replace PROCEDURE prcTestCheckElementoQuantidade(qtd Elemento.Quantidade%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    INSERT INTO ELEMENTO (ID_ELEMENTO_PK,ID_FATOR_PRODUCAO_FK,SUBSTANCIA,QUANTIDADE,UNIDADE,CATEGORIA)
    VALUES (DEFAULT,1,'Nitrogenio',qtd,'mg','sustancia organica');
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;



create or replace PROCEDURE prcTestCheckClientePlafond(plafond_param Cliente.Plafond%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Cliente (id_utilizador_cliente_fk, id_morada_particular_fk, id_morada_entrega_fk, nome, plafond, num_fiscal, nivel_plafond, email, num_encomendas_colocadas, valor_encomendas) 
    values (4, 2, 1,'Beatriz', plafond_param,300876345, 'A', 'bea@outmail.com', 2,10);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;


create or replace PROCEDURE prcTestCheckClienteNivelPlafond(nivel_plafond_param Cliente.nivel_Plafond%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Cliente (id_utilizador_cliente_fk, id_morada_particular_fk, id_morada_entrega_fk, nome, plafond, num_fiscal, nivel_plafond, email, num_encomendas_colocadas, valor_encomendas) 
    values (4, 2, 1,'Beatriz', 12000,300876345, nivel_plafond_param, 'bea@outmail.com', 2,10);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckClienteNumFiscal(num_fiscal_param Cliente.num_fiscal%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Cliente (id_utilizador_cliente_fk, id_morada_particular_fk, id_morada_entrega_fk, nome, plafond, num_fiscal, nivel_plafond, email, num_encomendas_colocadas, valor_encomendas) 
    values (4, 2, 1,'Beatriz', 12000,num_fiscal_param, 'A', 'bea@outmail.com', 2,10);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckClienteEmail(email_param Cliente.email%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Cliente (id_utilizador_cliente_fk, id_morada_particular_fk, id_morada_entrega_fk, nome, plafond, num_fiscal, nivel_plafond, email, num_encomendas_colocadas, valor_encomendas) 
    values (4, 2, 1,'Beatriz', 12000,123321123, 'A', email_param, 2,10);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckClienteNumeroDeEncomendasColocadas(num_encomendas_colocadas_param Cliente.num_encomendas_colocadas%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Cliente (id_utilizador_cliente_fk, id_morada_particular_fk, id_morada_entrega_fk, nome, plafond, num_fiscal, nivel_plafond, email, num_encomendas_colocadas, valor_encomendas) 
    values (4, 2, 1,'Beatriz', 12000,123321123, 'A', 'bea@outmail.com', num_encomendas_colocadas_param,10);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckClienteValorDeEncomendas(valor_encomendas_param Cliente.valor_encomendas%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Cliente (id_utilizador_cliente_fk, id_morada_particular_fk, id_morada_entrega_fk, nome, plafond, num_fiscal, nivel_plafond, email, num_encomendas_colocadas, valor_encomendas) 
    values (4, 2, 1,'Beatriz', 12000,123321123, 'A', 'bea@outmail.com', 2,valor_encomendas_param);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckIncidenteValorIncidente(valor_incidente_param Incidente.valor_incidente%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Incidente (id_incidente_pk,id_utilizador_cliente_fk,data_incidente,data_sanado,valor_incidente) 
    values (default,1,DATE '2022-01-01', DATE '2022-01-05', valor_incidente_param);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckEncomendaStatus(status_param Encomenda.status%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Encomenda (id_distribuicao_fk, id_morada_entrega_fk, data_entrega, data_registo, status, valor) values (2, 1, null,DATE '2022-01-01',status_param,2000);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckFatorProducaoFormulacao(formulacao_param FatorProducao.formulacao%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into FatorProducao (id_fator_producao_pk, nome_comercial, formulacao, classificacao, fornecedor) values (DEFAULT, 'nome_comercial_2', formulacao_param, 'ADUBO', 'Maria');
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckFatorProducaoClassificacao(classificacao_param FatorProducao.classificacao%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into FatorProducao (id_fator_producao_pk, nome_comercial, formulacao, classificacao, fornecedor) values (DEFAULT, 'nome_comercial_2', classificacao_param, 'ADUBO', 'Maria');
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;


create or replace PROCEDURE prcTestCheckCulturaTipoDeCultura(tipo_cultura_param Cultura.tipo_cultura%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Cultura (id_cultura_pk, tipo_cultura, especie) values (DEFAULT, tipo_cultura_param,'Batatas');
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckRegaTipoRega(tipo_rega_param Rega.tipo_rega%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Rega (id_rega_pk, id_parcela_fk, data_rega, tipo_rega) values (DEFAULT,1, DATE '2022-05-17',tipo_rega_param);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckPlantacaoQuantidadeColhida(quantidade_colhida_param Plantacao.quantidade_colhida%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Plantacao (id_plantacao_pk, id_parcela_fk, id_cultura_fk, data_colheita, quantidade_colhida) values (DEFAULT,1,2,DATE '2022-09-25',quantidade_colhida_param);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckTubagemTipoTubagem(tipo_tubagem_param Tubagem.tipo_tubagem%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Tubagem  (id_tubagem_pk, id_caderno_campo_fk, tipo_tubagem) values (DEFAULT, 2, tipo_tubagem_param);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckEdificioTipoEdificio(tipo_edificio_param Edificio.tipo_edificio%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Edificio (id_edificio_pk, id_exploracao_fk, tipo_edificio) values (DEFAULT, 1,tipo_edificio_param);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;


create or replace PROCEDURE prcTestCheckFertilizacaoQuantidade(quantidade_param Fertilizacao.quantidade%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Fertilizacao (id_plantacao_fk, id_fator_producao_fk, data_aplicacao, quantidade) values (3,4,DATE '2022-05-30',quantidade_param);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;

create or replace PROCEDURE prcTestCheckMoradaCodigoPostal(codigo_postal_param Morada.codigo_postal%TYPE) AS
    
BEGIN
    SAVEPOINT BeforeCall;
    insert into Morada (endereco, codigo_postal) values ('Rua da madeira',codigo_postal_param);
    DBMS_OUTPUT.PUT_LINE('Aprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Reprovado');
    ROLLBACK TO SAVEPOINT BEFORECALL;
end;