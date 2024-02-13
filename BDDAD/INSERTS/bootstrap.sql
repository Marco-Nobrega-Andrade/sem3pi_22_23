DROP TABLE Filtro CASCADE CONSTRAINTS;
DROP TABLE PlanoRega CASCADE CONSTRAINTS;
DROP TABLE CadernoCampo CASCADE CONSTRAINTS;
DROP TABLE Elemento CASCADE CONSTRAINTS;
DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TABLE GestorDistribuicao CASCADE CONSTRAINTS;
DROP TABLE Condutor CASCADE CONSTRAINTS;
DROP TABLE GestorAgricola CASCADE CONSTRAINTS;
DROP TABLE Utilizador CASCADE CONSTRAINTS;
DROP TABLE Distribuicao CASCADE CONSTRAINTS;
DROP TABLE FatorProducao CASCADE CONSTRAINTS;
DROP TABLE Cultura CASCADE CONSTRAINTS;
DROP TABLE Plantacao CASCADE CONSTRAINTS;
DROP TABLE Parcela CASCADE CONSTRAINTS;
DROP TABLE Rega CASCADE CONSTRAINTS;
DROP TABLE Tubagem CASCADE CONSTRAINTS;
DROP TABLE Sensor CASCADE CONSTRAINTS;
DROP TABLE EstacaoMeteorologica CASCADE CONSTRAINTS;
DROP TABLE Edificio CASCADE CONSTRAINTS;
DROP TABLE Fertilizacao CASCADE CONSTRAINTS;
DROP TABLE Exploracao CASCADE CONSTRAINTS;
DROP TABLE Encomenda CASCADE CONSTRAINTS;
DROP TABLE Morada CASCADE CONSTRAINTS;
DROP TABLE Incidente CASCADE CONSTRAINTS;
DROP TABLE InputSensor CASCADE CONSTRAINTS;
DROP TABLE Erros CASCADE CONSTRAINTS;
DROP TABLE LeituraSensor CASCADE CONSTRAINTS;
DROP TABLE AuditLog CASCADE CONSTRAINTS;
DROP TABLE Hub CASCADE CONSTRAINTS;
DROP TABLE InputHub CASCADE CONSTRAINTS;
DROP TABLE RestricaoFatorProducao CASCADE CONSTRAINTS;

CREATE OR REPLACE TYPE array_t IS VARRAY(6) OF VARCHAR(255);

CREATE TABLE Filtro
(
    id_filtro_pk        number(10) GENERATED AS IDENTITY,
    id_caderno_campo_fk number(10) NOT NULL,
    tipo_filtro         varchar2(255),
    PRIMARY KEY (id_filtro_pk)
);

CREATE TABLE PlanoRega
(
    id_caderno_campo_fk number(10) NOT NULL,
    tempo_rega          number(10),
    periodicidade       number(10),
    PRIMARY KEY (id_caderno_campo_fk)
);

CREATE TABLE CadernoCampo
(
    id_caderno_campo_pk number(10) GENERATED AS IDENTITY,
    id_exploracao_fk    number(10) NOT NULL,
    ano_caderno_campo   number(10),
    PRIMARY KEY (id_caderno_campo_pk)
);

CREATE TABLE Elemento
(
    id_elemento_pk       number(10) GENERATED AS IDENTITY,
    id_fator_producao_fk number(10) NOT NULL,
    substancia           varchar2(255),
    quantidade           double precision,
    unidade              varchar2(255),
    categoria            varchar2(255),
    PRIMARY KEY (id_elemento_pk),
    CONSTRAINT ck_quantidade_elemento CHECK (quantidade > 0)
);

CREATE TABLE Cliente
(
    id_utilizador_cliente_fk number(10)       NOT NULL,
    id_morada_particular_fk  number(10)       NOT NULL,
    id_morada_entrega_fk     number(10),
    hub_loc_id_fk            varchar2(255),
    nome                     varchar2(255),
    plafond                  double precision NOT NULL,
    num_fiscal               number(9)        NOT NULL,
    nivel_plafond            varchar2(255)    NOT NULL,
    email                    varchar2(255)    NOT NULL,
    num_encomendas_colocadas number(10)       NOT NULL,
    valor_encomendas         number(10)       NOT NULL,
    PRIMARY KEY (id_utilizador_cliente_fk),
    CONSTRAINT ck_plafond CHECK (plafond >= 0),
    CONSTRAINT ck_nivel_plafond CHECK (UPPER(nivel_plafond) LIKE ('A') OR UPPER(nivel_plafond) LIKE ('B') OR
                                       UPPER(nivel_plafond) LIKE ('C')),
    CONSTRAINT ck_num_fiscal CHECK (num_fiscal > 99999999),
    CONSTRAINT ck_email CHECK ( REGEXP_LIKE(email, '^(\S+)\@(\S+)\.(\S+)$') ),
    CONSTRAINT ck_num_encomendas_colocadas CHECK (num_encomendas_colocadas >= 0),
    CONSTRAINT ck_valor_encomendas CHECK (valor_encomendas >= 0)

);


CREATE TABLE Incidente
(
    id_incidente_pk          number(10) GENERATED AS IDENTITY,
    id_utilizador_cliente_fk number(10) NOT NULL,
    data_incidente           date       NOT NULL,
    data_sanado              date,
    valor_incidente          number     NOT NULL,
    PRIMARY KEY (id_incidente_pk),
    CONSTRAINT ck_valor_incidente CHECK (valor_incidente > 0)
);

