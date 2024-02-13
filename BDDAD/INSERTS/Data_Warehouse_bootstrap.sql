DROP TABLE FactProducao CASCADE CONSTRAINTS;
DROP TABLE FactVendas CASCADE CONSTRAINTS;
DROP TABLE DimTempo CASCADE CONSTRAINTS;
DROP TABLE DimSetor CASCADE CONSTRAINTS;
DROP TABLE DimProduto CASCADE CONSTRAINTS;
DROP TABLE DimCliente CASCADE CONSTRAINTS;
DROP TABLE DimAno CASCADE CONSTRAINTS;
DROP TABLE DimMes CASCADE CONSTRAINTS;
DROP TABLE DimTipoCultura CASCADE CONSTRAINTS;
DROP TABLE DimCultura CASCADE CONSTRAINTS;
DROP TABLE DimLocalRecolha CASCADE CONSTRAINTS;
DROP TABLE DimTipoHub CASCADE CONSTRAINTS;
DROP TABLE DimHub CASCADE CONSTRAINTS;

CREATE TABLE FactProducao 
(
id_fact_producao_pk number(10) GENERATED AS IDENTITY,
id_dim_tempo_fk number(10) NOT NULL, 
id_dim_setor_fk number(10) NOT NULL, 
id_dim_produto_fk number(10) NOT NULL, 
quantidade double precision NOT NULL, 
PRIMARY KEY (id_fact_producao_pk),
CONSTRAINT ck_quantidade_fact_producao CHECK (quantidade > 0)
);

CREATE TABLE FactVendas 
(
id_fact_vendas_pk number(10) GENERATED AS IDENTITY, 
id_dim_produto_fk number(10) NOT NULL, 
id_dim_setor_fk number(10) NOT NULL, 
id_dim_tempo_fk number(10) NOT NULL, 
id_dim_cliente_fk number(10) NOT NULL,
id_dim_local_recolha_fk number(10) NOT NULL, 
valor double precision NOT NULL, 
PRIMARY KEY (id_fact_vendas_pk),
CONSTRAINT ck_valor_fact_vendas CHECK (valor > 0)

);

CREATE TABLE DimTempo 
(
id_dim_tempo_pk number(10) GENERATED AS IDENTITY, 
id_dim_ano_fk number(10) NOT NULL, 
id_dim_mes_fk number(10) NOT NULL, 
PRIMARY KEY (id_dim_tempo_pk)
);

CREATE TABLE DimSetor 
(
id_dim_setor_pk number(10) GENERATED AS IDENTITY, 
PRIMARY KEY (id_dim_setor_pk)
);

CREATE TABLE DimProduto 
(
id_dim_produto_pk number(10) GENERATED AS IDENTITY, 
id_dim_tipo_cultura_fk number(10) NOT NULL, 
id_dim_cultura_fk number(10) NOT NULL, 
PRIMARY KEY (id_dim_produto_pk)
);

CREATE TABLE DimCliente 
(
id_dim_cliente_pk number(10) GENERATED AS IDENTITY, 
PRIMARY KEY (id_dim_cliente_pk)
);

CREATE TABLE DimAno 
(
id_dim_ano_pk number(10), 
PRIMARY KEY (id_dim_ano_pk)
);

CREATE TABLE DimMes 
(
id_dim_mes_pk number(10), 
PRIMARY KEY (id_dim_mes_pk),
CONSTRAINT ck_dim_mes CHECK (id_dim_mes_pk >0 AND
                              id_dim_mes_pk < 13)
);

CREATE TABLE DimTipoCultura 
(
id_dim_tipo_cultura_pk number(10) GENERATED AS IDENTITY, 
PRIMARY KEY (id_dim_tipo_cultura_pk)
);

CREATE TABLE DimCultura 
(
id_dim_cultura_pk number(10) GENERATED AS IDENTITY, 
PRIMARY KEY (id_dim_cultura_pk)
);

CREATE TABLE DimLocalRecolha 
(
id_dim_local_recolha_pk number(10) GENERATED AS IDENTITY, 
id_dim_tipo_hub_fk varchar2(255) NOT NULL, 
id_dim_hub_fk number(10) NOT NULL, 
PRIMARY KEY (id_dim_local_recolha_pk)
);

CREATE TABLE DimTipoHub
(
id_dim_tipo_hub_pk varchar2(255),
CONSTRAINT ck_id_dim_tipo_hub_pk CHECK (UPPER(id_dim_tipo_hub_pk) LIKE ('E')),
PRIMARY KEY (id_dim_tipo_hub_pk)
);

CREATE TABLE DimHub
(
id_dim_hub_pk number(10) GENERATED AS IDENTITY, 
PRIMARY KEY (id_dim_hub_pk)
);

ALTER TABLE DimTempo 
	ADD CONSTRAINT fk_DimTempo_id_dim_ano_fk FOREIGN KEY (id_dim_ano_fk) REFERENCES DimAno (id_dim_ano_pk);
