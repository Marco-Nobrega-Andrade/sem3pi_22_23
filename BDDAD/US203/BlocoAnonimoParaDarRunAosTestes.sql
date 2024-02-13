Set ServerOutput ON
Begin
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Elemento a coluna quantidade');
    DBMS_OUTPUT.PUT('quantidade é igual a 0: ');
    prcTestCheckElementoQuantidade('0'); /* Reprovado -  Devido ao quantidade ter ser maior que 0*/
    DBMS_OUTPUT.PUT('quantidade é igual a 10: ');
    prcTestCheckElementoQuantidade('10'); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Cliente a coluna plafond');
    DBMS_OUTPUT.PUT('plafond é igual a -1: ');
    prcTestCheckClientePlafond('-1'); /* Reprovado -  Devido ao plafond ter ser igual ou maior que 0*/
    DBMS_OUTPUT.PUT('plafond é igual a 10: ');
    prcTestCheckClientePlafond('10'); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Cliente a coluna nivel_plafond');
    DBMS_OUTPUT.PUT('nivel_plafond é igual a D: ');
    prcTestCheckClienteNivelPlafond('D'); /* Reprovado -  Devido ao nivel_plafond ter ser igual a "A","B" ou "C"*/
    DBMS_OUTPUT.PUT('nivel_plafond é igual a C: ');
    prcTestCheckClienteNivelPlafond('C'); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Cliente a coluna num_fiscal');
    DBMS_OUTPUT.PUT('num_fiscal é igual a 123123123: ');
    prcTestCheckClienteNumFiscal(23123123); /* Reprovado -  Devido ao num_fiscal ter um numero que não contem 9 digitos*/
    DBMS_OUTPUT.PUT('num_fiscal é igual a 4123123123: ');
    prcTestCheckClienteNumFiscal(123123123); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Cliente a coluna email');
    DBMS_OUTPUT.PUT('email é igual a "joaogmail.com": ');
    prcTestCheckClienteEmail('joaogmail.com'); /* Reprovado -  Devido ao email ter de ter um "@" e um "."*/
    DBMS_OUTPUT.PUT('email é igual a "joao@gmail.com": ');
    prcTestCheckClienteEmail('joao@gmail.com'); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Cliente a coluna num_encomendas_colocadas');
    DBMS_OUTPUT.PUT('num_encomendas_colocadas é igual a -1: ');
    prcTestCheckClienteNumeroDeEncomendasColocadas(-1); /* Reprovado -  Devido ao num_encomendas_colocadas ter de ser maior ou igual a 0*/
    DBMS_OUTPUT.PUT('num_encomendas_colocadas é igual a 12: ');
    prcTestCheckClienteNumeroDeEncomendasColocadas(12); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Cliente a coluna valor_encomendas');
    DBMS_OUTPUT.PUT('valor_encomendas é igual a -1: ');
    prcTestCheckClienteValorDeEncomendas(-1); /* Reprovado -  Devido ao valor_encomendas ter de ser maior ou igual a 0*/
    DBMS_OUTPUT.PUT('valor_encomendas é igual a 12: ');
    prcTestCheckClienteValorDeEncomendas(12); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Incidente a coluna valor_incidente');
    DBMS_OUTPUT.PUT('valor_incidente é igual a 0: ');
    prcTestCheckIncidenteValorIncidente(0); /* Reprovado -  Devido ao valor_incidente ter de ser maior que 0*/
    DBMS_OUTPUT.PUT('valor_incidente é igual a 12: ');
    prcTestCheckIncidenteValorIncidente(12); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Encomenda a coluna status');
    DBMS_OUTPUT.PUT('status é igual a "enviar": ');
    prcTestCheckEncomendaStatus('liqui'); /* Reprovado -  Devido ao status ter de ser igual a "Registada","Entregue" ou "Paga"*/
    DBMS_OUTPUT.PUT('status é igual a "entregue": ');
    prcTestCheckEncomendaStatus('entregue'); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela FatorProducao a coluna formulacao');
    DBMS_OUTPUT.PUT('formulacao é igual a "liqui": ');
    prcTestCheckFatorProducaoFormulacao('liqui'); /* Reprovado -  Devido ao formulacao ter de ser igual a "Liquido","Granulado" ou "Po"*/
    DBMS_OUTPUT.PUT('formulacao é igual a "liquido": ');
    prcTestCheckFatorProducaoFormulacao('liquido'); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela FatorProducao a coluna classificacao');
    DBMS_OUTPUT.PUT('classificacao é igual a "adu": ');
    prcTestCheckFatorProducaoClassificacao('adu'); /* Reprovado -  Devido ao classificacao ter de ser igual a "Fertelizante","Adubo", "Corretivo" ou "Produto fitofarmaca"*/
    DBMS_OUTPUT.PUT('classificacao é igual a "po": ');
    prcTestCheckFatorProducaoClassificacao('po'); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Cultura a coluna tipo_cultura');
    DBMS_OUTPUT.PUT('tipo_cultura é igual a "chuva": ');
    prcTestCheckCulturaTipoDeCultura('anual'); /* Reprovado -  Devido ao tipo_cultura ter de ser igual a  "permanente" ou "temporario"*/
    DBMS_OUTPUT.PUT('tipo_cultura é igual a "gravidade": ');
    prcTestCheckCulturaTipoDeCultura('permanente'); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Rega a coluna tipo_rega');
    DBMS_OUTPUT.PUT('tipo_rega é igual a "chuva": ');
    prcTestCheckRegaTipoRega('chuva'); /* Reprovado -  Devido ao tipo_rega ter de ser igual a  "Primario" ou "Secundario"*/
    DBMS_OUTPUT.PUT('tipo_rega é igual a "gravidade": ');
    prcTestCheckRegaTipoRega('gravidade'); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Plantacao a coluna quantidade_colhida');
    DBMS_OUTPUT.PUT('quantidade_colhida é igual a 0: ');
    prcTestCheckPlantacaoQuantidadeColhida(0); /* Reprovado -  Devido à quantidade_colhida ter de ser maior que 0 ou igual a null */
    DBMS_OUTPUT.PUT('quantidade_colhida é igual a 5: ');
    prcTestCheckPlantacaoQuantidadeColhida(null); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Tubagem a coluna tipo_tubagem');
    DBMS_OUTPUT.PUT('tipo_tubagem é igual a "terceario": ');
    prcTestCheckTubagemTipoTubagem('terceario'); /* Reprovado -  Devido ao tipo_tubagem ter de ser igual a "primario","secundario" */
    DBMS_OUTPUT.PUT('tipo_tubagem é igual a "primario": ');
    prcTestCheckTubagemTipoTubagem('primario'); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Edificio a coluna tipo_edificio');
    DBMS_OUTPUT.PUT('tipo_edificio é igual a "jardim": ');
    prcTestCheckEdificioTipoEdificio('jardim'); /* Reprovado -  Devido ao tipo_edificio ter de ser igual a "Estabulo para animais","Garagem para maquinas","Garagem para alfaias", "Armazem para colheitas","Armazem para fatores de producao","Armazem para racoes para animais" ou "Sistema de rega" */
    DBMS_OUTPUT.PUT('tipo_edificio é igual a "Estabulo para animais": ');
    prcTestCheckEdificioTipoEdificio('Estabulo para animais'); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Fertilizacao a coluna quantidade');
    DBMS_OUTPUT.PUT('quantidade é igual a 0: ');
    prcTestCheckFertilizacaoQuantidade(0); /* Reprovado -  Devido à quantidade ter de ser maior que 0 */
    DBMS_OUTPUT.PUT('quantidade é igual a 5: ');
    prcTestCheckFertilizacaoQuantidade(5); /* Aprovado */
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Teste na tabela Morada a coluna codigo_postal');
    DBMS_OUTPUT.PUT('codigo_postal é igual a 123-123: ');
    prcTestCheckMoradaCodigoPostal('123-123'); /* Reprovado -  Devido a ter o formato NNN-NNN sendo N um numero qualquer */
    DBMS_OUTPUT.PUT('codigo_postal é igual a 1234-123: ');
    prcTestCheckMoradaCodigoPostal('1234-123'); /* Aprovado */  
end;
end;