CREATE TABLE Morada
(
    id_morada_pk  number(10) GENERATED AS IDENTITY,
    endereco      varchar2(255),
    codigo_postal varchar(255),
    PRIMARY KEY (id_morada_pk),
    CONSTRAINT ck_codigo_postal CHECK ( REGEXP_LIKE(codigo_postal, '^[0-9]{4}(-)[0-9]{3}$') )
);
CREATE TABLE GestorDistribuicao
(
    id_utilizador_gestor_distribuicao_fk number(10) NOT NULL,
    PRIMARY KEY (id_utilizador_gestor_distribuicao_fk)
);

CREATE TABLE Condutor
(
    id_utilizador_condutor_fk number(10) NOT NULL,
    PRIMARY KEY (id_utilizador_condutor_fk)
);

CREATE TABLE GestorAgricola
(
    id_utilizador_gestor_agricola_fk number(10) NOT NULL,
    PRIMARY KEY (id_utilizador_gestor_agricola_fk)
);

CREATE TABLE Utilizador
(
    id_utilizador_pk number(10) GENERATED AS IDENTITY,
    PRIMARY KEY (id_utilizador_pk)
);

CREATE TABLE Distribuicao
(
    id_distribuicao_pk                   number(10) GENERATED AS IDENTITY,
    id_plantacao_fk                      number(10) NOT NULL,
    id_utilizador_cliente_fk             number(10) NOT NULL,
    id_utilizador_gestor_distribuicao_fk number(10) NOT NULL,
    tipo_distribuicao                    varchar2(255),
    PRIMARY KEY (id_distribuicao_pk)
);

CREATE TABLE Encomenda
(
    id_distribuicao_fk   number(10)       NOT NULL,
    id_morada_entrega_fk number(10),
    hub_loc_id_fk        varchar2(255),
    data_entrega         date,
    data_registo         date             NOT NULL,
    status               varchar(255)     NOT NULL,
    valor                double precision NOT NULL,
    PRIMARY KEY (id_distribuicao_fk),
    CONSTRAINT ck_status CHECK ( UPPER(status) LIKE ('REGISTADA') OR UPPER(status) LIKE ('ENTREGUE') OR
                                 UPPER(status) LIKE ('PAGA'))
);

CREATE TABLE FatorProducao
(
    id_fator_producao_pk number(10) GENERATED AS IDENTITY,
    nome_comercial       varchar2(255),
    formulacao           varchar2(255),
    classificacao        varchar2(255),
    fornecedor           varchar2(255),
    PRIMARY KEY (id_fator_producao_pk),
    CONSTRAINT ck_classificacao CHECK ( UPPER(classificacao) LIKE ('FERTILIZANTE') OR
                                        UPPER(classificacao) LIKE ('ADUBO') OR
                                        UPPER(classificacao) LIKE ('CORRETIVO') OR
                                        UPPER(classificacao) LIKE ('PRODUTO FITOFARMACO')),
    CONSTRAINT ck_formulacao CHECK ( UPPER(formulacao) LIKE ('LIQUIDO') OR UPPER(formulacao) LIKE ('GRANULADO') OR
                                     UPPER(formulacao) LIKE ('PO'))
);

CREATE TABLE Cultura
(
    id_cultura_pk number(10) GENERATED AS IDENTITY,
    tipo_cultura  varchar2(255),
    especie       varchar2(255),
    PRIMARY KEY (id_cultura_pk),
    CONSTRAINT ck_tipo_cultura CHECK ( UPPER(tipo_cultura) LIKE ('PERMANENTE') OR
                                       UPPER(tipo_cultura) LIKE ('TEMPORARIO'))

);

CREATE TABLE Plantacao
(
    id_plantacao_pk    number(10) GENERATED AS IDENTITY,
    id_parcela_fk      number(10) NOT NULL,
    id_cultura_fk      number(10) NOT NULL,
    data_colheita      date,
    quantidade_colhida double precision,
    PRIMARY KEY (id_plantacao_pk),
    CONSTRAINT ck_quantidade_colhida CHECK (quantidade_colhida > 0)
);

CREATE TABLE Parcela
(
    id_parcela_pk       number(10) GENERATED AS IDENTITY,
    id_caderno_campo_fk number(10) NOT NULL,
    designacao          varchar2(255),
    area                double precision,
    PRIMARY KEY (id_parcela_pk),
    CONSTRAINT ck_area CHECK (area > 0)
);

CREATE TABLE Rega
(
    id_rega_pk    number(10) GENERATED AS IDENTITY,
    id_parcela_fk number(10) NOT NULL,
    data_rega     date,
    tipo_rega     varchar2(255),
    PRIMARY KEY (id_rega_pk),
    CONSTRAINT ck_tipo_rega CHECK ( UPPER(tipo_rega) LIKE ('GRAVIDADE') OR UPPER(tipo_rega) LIKE ('BOMBEAMENTO'))
);

CREATE TABLE Tubagem
(
    id_tubagem_pk       number(10) GENERATED AS IDENTITY,
    id_caderno_campo_fk number(10) NOT NULL,
    tipo_tubagem        varchar2(255),
    PRIMARY KEY (id_tubagem_pk),
    CONSTRAINT ck_tipo_tubagem CHECK ( UPPER(tipo_tubagem) LIKE ('PRIMARIO') OR UPPER(tipo_tubagem) LIKE ('SECUNDARIO'))
);

CREATE TABLE Sensor
(
    id_sensor_pk                number(10) GENERATED AS IDENTITY,
    id_estacao_meteorologica_fk number(10)  NOT NULL,
    valor_referencia            number(3)   NOT NULL,
    tipo_sensor                 varchar2(2) NOT NULL,
    PRIMARY KEY (id_sensor_pk),
    CONSTRAINT ck_tipo_sensor CHECK (UPPER(tipo_sensor) IN ('HS', 'PL', 'TS', 'VV', 'TA', 'HA', 'PA')
        )
);