ALTER TABLE DimTempo 
	ADD CONSTRAINT fk_DimTempo_id_dim_mes_fk FOREIGN KEY (id_dim_mes_fk) REFERENCES DimMes (id_dim_mes_pk);
ALTER TABLE DimProduto 
	ADD CONSTRAINT fk_DimProduto_id_dim_tipo_cultura_fk FOREIGN KEY (id_dim_tipo_cultura_fk) REFERENCES DimTipoCultura (id_dim_tipo_cultura_pk);
ALTER TABLE DimProduto 
	ADD CONSTRAINT fk_DimProduto_id_dim_cultura_fk FOREIGN KEY (id_dim_cultura_fk) REFERENCES DimCultura (id_dim_cultura_pk);
ALTER TABLE FactProducao 
	ADD CONSTRAINT fk_FactProducao_id_dim_setor_fk FOREIGN KEY (id_dim_setor_fk) REFERENCES DimSetor (id_dim_setor_pk);
ALTER TABLE FactProducao 
	ADD CONSTRAINT fk_FactProducao_id_dim_produto_fk FOREIGN KEY (id_dim_produto_fk) REFERENCES DimProduto (id_dim_produto_pk);
ALTER TABLE FactProducao 
	ADD CONSTRAINT fk_FactProducao_id_dim_tempo_fk FOREIGN KEY (id_dim_tempo_fk) REFERENCES DimTempo (id_dim_tempo_pk);
ALTER TABLE FactVendas
	ADD CONSTRAINT fk_FactVendas_id_dim_setor_fk FOREIGN KEY (id_dim_setor_fk) REFERENCES DimSetor (id_dim_setor_pk);
ALTER TABLE FactVendas 
	ADD CONSTRAINT fk_FactVendas_id_dim_cliente_fk FOREIGN KEY (id_dim_cliente_fk) REFERENCES DimCliente (id_dim_cliente_pk);
ALTER TABLE FactVendas 
	ADD CONSTRAINT fk_FactVendas_id_dim_tempo_fk FOREIGN KEY (id_dim_tempo_fk) REFERENCES DimTempo (id_dim_tempo_pk);
ALTER TABLE FactVendas 
	ADD CONSTRAINT fk_FactVendas_id_dim_produto_fk FOREIGN KEY (id_dim_produto_fk) REFERENCES DimProduto (id_dim_produto_pk);
ALTER TABLE FactVendas 
	ADD CONSTRAINT fk_FactVendas_id_dim_local_recolha_fk FOREIGN KEY (id_dim_local_recolha_fk) REFERENCES DimLocalRecolha (id_dim_local_recolha_pk);
ALTER TABLE DimLocalRecolha 
	ADD CONSTRAINT fk_DimLocalRecolha_id_dim_hub_fk FOREIGN KEY (id_dim_hub_fk) REFERENCES DimHub (id_dim_hub_pk);
ALTER TABLE DimLocalRecolha 
	ADD CONSTRAINT fk_DimLocalRecolha_id_dim_tipo_hub_fk FOREIGN KEY (id_dim_tipo_hub_fk) REFERENCES DimTipoHub (id_dim_tipo_hub_pk);


insert into DimMes(id_dim_mes_pk) values(1);
insert into DimMes(id_dim_mes_pk) values(2);
insert into DimMes(id_dim_mes_pk) values(3);
insert into DimAno(id_dim_ano_pk) values(2020);
insert into DimAno(id_dim_ano_pk) values(2021);
insert into DimAno(id_dim_ano_pk) values(2022);
insert into DimTempo(id_dim_tempo_pk, id_dim_ano_fk, id_dim_mes_fk) 
values (DEFAULT, 2020, 1);
insert into DimTempo(id_dim_tempo_pk, id_dim_ano_fk, id_dim_mes_fk) 
values (DEFAULT, 2020, 2);
insert into DimTempo(id_dim_tempo_pk, id_dim_ano_fk, id_dim_mes_fk) 
values (DEFAULT, 2020, 3);
insert into DimTempo(id_dim_tempo_pk, id_dim_ano_fk, id_dim_mes_fk) 
values (DEFAULT, 2021, 1);
insert into DimTempo(id_dim_tempo_pk, id_dim_ano_fk, id_dim_mes_fk) 
values (DEFAULT, 2021, 2);
insert into DimTempo(id_dim_tempo_pk, id_dim_ano_fk, id_dim_mes_fk) 
values (DEFAULT, 2021, 3);
insert into DimTempo(id_dim_tempo_pk, id_dim_ano_fk, id_dim_mes_fk) 
values (DEFAULT, 2022, 1);
insert into DimTempo(id_dim_tempo_pk, id_dim_ano_fk, id_dim_mes_fk ) 
values (DEFAULT, 2022, 2);
insert into DimTempo(id_dim_tempo_pk, id_dim_ano_fk, id_dim_mes_fk) 
values (DEFAULT, 2022, 3);

