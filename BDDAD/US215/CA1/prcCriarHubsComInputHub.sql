CREATE OR REPLACE PROCEDURE prcCriarHubsComInputHub AS
    input_string varchar2(25);
    inserted_hubs number;
    counter number;
    loc_id_input varchar2(255);
    loc_id_end_indx number;
    latitude_input varchar2(255);
    latitude_end_indx number;
    longitude_input varchar2(255);
    longitude_end_indx number;
    cod varchar2(255);

cursor input_hubs IS
SELECT * FROM INPUTHUB;

BEGIN
inserted_hubs := 0;
OPEN input_hubs;
LOOP
FETCH input_hubs INTO input_string;
    EXIT WHEN input_hubs%NOTFOUND;
    loc_id_end_indx := instr(input_string,';',1,1);
    latitude_end_indx := instr(input_string,';',1,2);
    longitude_end_indx := instr(input_string,';',1,3);
    cod := substr(input_string,longitude_end_indx+1,length(input_string)-longitude_end_indx);

    IF (substr(cod,1,1) LIKE 'E') THEN

        loc_id_input := substr(input_string,1,loc_id_end_indx-1);

SELECT COUNT(*) INTO counter FROM HUB
WHERE LOC_ID_PK LIKE loc_id_input;

IF (counter = 0) THEN
            latitude_input := replace(substr(input_string,loc_id_end_indx+1,latitude_end_indx-loc_id_end_indx-1),'.',',');
            longitude_input := replace(substr(input_string,latitude_end_indx+1,longitude_end_indx-latitude_end_indx-1),'.',',');
INSERT INTO HUB(loc_id_pk, latitude, longitude) VALUES (loc_id_input,CAST(latitude_input AS DOUBLE PRECISION),CAST(longitude_input AS DOUBLE PRECISION));
inserted_hubs:=inserted_hubs+1;
end if;
END IF;
end loop;
    IF (inserted_hubs = 0) THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum hub foi inserido. (Pode estar a inserir dados repetidos ou inválidos ou a tabela inputHubs pode estar vazia)');
ELSE
        DBMS_OUTPUT.PUT_LINE('Tabela atulizada. Foram inserido(s) ' || inserted_hubs || ' hub(s).');
END IF;

DELETE FROM INPUTHUB;
end;