CREATE TABLE InputSensor
(
    input_string varchar2(25) NOT NULL,
    PRIMARY KEY (input_string)
);
CREATE TABLE Erros
(
    id_erro_pk      number(10) GENERATED AS IDENTITY,
    input_string_fk varchar2(25) NOT NULL,
    id_sensor       number(10),
    PRIMARY KEY (id_erro_pk)
);
CREATE TABLE LeituraSensor
(
    id_leitura_sensor_pk number(10) GENERATED AS IDENTITY,
    id_sensor_fk         number(10)   NOT NULL,
    valor_lido           number(3)    NOT NULL,
    instante_leitura     varchar2(16) NOT NULL,
    PRIMARY KEY (id_leitura_sensor_pk),
    CONSTRAINT ck_valor_lido CHECK (valor_lido >= 0 AND valor_lido <= 100)
);


CREATE TABLE EstacaoMeteorologica
(
    id_estacao_meteorologica_pk number(10) GENERATED AS IDENTITY,
    id_caderno_campo_fk         number(10) NOT NULL,
    PRIMARY KEY (id_estacao_meteorologica_pk)
);

CREATE TABLE Edificio
(
    id_edificio_pk   number(10) GENERATED AS IDENTITY,
    id_exploracao_fk number(10) NOT NULL,
    tipo_edificio    varchar2(255),
    PRIMARY KEY (id_edificio_pk),
    CONSTRAINT ck_tipo_edificio CHECK ( UPPER(tipo_edificio) LIKE ('ESTABULO PARA ANIMAIS') OR
                                        UPPER(tipo_edificio) LIKE ('GARAGEM PARA MAQUINAS') OR
                                        UPPER(tipo_edificio) LIKE ('GARAGEM PARA ALFAIAS') OR
                                        UPPER(tipo_edificio) LIKE ('ARMAZEM PARA COLHEITAS') OR
                                        UPPER(tipo_edificio) LIKE ('ARMAZEM PARA FATORES DE PRODUCAO') OR
                                        UPPER(tipo_edificio) LIKE ('ARMAZEM PARA RACOES PARA ANIMAIS') OR
                                        UPPER(tipo_edificio) LIKE ('SISTEMA DE REGA'))
);

CREATE TABLE Fertilizacao
(   
    id_fertilizacao_pk   number(10) GENERATED AS IDENTITY,
    id_plantacao_fk      number(10) NOT NULL,
    id_fator_producao_fk number(10) NOT NULL,
    data_aplicacao       date,
    quantidade           double precision,
    PRIMARY KEY (id_fertilizacao_pk),
    CONSTRAINT ck_quantidade_fertilizacao CHECK (quantidade > 0)
);

CREATE TABLE Exploracao
(
    id_exploracao_pk number(10) GENERATED AS IDENTITY,
    PRIMARY KEY (id_exploracao_pk)
);

CREATE TABLE AuditLog
(
    id_audit_log_pk     number(10) GENERATED AS IDENTITY,
    id_parcela_fk       number(10) NOT NULL,
    data_audit_log      timestamp NOT NULL,
    operacao            varchar2(255) NOT NULL,
    tabela              varchar2(255) NOT NULL,
    utilizador          varchar2(255) NOT NULL,
    PRIMARY KEY (id_audit_log_pk),
    CONSTRAINT ck_operacao CHECK (UPPER(operacao) LIKE ('UPDATE') OR UPPER(operacao) LIKE('INSERT') OR UPPER(operacao) LIKE('DELETE'))
);

CREATE TABLE Hub(
    loc_id_pk              varchar2(255),
    latitude            double precision NOT NULL,
    longitude           double precision NOT NULL,
    PRIMARY KEY (loc_id_pk),
    CONSTRAINT ck_latitude CHECK ( latitude >= -90 AND latitude <= 90 ),
    CONSTRAINT ck_longitude CHECK ( longitude >= -180 AND longitude <= 180 )
);

CREATE TABLE InputHub(
    input_string        varchar2(25),
    CONSTRAINT ck_input_string CHECK ( REGEXP_LIKE(input_string, '^CT[0-9]{1,2};-?[0-9]{1,2}.[0-9]{4};-?[0-9]{1,3}.[0-9]{4};[CPE][0-9]{1,2}$') )
);

CREATE TABLE RestricaoFatorProducao
(
    id_restricao_fator_producao_pk  number(10) GENERATED AS IDENTITY,
    id_parcela_fk                   number(10) NOT NULL,
    id_fator_producao_fk            number(10) NOT NULL,
    data_inicio                     date NOT NULL,
    data_fim                     date NOT NULL,
    PRIMARY KEY (id_restricao_fator_producao_pk),
    CONSTRAINT ck_dateRestricaoFatorProducao CHECK ( data_fim > data_inicio )
);

ALTER TABLE RestricaoFatorProducao
    ADD CONSTRAINT fk_RestricaoFatorProducao_id_parcela_fk FOREIGN KEY (id_parcela_fk) REFERENCES Parcela (id_parcela_pk);
ALTER TABLE RestricaoFatorProducao
    ADD CONSTRAINT fk_RestricaoFatorProducao_id_fator_producao_fk FOREIGN KEY (id_fator_producao_fk) REFERENCES FatorProducao (id_fator_producao_pk);
ALTER TABLE AuditLog
    ADD CONSTRAINT fk_AuditLog_id_parcela_fk FOREIGN KEY (id_parcela_fk) REFERENCES Parcela (id_parcela_pk);
