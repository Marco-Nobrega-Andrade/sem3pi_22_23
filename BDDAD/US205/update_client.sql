
CREATE OR REPLACE PROCEDURE update_numero_encomendas_e_valor_encomendas (
p_id_cliente UTILIZADOR.ID_UTILIZADOR_PK%TYPE
)
    IS
    v_id_distribuicao DISTRIBUICAO.ID_DISTRIBUICAO_PK%TYPE;
    v_morada_entrega ENCOMENDA.ID_MORADA_ENTREGA_FK%TYPE;
    v_data_registo ENCOMENDA.DATA_REGISTO%TYPE;
    v_data_entrega ENCOMENDA.DATA_ENTREGA%TYPE;
    v_status ENCOMENDA.STATUS%TYPE;
    v_valor ENCOMENDA.VALOR%TYPE;

    v_valor_total number := 0;
    v_num_encomendas number := 0;

        -- fetch all encomendas of that cliente from 1 year ago
    CURSOR c_encomendas is
        SELECT * FROM ENCOMENDA WHERE ID_DISTRIBUICAO_FK IN ( SELECT ID_DISTRIBUICAO_PK FROM DISTRIBUICAO
        WHERE (ID_UTILIZADOR_CLIENTE_FK = p_id_cliente )
         AND  (ENCOMENDA.DATA_REGISTO > add_months(sysdate, -12))
        );

BEGIN
    OPEN c_encomendas;
        LOOP
            FETCH c_encomendas into v_id_distribuicao, v_morada_entrega, v_data_entrega, v_data_registo, v_status, v_valor;
            EXIT WHEN c_encomendas%notfound;
            dbms_output.put_line('id distribuicao: ' || v_id_distribuicao || ' valor: ' || v_valor
                || ' data registo: ' || v_data_registo || ' data entrega: ' || v_data_entrega || ' status: ' || v_status);
            -- update numero encomendas and valor encomendas
            v_valor_total := v_valor_total + v_valor;
            v_num_encomendas := v_num_encomendas + 1;
        END LOOP;
    CLOSE c_encomendas;
    dbms_output.put_line('valor total: ' || v_valor_total || ' num encomendas: ' || v_num_encomendas);
    UPDATE cliente SET NUM_ENCOMENDAS_COLOCADAS = v_num_encomendas, VALOR_ENCOMENDAS = v_valor_total WHERE ID_UTILIZADOR_CLIENTE_FK = p_id_cliente;
    COMMIT;
EXCEPTION
    WHEN others THEN
        -- undo any commits
        rollback;
        dbms_output.put_line('Erro ao atualizar cliente'|| SQLERRM);
end;


CREATE OR REPLACE PROCEDURE update_all_clientes
    IS
    v_id_cliente UTILIZADOR.ID_UTILIZADOR_PK%TYPE;

    -- fetch all clientes
    CURSOR c_clientes is select ID_UTILIZADOR_CLIENTE_FK from cliente;
BEGIN
    OPEN c_clientes;
    LOOP
        FETCH c_clientes into v_id_cliente;
        EXIT WHEN c_clientes%notfound;
        dbms_output.put_line('atualizando cliente: ' || v_id_cliente);
        update_numero_encomendas_e_valor_encomendas(v_id_cliente);
    END LOOP;
    CLOSE c_clientes;
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('Erro ao atualizar clientes'|| SQLERRM);
end;

-- Drop the functions

DROP FUNCTION update_numero_encomendas_e_valor_encomendas;
DROP FUNCTION update_all_clientes;
