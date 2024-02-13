
CREATE OR REPLACE FUNCTION insert_new_client (
p_nome Cliente.NOME%TYPE,
p_nif Cliente.NUM_FISCAL%TYPE,
p_email Cliente.EMAIL%TYPE,
p_endereco_particular Morada.ENDERECO%TYPE,
p_codigo_postal_particular Morada.CODIGO_POSTAL%TYPE,
p_endereco_entrega Morada.ENDERECO%TYPE,
p_codigo_postal_entrega Morada.CODIGO_POSTAL%TYPE
)
RETURN Utilizador.ID_UTILIZADOR_PK%TYPE
    IS
    v_id Utilizador.ID_UTILIZADOR_PK%TYPE;
    v_morada_particular_id Morada.ID_MORADA_PK%TYPE;
    v_morada_entrega_id Morada.ID_MORADA_PK%TYPE;
    --exceptions
    e_morada_sem_parametros_suficentes EXCEPTION;
    PRAGMA exception_init( e_morada_sem_parametros_suficentes, -20001 );
    BEGIN
        -- insert Utilizador and store id into v_id
        INSERT INTO UTILIZADOR (ID_UTILIZADOR_PK) VALUES (DEFAULT) RETURNING ID_UTILIZADOR_PK INTO v_id;
        INSERT INTO MORADA (ID_MORADA_PK,ENDERECO,CODIGO_POSTAL) VALUES (default, p_endereco_particular, p_codigo_postal_particular)  RETURNING ID_MORADA_PK INTO v_morada_particular_id;

        -- morada entrega
       if (p_codigo_postal_entrega IS NOT NULL AND p_codigo_postal_entrega IS NOT NULL) THEN
            INSERT INTO MORADA (ID_MORADA_PK,ENDERECO,CODIGO_POSTAL) VALUES (default, p_endereco_entrega, p_codigo_postal_entrega) RETURNING ID_MORADA_PK INTO v_morada_entrega_id;
        else
            if (p_codigo_postal_entrega IS NULL AND p_codigo_postal_entrega IS NOT NULL)  then
            raise_application_error(-20001, 'É necessário colocar ambos o endereço e codigo postal de entrega ou omitir ambos ');
            end if;
        if (p_codigo_postal_entrega IS NOT NULL AND p_codigo_postal_entrega IS NULL) then
                raise_application_error(-20001, 'É necessário colocar ambos o endereço e codigo postal de entrega ou omitir ambos ');
            end if;
       end if;
        -- if no morada de entrega is specified, use morada particular
        if (p_codigo_postal_entrega IS NULL AND p_codigo_postal_entrega IS NULL) then
            INSERT INTO MORADA (ID_MORADA_PK,ENDERECO,CODIGO_POSTAL) VALUES (default, p_endereco_particular, p_codigo_postal_particular) RETURNING ID_MORADA_PK INTO v_morada_entrega_id;
        end if;



        -- add client

        INSERT INTO CLIENTE (ID_UTILIZADOR_CLIENTE_FK, ID_MORADA_PARTICULAR_FK, ID_MORADA_ENTREGA_FK, NOME, PLAFOND, NUM_FISCAL, NIVEL_PLAFOND, EMAIL, NUM_ENCOMENDAS_COLOCADAS, VALOR_ENCOMENDAS) VALUES
        (v_id, v_morada_particular_id, v_morada_entrega_id, p_nome, 0, p_nif, 'C', p_email, 0, 0);
        dbms_output.put_line('Adicionado o novo cliente com id ' || v_id);

        COMMIT;
        return v_id;
    EXCEPTION
        WHEN others THEN
            -- undo any commits
            rollback;
            dbms_output.put_line('Erro ao adicionar cliente.'|| SQLERRM);
            return null;
    END;


-- Drop the function

DROP FUNCTION insert_new_client;