ALTER TABLE Filtro
    ADD CONSTRAINT fk_Filtro_id_caderno_campo_fk FOREIGN KEY (id_caderno_campo_fk) REFERENCES PlanoRega (id_caderno_campo_fk);
ALTER TABLE PlanoRega
    ADD CONSTRAINT fk_PlanoRega_id_caderno_campo_fk FOREIGN KEY (id_caderno_campo_fk) REFERENCES CadernoCampo (id_caderno_campo_pk);
ALTER TABLE Parcela
    ADD CONSTRAINT fk_Parcela_id_caderno_campo_fk FOREIGN KEY (id_caderno_campo_fk) REFERENCES CadernoCampo (id_caderno_campo_pk);
ALTER TABLE Rega
    ADD CONSTRAINT fk_Rega_id_parcela_fk FOREIGN KEY (id_parcela_fk) REFERENCES Parcela (id_parcela_pk);
ALTER TABLE Tubagem
    ADD CONSTRAINT fk_Tubagem_id_caderno_campo_fk FOREIGN KEY (id_caderno_campo_fk) REFERENCES PlanoRega (id_caderno_campo_fk);
ALTER TABLE Sensor
    ADD CONSTRAINT fk_Sensor_id_estacao_meteorologica_fk FOREIGN KEY (id_estacao_meteorologica_fk) REFERENCES EstacaoMeteorologica (id_estacao_meteorologica_pk);
ALTER TABLE EstacaoMeteorologica
    ADD CONSTRAINT fk_EstacaoMeteorologica_id_caderno_campo_fk FOREIGN KEY (id_caderno_campo_fk) REFERENCES CadernoCampo (id_caderno_campo_pk);
ALTER TABLE Edificio
    ADD CONSTRAINT fk_Edificio_id_exploracao_fk FOREIGN KEY (id_exploracao_fk) REFERENCES Exploracao (id_exploracao_pk);
ALTER TABLE Plantacao
    ADD CONSTRAINT fk_Plantacao_id_parcela_fk FOREIGN KEY (id_parcela_fk) REFERENCES Parcela (id_parcela_pk);
ALTER TABLE Plantacao
    ADD CONSTRAINT fk_Plantacao_id_cultura_fk FOREIGN KEY (id_cultura_fk) REFERENCES Cultura (id_cultura_pk);
ALTER TABLE Elemento
    ADD CONSTRAINT fk_Elemento_id_fator_producao_fk FOREIGN KEY (id_fator_producao_fk) REFERENCES FatorProducao (id_fator_producao_pk);
ALTER TABLE Distribuicao
    ADD CONSTRAINT fk_Distribuicao_id_plantacao_fk FOREIGN KEY (id_plantacao_fk) REFERENCES Plantacao (id_plantacao_pk);
ALTER TABLE Fertilizacao
    ADD CONSTRAINT fk_Fertilizacao_id_plantacao_fk FOREIGN KEY (id_plantacao_fk) REFERENCES Plantacao (id_plantacao_pk);
ALTER TABLE Fertilizacao
    ADD CONSTRAINT fk_Fertilizacao_id_fator_producao_fk FOREIGN KEY (id_fator_producao_fk) REFERENCES FatorProducao (id_fator_producao_pk);
ALTER TABLE Cliente
    ADD CONSTRAINT fk_Cliente_id_utilizador_cliente_fk FOREIGN KEY (id_utilizador_cliente_fk) REFERENCES Utilizador (id_utilizador_pk);
ALTER TABLE CadernoCampo
    ADD CONSTRAINT fk_CadernoCampo_id_exploracao_fk FOREIGN KEY (id_exploracao_fk) REFERENCES Exploracao (id_exploracao_pk);
ALTER TABLE GestorAgricola
    ADD CONSTRAINT fk_GestorAgricola_id_utilizador_gestor_agricula_fk FOREIGN KEY (id_utilizador_gestor_agricola_fk) REFERENCES Utilizador (id_utilizador_pk);
ALTER TABLE Condutor
    ADD CONSTRAINT fk_Condutor_id_utilizador_condutor_fk FOREIGN KEY (id_utilizador_condutor_fk) REFERENCES Utilizador (id_utilizador_pk);
ALTER TABLE GestorDistribuicao
    ADD CONSTRAINT fk_GestorDistribuicao_id_utilizador_gestor_distribuicao_fk FOREIGN KEY (id_utilizador_gestor_distribuicao_fk) REFERENCES Utilizador (id_utilizador_pk);
ALTER TABLE Distribuicao
    ADD CONSTRAINT fk_Distribuicao_id_utilizador_cliente_fk FOREIGN KEY (id_utilizador_cliente_fk) REFERENCES Cliente (id_utilizador_cliente_fk);
ALTER TABLE Distribuicao
    ADD CONSTRAINT fk_Distribuicao_id_utilizador_gestor_distribuicao_fk FOREIGN KEY (id_utilizador_gestor_distribuicao_fk) REFERENCES GestorDistribuicao (id_utilizador_gestor_distribuicao_fk);
ALTER TABLE Encomenda
    ADD CONSTRAINT fk_Encomenda_id_distribuicao_fk FOREIGN KEY (id_distribuicao_fk) REFERENCES Distribuicao (id_distribuicao_pk);
ALTER TABLE Cliente
    ADD CONSTRAINT fk_Cliente_id_morada_particular_fk FOREIGN KEY (id_morada_particular_fk) REFERENCES Morada (id_morada_pk);
ALTER TABLE Cliente
    ADD CONSTRAINT fk_Cliente_id_morada_entrega_fk FOREIGN KEY (id_morada_entrega_fk) REFERENCES Morada (id_morada_pk);
