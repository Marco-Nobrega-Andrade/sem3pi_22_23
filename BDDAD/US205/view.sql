CREATE OR REPLACE VIEW v_cliente AS
SELECT *
FROM (SELECT C.ID_UTILIZADOR_CLIENTE_FK                              as ID,
             nvl(C.nome, 'Sem nome')                                 as Nome,
             C.NIVEL_PLAFOND                                         as nivel_plafond,
             NVL(to_char(I.DATA_INCIDENTE), 'Sem incidentes à data') as ultimo_incidente,
             NVL(to_char(
                         (SELECT SUM(ENCOMENDA.VALOR)
                          FROM ENCOMENDA
                          WHERE ID_DISTRIBUICAO_FK IN (SELECT ID_DISTRIBUICAO_PK
                                                       FROM DISTRIBUICAO
                                                       WHERE (ID_UTILIZADOR_CLIENTE_FK = C.ID_UTILIZADOR_CLIENTE_FK)
                                                         AND (ENCOMENDA.DATA_REGISTO >
                                                              add_months(sysdate, -12)
                                                           AND
                                                              (ENCOMENDA.STATUS = 'PAGA'))))), 'Sem encomendas pagas')
                                                                     AS Volume_Encomendas_PAGAS
              ,
             NVL(to_char(
                         (SELECT SUM(ENCOMENDA.VALOR) as Volume_Encomendas_ENTREGUES
                          FROM ENCOMENDA
                          WHERE ID_DISTRIBUICAO_FK IN (SELECT ID_DISTRIBUICAO_PK
                                                       FROM DISTRIBUICAO
                                                       WHERE (ID_UTILIZADOR_CLIENTE_FK = C.ID_UTILIZADOR_CLIENTE_FK)
                                                         AND (ENCOMENDA.DATA_REGISTO >
                                                              add_months(sysdate, -12)
                                                           AND
                                                              (ENCOMENDA.STATUS = 'ENTREGUE'))))),
                 'Sem encomendas entregues')
                                                                     AS Volume_Encomendas_ENTREGUES
      FROM CLIENTE C
               LEFT JOIN INCIDENTE I on C.ID_UTILIZADOR_CLIENTE_FK = I.ID_UTILIZADOR_CLIENTE_FK);


select *
from v_cliente;