insert into DimTipoCultura(id_dim_tipo_cultura_pk) values(DEFAULT); 
insert into DimTipoCultura(id_dim_tipo_cultura_pk) values(DEFAULT); 
insert into DimTipoCultura(id_dim_tipo_cultura_pk) values(DEFAULT); 
insert into DimCultura(id_dim_cultura_pk) values(DEFAULT);
insert into DimCultura(id_dim_cultura_pk) values(DEFAULT);
insert into DimCultura(id_dim_cultura_pk) values(DEFAULT);
insert into DimProduto(id_dim_produto_pk, id_dim_tipo_cultura_fk, id_dim_cultura_fk) 
values (DEFAULT,1,1);
insert into DimProduto(id_dim_produto_pk, id_dim_tipo_cultura_fk, id_dim_cultura_fk) 
values (DEFAULT,1,2);
insert into DimProduto(id_dim_produto_pk, id_dim_tipo_cultura_fk, id_dim_cultura_fk) 
values (DEFAULT,1,3);
insert into DimProduto(id_dim_produto_pk, id_dim_tipo_cultura_fk, id_dim_cultura_fk) 
values (DEFAULT,2,1);
insert into DimProduto(id_dim_produto_pk, id_dim_tipo_cultura_fk, id_dim_cultura_fk) 
values (DEFAULT,2,2);
insert into DimProduto(id_dim_produto_pk, id_dim_tipo_cultura_fk, id_dim_cultura_fk) 
values (DEFAULT,2,3);
insert into DimProduto(id_dim_produto_pk, id_dim_tipo_cultura_fk, id_dim_cultura_fk) 
values (DEFAULT,3,1);
insert into DimProduto(id_dim_produto_pk, id_dim_tipo_cultura_fk, id_dim_cultura_fk) 
values (DEFAULT,3,2);
insert into DimProduto(id_dim_produto_pk, id_dim_tipo_cultura_fk, id_dim_cultura_fk) 
values (DEFAULT,3,3);

insert into DimCliente(id_dim_cliente_pk) values(DEFAULT);
insert into DimCliente(id_dim_cliente_pk) values(DEFAULT);
insert into DimCliente(id_dim_cliente_pk) values(DEFAULT);

insert into DimSetor(id_dim_setor_pk) values(DEFAULT);
insert into DimSetor(id_dim_setor_pk) values(DEFAULT);
insert into DimSetor(id_dim_setor_pk) values(DEFAULT);

insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,1,1,1,30);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,2,2,2,35);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,3,3,3,33);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,4,1,4,27);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,5,2,5,10);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,6,3,6,13);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,7,1,7,17);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,8,2,8,45);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,9,3,9,32);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,1,1,1,21);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,2,2,2,13);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,3,3,3,17);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,4,1,4,67);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,5,2,5,21);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,6,3,6,45);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,7,1,7,9);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,8,2,8,42);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,9,3,9,67);
insert into FactProducao(id_fact_producao_pk, id_dim_tempo_fk, id_dim_setor_fk, id_dim_produto_fk, quantidade)
values(DEFAULT,4,1,7,31);

insert into DimTipoHub(id_dim_tipo_hub_pk) values('E'); 
insert into DimHub(id_dim_hub_pk) values(DEFAULT);
insert into DimHub(id_dim_hub_pk) values(DEFAULT);
insert into DimHub(id_dim_hub_pk) values(DEFAULT);

insert into DimLocalRecolha(id_dim_local_recolha_pk,id_dim_tipo_hub_fk,id_dim_hub_fk) 
values (DEFAULT,'E',1);
insert into DimLocalRecolha(id_dim_local_recolha_pk,id_dim_tipo_hub_fk,id_dim_hub_fk) 
values (DEFAULT,'E',2);
insert into DimLocalRecolha(id_dim_local_recolha_pk,id_dim_tipo_hub_fk,id_dim_hub_fk) 
values (DEFAULT,'E',3);


insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,1,1,1,1,1,530);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,2,2,2,1,2,630);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,3,3,3,1,3,710);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,4,1,4,1,1,140);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,5,1,5,1,2,253);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,6,1,6,2,3,356);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,7,1,7,3,1,366);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,8,1,8,1,2,171);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,9,2,9,1,3,123);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,2,3,1,1,1,645);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,3,1,2,1,2,566);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,4,1,3,1,3,767);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,6,1,4,2,1,789);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,7,1,5,3,2,581);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,3,1,6,1,3,445);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,1,2,7,1,1,343);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,9,3,8,1,2,269);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,6,1,9,1,3,179);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,7,1,3,1,1,317);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,4,1,5,2,2,193);
insert into FactVendas(id_fact_vendas_pk, id_dim_produto_fk, id_dim_setor_fk, id_dim_tempo_fk, id_dim_cliente_fk, id_dim_local_recolha_fk, valor) 
values(DEFAULT,2,1,8,3,3,214);