ALTER TABLE Encomenda
    ADD CONSTRAINT fk_Encomenda_id_morada_entrega_fk FOREIGN KEY (id_morada_entrega_fk) REFERENCES Morada (id_morada_pk);
ALTER TABLE Incidente
    ADD CONSTRAINT fk_Incidente_id_id_Utilizador_Cliente_fk FOREIGN KEY (id_utilizador_cliente_fk) REFERENCES Cliente (id_utilizador_cliente_fk);
ALTER TABLE LeituraSensor
    ADD CONSTRAINT id_sensor_fk FOREIGN KEY (id_sensor_fk) REFERENCES Sensor (id_sensor_pk);
ALTER TABLE Erros
    ADD CONSTRAINT input_string_fk FOREIGN KEY (input_string_fk) REFERENCES InputSensor (input_string);
ALTER TABLE Encomenda
    ADD CONSTRAINT fk_Encomenda_hub_loc_id_fk FOREIGN KEY (hub_loc_id_fk) REFERENCES Hub (loc_id_pk);
ALTER TABLE Cliente
    ADD CONSTRAINT fk_Cliente_hub_loc_id_fk FOREIGN KEY (hub_loc_id_fk) REFERENCES Hub (loc_id_pk);



insert into Exploracao (id_exploracao_pk)
values (DEFAULT);

insert into Edificio (id_edificio_pk, id_exploracao_fk, tipo_edificio)
values (DEFAULT, 1, 'ESTABULO PARA ANIMAIS');
insert into Edificio (id_edificio_pk, id_exploracao_fk, tipo_edificio)
values (DEFAULT, 1, 'GARAGEM PARA MAQUINAS');
insert into Edificio (id_edificio_pk, id_exploracao_fk, tipo_edificio)
values (DEFAULT, 1, 'GARAGEM PARA ALFAIAS');
insert into Edificio (id_edificio_pk, id_exploracao_fk, tipo_edificio)
values (DEFAULT, 1, 'ARMAZEM PARA COLHEITAS');
insert into Edificio (id_edificio_pk, id_exploracao_fk, tipo_edificio)
values (DEFAULT, 1, 'ARMAZEM PARA FATORES DE PRODUCAO');
insert into Edificio (id_edificio_pk, id_exploracao_fk, tipo_edificio)
values (DEFAULT, 1, 'ARMAZEM PARA RACOES PARA ANIMAIS');
insert into Edificio (id_edificio_pk, id_exploracao_fk, tipo_edificio)
values (DEFAULT, 1, 'SISTEMA DE REGA');

insert into CadernoCampo (id_caderno_campo_pk, id_exploracao_fk, ano_caderno_campo)
values (DEFAULT, 1, 2022);
insert into CadernoCampo (id_caderno_campo_pk, id_exploracao_fk, ano_caderno_campo)
values (DEFAULT, 1, 2023);

insert into EstacaoMeteorologica (id_estacao_meteorologica_pk, id_caderno_campo_fk)
values (DEFAULT, 1);
insert into EstacaoMeteorologica (id_estacao_meteorologica_pk, id_caderno_campo_fk)
values (DEFAULT, 2);

commit;


insert into Sensor (id_sensor_pk, id_estacao_meteorologica_fk, tipo_sensor, valor_referencia)
values (DEFAULT, 1, 'TS', 20.0);
insert into Sensor (id_sensor_pk, id_estacao_meteorologica_fk, tipo_sensor, valor_referencia)
values (DEFAULT, 1, 'HS', 80.0);
insert into Sensor (id_sensor_pk, id_estacao_meteorologica_fk, tipo_sensor, valor_referencia)
values (DEFAULT, 1, 'PL', 8);
insert into Sensor (id_sensor_pk, id_estacao_meteorologica_fk, tipo_sensor, valor_referencia)
values (DEFAULT, 1, 'VV', 102);
insert into Sensor (id_sensor_pk, id_estacao_meteorologica_fk, tipo_sensor, valor_referencia)
values (DEFAULT, 2, 'TA', 15.0);
insert into Sensor (id_sensor_pk, id_estacao_meteorologica_fk, tipo_sensor, valor_referencia)
values (DEFAULT, 2, 'HA', 22.0);
insert into Sensor (id_sensor_pk, id_estacao_meteorologica_fk, tipo_sensor, valor_referencia)
values (DEFAULT, 2, 'PA', 88.0);
insert into Sensor (id_sensor_pk, id_estacao_meteorologica_fk, tipo_sensor, valor_referencia)
values (DEFAULT, 2, 'HS', 5);
insert into Sensor (id_sensor_pk, id_estacao_meteorologica_fk, tipo_sensor, valor_referencia)
values (DEFAULT, 2, 'VV', 102);

insert into INPUTSENSOR (input_string) values ('00002TS018020020720201215');
insert into INPUTSENSOR (input_string) values ('00003TS018020020720201216');
insert into INPUTSENSOR (input_string) values ('00004TS018020020720201217');
insert into INPUTSENSOR (input_string) values ('00002XX018020020720201215'); -- 1 erro de tipo
insert into INPUTSENSOR (input_string) values ('00002XX018020020720201255'); -- 1 erro de tipo e 1 de data
insert into INPUTSENSOR (input_string) values ('00002TS999020020720201215'); -- 1 erro de valor lido
insert into INPUTSENSOR (input_string) values ('00002TS032999020720201215'); -- 1 erro de valor referencia
insert into INPUTSENSOR (input_string) values ('00002TS999888020720201215'); -- 1 erro de valor lido e valor referencia
insert into INPUTSENSOR (input_string) values ('00001'); -- 1 erro comprimento
insert into INPUTSENSOR (input_string) values ('00002XX988899020720201299'); -- 4 erros


insert into PlanoRega (id_caderno_campo_fk, tempo_rega, periodicidade)
values (1, 2, 4);
insert into PlanoRega (id_caderno_campo_fk, tempo_rega, periodicidade)
values (2, 3, 2);

insert into Filtro (id_filtro_pk, id_caderno_campo_fk, tipo_filtro)
values (DEFAULT, 1, 'TUBAGENS');
insert into Filtro (id_filtro_pk, id_caderno_campo_fk, tipo_filtro)
values (DEFAULT, 1, 'ASPERSORES');
insert into Filtro (id_filtro_pk, id_caderno_campo_fk, tipo_filtro)
values (DEFAULT, 1, 'GOTEJADORES');
insert into Filtro (id_filtro_pk, id_caderno_campo_fk, tipo_filtro)
values (DEFAULT, 1, 'PULVERIZADORES');
insert into Filtro (id_filtro_pk, id_caderno_campo_fk, tipo_filtro)
values (DEFAULT, 2, 'TUBAGENS');
insert into Filtro (id_filtro_pk, id_caderno_campo_fk, tipo_filtro)
values (DEFAULT, 2, 'ASPERSORES');
insert into Filtro (id_filtro_pk, id_caderno_campo_fk, tipo_filtro)
values (DEFAULT, 2, 'GOTEJADORES');
insert into Filtro (id_filtro_pk, id_caderno_campo_fk, tipo_filtro)
values (DEFAULT, 2, 'PULVERIZADORES');

insert into Tubagem (id_tubagem_pk, id_caderno_campo_fk, tipo_tubagem)
values (DEFAULT, 1, 'PRIMARIO');
insert into Tubagem (id_tubagem_pk, id_caderno_campo_fk, tipo_tubagem)
values (DEFAULT, 1, 'SECUNDARIO');
insert into Tubagem (id_tubagem_pk, id_caderno_campo_fk, tipo_tubagem)
values (DEFAULT, 2, 'PRIMARIO');
insert into Tubagem (id_tubagem_pk, id_caderno_campo_fk, tipo_tubagem)
values (DEFAULT, 2, 'SECUNDARIO');

commit;

insert into Parcela (id_parcela_pk, id_caderno_campo_fk, designacao, area)
values (DEFAULT, 1, 'Quinta Maria', 50);
insert into Parcela (id_parcela_pk, id_caderno_campo_fk, designacao, area)
values (DEFAULT, 2, 'Quinta Joana', 300);
insert into Parcela (id_parcela_pk, id_caderno_campo_fk, designacao, area)
values (DEFAULT, 1, 'Quinta Jose', 150);
insert into Parcela (id_parcela_pk, id_caderno_campo_fk, designacao, area)
values (DEFAULT, 2, 'Quinta Fernando', 77);

insert into Rega (id_rega_pk, id_parcela_fk, data_rega, tipo_rega)
values (DEFAULT, 1, DATE '2022-05-17', 'GRAVIDADE');
insert into Rega (id_rega_pk, id_parcela_fk, data_rega, tipo_rega)
values (DEFAULT, 2, DATE '2022-05-30', 'BOMBEAMENTO');
insert into Rega (id_rega_pk, id_parcela_fk, data_rega, tipo_rega)
values (DEFAULT, 3, DATE '2023-05-03', 'GRAVIDADE');
insert into Rega (id_rega_pk, id_parcela_fk, data_rega, tipo_rega)
values (DEFAULT, 4, DATE '2023-05-11', 'BOMBEAMENTO');

insert into Cultura (id_cultura_pk, tipo_cultura, especie)
values (DEFAULT, 'TEMPORARIO', 'Batatas');
insert into Cultura (id_cultura_pk, tipo_cultura, especie)
values (DEFAULT, 'PERMANENTE', 'Laranjas');

insert into Plantacao (id_plantacao_pk, id_parcela_fk, id_cultura_fk, data_colheita, quantidade_colhida)
values (DEFAULT, 1, 1, DATE '2022-10-17', 7000);
insert into Plantacao (id_plantacao_pk, id_parcela_fk, id_cultura_fk, data_colheita, quantidade_colhida)
values (DEFAULT, 1, 2, DATE '2022-09-25', 6000);
insert into Plantacao (id_plantacao_pk, id_parcela_fk, id_cultura_fk, data_colheita, quantidade_colhida)
values (DEFAULT, 2, 1, DATE '2022-10-07', 5000);
insert into Plantacao (id_plantacao_pk, id_parcela_fk, id_cultura_fk, data_colheita, quantidade_colhida)
values (DEFAULT, 2, 2, DATE '2022-10-10', 4000);
insert into Plantacao (id_plantacao_pk, id_parcela_fk, id_cultura_fk, data_colheita, quantidade_colhida)
values (DEFAULT, 3, 1, DATE '2022-09-21', 3000);
insert into Plantacao (id_plantacao_pk, id_parcela_fk, id_cultura_fk, data_colheita, quantidade_colhida)
values (DEFAULT, 4, 2, DATE '2022-09-23', 2000);

commit;

insert into FatorProducao (id_fator_producao_pk, nome_comercial, formulacao, classificacao, fornecedor)
values (DEFAULT, 'nome_comercial_1', 'LIQUIDO', 'FERTILIZANTE', 'Maria');
insert into FatorProducao (id_fator_producao_pk, nome_comercial, formulacao, classificacao, fornecedor)
values (DEFAULT, 'nome_comercial_2', 'GRANULADO', 'ADUBO', 'Maria');
insert into FatorProducao (id_fator_producao_pk, nome_comercial, formulacao, classificacao, fornecedor)
values (DEFAULT, 'nome_comercial_3', 'PO', 'CORRETIVO', 'Maria');
insert into FatorProducao (id_fator_producao_pk, nome_comercial, formulacao, classificacao, fornecedor)
values (DEFAULT, 'nome_comercial_4', 'GRANULADO', 'PRODUTO FITOFARMACO', 'Maria');
insert into FatorProducao (id_fator_producao_pk, nome_comercial, formulacao, classificacao, fornecedor)
values (DEFAULT, 'nome_comercial_5', 'LIQUIDO', 'FERTILIZANTE', 'Jose');

insert into Elemento (id_elemento_pk, id_fator_producao_fk, substancia, quantidade, unidade, categoria)
values (DEFAULT, 1, 'amoniaco', 20, 'mg', 'sustancia organica');
insert into Elemento (id_elemento_pk, id_fator_producao_fk, substancia, quantidade, unidade, categoria)
values (DEFAULT, 2, 'amoniaco', 15, 'mg', 'sustancia organica');
insert into Elemento (id_elemento_pk, id_fator_producao_fk, substancia, quantidade, unidade, categoria)
values (DEFAULT, 3, 'amoniaco', 12, 'mg', 'sustancia organica');
insert into Elemento (id_elemento_pk, id_fator_producao_fk, substancia, quantidade, unidade, categoria)
values (DEFAULT, 4, 'amoniaco', 18, 'mg', 'sustancia organica');

insert into Fertilizacao (id_fertilizacao_pk,id_plantacao_fk, id_fator_producao_fk, data_aplicacao, quantidade)
values (DEFAULT,1, 1, DATE '2022-05-17', 2000);
insert into Fertilizacao (id_fertilizacao_pk,id_plantacao_fk, id_fator_producao_fk, data_aplicacao, quantidade)
values (DEFAULT,1, 2, DATE '2022-05-30', 5000);
insert into Fertilizacao (id_fertilizacao_pk,id_plantacao_fk, id_fator_producao_fk, data_aplicacao, quantidade)
values (DEFAULT,2, 3, DATE '2022-05-17', 7000);
insert into Fertilizacao (id_fertilizacao_pk,id_plantacao_fk, id_fator_producao_fk, data_aplicacao, quantidade)
values (DEFAULT,3, 4, DATE '2022-05-30', 6000);
insert into Fertilizacao (id_fertilizacao_pk,id_plantacao_fk, id_fator_producao_fk, data_aplicacao, quantidade)
values (DEFAULT,4, 5, DATE '2022-05-30', 3000);
insert into Fertilizacao (id_fertilizacao_pk,id_plantacao_fk, id_fator_producao_fk, data_aplicacao, quantidade)
values (DEFAULT,6, 3, DATE '2022-05-17', 3000);
-- Para a US211
INSERT INTO FERTILIZACAO(id_fertilizacao_pk,ID_PLANTACAO_FK, ID_FATOR_PRODUCAO_FK, DATA_APLICACAO, QUANTIDADE)
VALUES (DEFAULT,1,1,DATE '2023-05-31',2200);


insert into RestricaoFatorProducao (id_restricao_fator_producao_pk, id_parcela_fk, id_fator_producao_fk, data_inicio,data_fim)
values (DEFAULT, 1,1, DATE '2023-02-10', DATE '2023-02-20');
insert into RestricaoFatorProducao (id_restricao_fator_producao_pk, id_parcela_fk, id_fator_producao_fk, data_inicio,data_fim)
values (DEFAULT, 1,2, DATE '2023-03-20', DATE '2023-04-10');
-- Para US211
INSERT INTO RESTRICAOFATORPRODUCAO(ID_PARCELA_FK, ID_FATOR_PRODUCAO_FK, DATA_INICIO, DATA_FIM)
VALUES(1,2,DATE '2023-10-10',DATE '2023-10-20');

INSERT INTO AuditLog(id_audit_log_pk,id_parcela_fk,data_audit_log,operacao,tabela,utilizador) 
values (DEFAULT,1,TO_TIMESTAMP('2022-12-16 16:10:15'),'UPDATE','Fertilizacao','Maria');
INSERT INTO AuditLog(id_audit_log_pk,id_parcela_fk,data_audit_log,operacao,tabela,utilizador) 
values (DEFAULT,1,TO_TIMESTAMP('2022-12-16 16:30:30'),'UPDATE','Fertilizacao','Maria');
INSERT INTO AuditLog(id_audit_log_pk,id_parcela_fk,data_audit_log,operacao,tabela,utilizador) 
values (DEFAULT,2,TO_TIMESTAMP('2022-12-16 16:13:25'),'UPDATE','Fertilizacao','Maria');


insert into Utilizador (id_utilizador_pk)
values (DEFAULT);
insert into Utilizador (id_utilizador_pk)
values (DEFAULT);
insert into Utilizador (id_utilizador_pk)
values (DEFAULT);
insert into Utilizador (id_utilizador_pk)
values (DEFAULT);
insert into Utilizador (id_utilizador_pk)
values (DEFAULT);
insert into Utilizador (id_utilizador_pk)
values (DEFAULT);
insert into Utilizador (id_utilizador_pk)
values (DEFAULT);


commit;

insert into Morada (endereco, codigo_postal)
values ('Rua da madeira', '3730-090');
insert into Morada (endereco, codigo_postal)
values ('Rua do carvalho', '3730-096');

insert into Cliente (id_utilizador_cliente_fk, id_morada_particular_fk, id_morada_entrega_fk, nome, plafond, num_fiscal,
                     nivel_plafond, email, num_encomendas_colocadas, valor_encomendas)
values (1, 2, 1, 'Beatriz', 2000, 300876345, 'B', 'bea@outmail.com', 2, 0);
insert into Cliente (id_utilizador_cliente_fk, id_morada_particular_fk, id_morada_entrega_fk, nome, plafond, num_fiscal,
                     nivel_plafond, email, num_encomendas_colocadas, valor_encomendas)
values (2, 2, 1, 'Francisca', 4000, 322846345, 'A', 'frca@hotmail.com', 2, 0);
insert into Cliente (id_utilizador_cliente_fk, id_morada_particular_fk, id_morada_entrega_fk, nome, plafond, num_fiscal,
                     nivel_plafond, email, num_encomendas_colocadas, valor_encomendas)
values (3, 2, 1, 'Homem dos Incidentes', 4000, 992846235, 'A', 'incidenteman@hotmail.com', 2, 0);

insert into Incidente (id_incidente_pk, id_utilizador_cliente_fk, data_incidente, data_sanado, valor_incidente)
values (default, 1, DATE '2022-01-01', DATE '2022-01-05', 3000);
insert into Incidente (id_incidente_pk, id_utilizador_cliente_fk, data_incidente, data_sanado, valor_incidente)
values (default, 3, DATE '2022-07-07', DATE '2022-07-08', 3000);
insert into Incidente (id_incidente_pk, id_utilizador_cliente_fk, data_incidente, data_sanado, valor_incidente)
values (default, 3, DATE '2022-02-07', DATE '2022-03-01', 2000);
insert into Incidente (id_incidente_pk, id_utilizador_cliente_fk, data_incidente, data_sanado, valor_incidente)
values (default, 3, DATE '2018-07-07', DATE '2018-09-01', 3000);

insert into GestorDistribuicao (id_utilizador_gestor_distribuicao_fk)
values (3);
insert into GestorDistribuicao (id_utilizador_gestor_distribuicao_fk)
values (4);

insert into GestorAgricola (id_utilizador_gestor_agricola_fk)
values (5);

insert into Condutor (id_utilizador_condutor_fk)
values (6);

commit;

insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 1, 1, 3, 'Encomenda');
insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 2, 2, 4, 'Encomenda');
insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 2, 2, 4, 'Encomenda');
insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 2, 2, 4, 'Encomenda');
insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 1, 2, 4, 'Presencial');
insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 1, 2, 4, 'Presencial');
insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 2, 2, 4, 'Encomenda');
insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 2, 2, 4, 'Encomenda');
insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 2, 3, 4, 'Encomenda');
insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 2, 3, 4, 'Encomenda');
insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 2, 3, 4, 'Encomenda');
insert into Distribuicao (id_distribuicao_pk, id_plantacao_fk, id_utilizador_cliente_fk,
                          id_utilizador_gestor_distribuicao_fk, tipo_distribuicao)
values (DEFAULT, 2, 3, 4, 'Encomenda');



insert into Encomenda (id_distribuicao_fk, id_morada_entrega_fk, data_entrega, data_registo, status, valor)
values (1, 1, null, DATE '2022-01-01', 'REGISTADA', 2000);
insert into Encomenda (id_distribuicao_fk, id_morada_entrega_fk, data_entrega, data_registo, status, valor)
values (2, 1, DATE '2022-11-23', DATE '2022-01-01', 'ENTREGUE', 2000);
insert into Encomenda (id_distribuicao_fk, id_morada_entrega_fk, data_entrega, data_registo, status, valor)
values (3, 1, null, DATE '2022-01-01', 'PAGA', 2000);
insert into Encomenda (id_distribuicao_fk, id_morada_entrega_fk, data_entrega, data_registo, status, valor)
values (4, 1, DATE '2018-11-23', DATE '2018-01-01', 'ENTREGUE', 2000);
insert into Encomenda (id_distribuicao_fk, id_morada_entrega_fk, data_entrega, data_registo, status, valor)
values (7, 1, null, DATE '2022-01-01', 'PAGA', 1000);
insert into Encomenda (id_distribuicao_fk, id_morada_entrega_fk, data_entrega, data_registo, status, valor)
values (8, 1, null, DATE '2018-01-01', 'PAGA', 500);

insert into Encomenda (id_distribuicao_fk, id_morada_entrega_fk, data_entrega, data_registo, status, valor)
values (9, 1, DATE '2022-11-23', DATE '2022-11-22', 'PAGA', 2000);
insert into Encomenda (id_distribuicao_fk, id_morada_entrega_fk, data_entrega, data_registo, status, valor)
values (10, 1, null, DATE '2022-11-22', 'ENTREGUE', 2000);
insert into Encomenda (id_distribuicao_fk, id_morada_entrega_fk, data_entrega, data_registo, status, valor)
values (11, 1, null, DATE '2018-01-01', 'REGISTADA', 2000);
insert into Encomenda (id_distribuicao_fk, id_morada_entrega_fk, data_entrega, data_registo, status, valor)
values (12, 1, null, DATE '2022-09-03', 'REGISTADA', 2000);

insert into Hub(loc_id_pk, latitude, longitude)
VALUES ('CT33',3.3,3.3);
insert into Hub(loc_id_pk, latitude, longitude)
VALUES ('CT99',9.9,9.9);

commit;

DECLARE

    contador NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Relatório do BootStrap');
    DBMS_OUTPUT.PUT_LINE('Número de inserts por tabela:');
    FOR I IN (SELECT TABLE_NAME FROM USER_TABLES)
        LOOP
            EXECUTE IMMEDIATE 'SELECT count (*) FROM ' || i.table_name INTO contador;
            DBMS_OUTPUT.PUT_LINE(i.table_name || ' ==> ' || contador);
        END LOOP;
END;