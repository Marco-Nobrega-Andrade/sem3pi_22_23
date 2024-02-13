package Project.model;

import Project.graph.Graph;
import Project.model.Analtytics.*;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class Main {
    static DistributionNetwork distributionNetwork = null;
    static IrrigationController irrigationController = null;
    static List<DistributionNetworkMember> hubs = null;
    private static final Scanner ler = new Scanner(System.in);

    public static void main(String[] args) throws IOException, ParseException {

        int i;
        do {
            System.out.printf("Escolha uma opção: \n");
            System.out.println("1. Carregar dados para criar o grafo.");
            System.out.println("2. Carregar os cabazes.");
            System.out.println("3. Verificar se o grafo é conexo e o número mínimo de ligações.");
            System.out.println("4. Definir os hubs da rede de distribuição.");
            System.out.println("5. Determinar o hub mais próximo.");
            System.out.println("6. Determinar a rede que conecta todos os clientes e produtores agrícolas.");
            System.out.println("7. Simular o funcionamento de um controlador de rega.");
            System.out.println("8. Carregar ficheiro CSV.");
            System.out.println("9. Gerar lista de expedição sem restrições.");
            System.out.println("10. Gerar lista de expedição com restrições.");
            System.out.println("11. Gerar o percurso de entrega para uma lista de expedição.");
            System.out.println("12. Calcular estatísticas para uma lista de expedição.");
            System.out.println("13. Sair.");
            do {
                try {
                    i = Integer.parseInt(ler.nextLine());
                    if (i < 1 || i > 13) {
                        System.out.println("Por favor introduza um valor de 1 a 13.");
                    }
                } catch (Exception e) {
                    System.out.println("Por favor introduza um valor de 1 a 13.");
                    i = 0;
                }
            } while (i < 1 || i > 13);

            switch (i) {
                case 1:
                    distributionNetwork = new DistributionNetwork();
                    Boolean flag = false;
                    String fileMembers;
                    do {
                        System.out.println("Carregue o ficheiro com a informação dos membros");
                        fileMembers = ler.nextLine();
                        if (!fileMembers.equals("1")) {
                            try {
                                List<String> memberInfo = Files.lines(Paths.get(fileMembers), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
                                System.out.println("Carregue o ficheiro com a informação dos caminhos");
                                String fileTracks = ler.nextLine();
                                List<String> trackInfo = Files.lines(Paths.get(fileTracks), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
                                distributionNetwork.loadGraph(memberInfo, trackInfo);
                                flag = true;
                            } catch (NoSuchFileException e) {
                                System.out.println("Não existe esse ficheiro no sistema! (se deseja voltar atrás digite 1)");
                            } catch (ArrayIndexOutOfBoundsException e) {
                                System.out.println("Os ficheiros introduzidos são incorretos! (se deseja voltar atrás digite 1)");
                            }
                        }
                    } while (!flag && !fileMembers.equals("1"));
                    break;
                case 2:
                    if (distributionNetwork == null) {
                        System.out.println("ERRO: Carregue o ficheiro com os dados para o grafo (Funcionalidade 1)\n");
                    } else {
                        String baskets;
                        Boolean success = false;
                        do {
                            System.out.println("Carregue o ficheiro com a informação dos cabazes");
                            baskets = ler.nextLine();
                            if (!baskets.equals("1")) {
                                try {
                                    List<String> basketsInfo = Files.lines(Paths.get(baskets), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
                                    int insertedLines = distributionNetwork.loadBaskets(basketsInfo);
                                    success = true;
                                    int fileNumBaskets = basketsInfo.size();
                                    if(insertedLines == (fileNumBaskets - 1)){
                                        System.out.printf("Todos os cabazes foram inseridos com sucesso.\n\n");
                                    }else{
                                        System.out.printf("Foram inseridos %d de %d cabazes com sucesso.\n\n", insertedLines, (fileNumBaskets-1));
                                    }
                                } catch (NoSuchFileException e) {
                                    System.out.println("Não existe esse ficheiro no sistema! (se deseja voltar atrás digite 1)");
                                } catch (ArrayIndexOutOfBoundsException | NumberFormatException e) {
                                    System.out.println("Os ficheiros introduzidos são incorretos! (se deseja voltar atrás digite 1)");
                                }
                            }
                        }while (!success && !baskets.equals("1"));
                    }
                    break;
                case 3:
                    if (distributionNetwork == null) {
                        System.out.println("ERRO: Carregue o ficheiro com os dados para o grafo (Funcionalidade 1)\n");
                    } else {
                        int isConex = distributionNetwork.isConex();
                        if (isConex == -1) {
                            System.out.println("O grafo não é conexo.");
                        } else {
                            System.out.printf("O grafo é conexo e tem %d ligações mínimas %n", isConex);
                        }
                    }
                    break;
                case 4:
                    if (distributionNetwork == null) {
                        System.out.println("ERRO: Carregue o ficheiro com os dados para o grafo (Funcionalidade 1)\n");
                    } else {
                        System.out.println("Escreva o número de hubs que deseja definir:");
                        int n;
                        do {
                            n = ler.nextInt();
                            if (n <= 0) {
                                System.out.println("ERRO: o número de hubs deve ser um número positivo não nulo! ");
                            }
                        } while (n <= 0);
                        hubs = new ArrayList<>();
                        hubs = distributionNetwork.defineHubs(n);
                        for (DistributionNetworkMember hub : hubs) {
                            System.out.println(hub.toString());
                        }
                    }
                    break;
                case 5:
                    if (distributionNetwork == null) {
                        System.out.println("ERRO: Carregue o ficheiro com os dados para o grafo (Funcionalidade 1)\n");
                    } else {
                        if (hubs == null) {
                            System.out.println("ERRO: Não foram definidos nenhuns hubs no sistema (Funcionalidade 4)\n");
                        } else {
                            Map<DistributionNetworkMember, DistributionNetworkMember> closestHub = distributionNetwork.getClosestHub();
                            System.out.println("Empresa ou Particular ----> Hub mais próximo");
                            for (DistributionNetworkMember member : closestHub.keySet()) {
                                System.out.print(member.toString());
                                System.out.print(" ----> ");
                                System.out.println(closestHub.get(member));
                            }
                        }
                    }
                    break;
                case 6:
                    if (distributionNetwork == null) {
                        System.out.println("ERRO: Carregue o ficheiro com os dados para o grafo (Funcionalidade 1)\n");
                    } else {
                        Graph<DistributionNetworkMember, DistributionNetwork.Track> minimumSpanningNetwork = distributionNetwork.minimumSpanningNetwork();
                        System.out.println(minimumSpanningNetwork.toString());
                    }
                    break;
                case 7:
                    if (irrigationController == null) {
                        System.out.println("\nERRO: Introduza o ficheiro CSV primeiro (funcionalidade 8) !\n");
                    } else {
                        Date date = readDateMenu(irrigationController.getIrrigationHours().get(0));
                        int counterIrrigationDate = 0;
                        int counterSectorToIrrigate = 0;
                        for (Date irrigationDate : irrigationController.getIrrigationHours()) {
                            counterIrrigationDate++;
                            for (SectorToIrrigate sector : irrigationController.getSectorsToIrrigate()) {
                                Calendar c = Calendar.getInstance();
                                c.setTime(irrigationDate);
                                date.setDate(irrigationDate.getDate());
                                date.setMonth(irrigationDate.getMonth());
                                date.setYear(irrigationDate.getYear());
                                Date sectorDate = new Date(irrigationDate.getYear(), irrigationDate.getMonth(), c.get(Calendar.DAY_OF_MONTH), irrigationDate.getHours(), irrigationDate.getMinutes() + sector.getDuration(), irrigationDate.getSeconds());
                                if (date.compareTo(irrigationDate) >= 0 && date.compareTo(sectorDate) <= 0) {
                                    System.out.printf("O setor %s está a ser regado e faltam %d m para acabar!\n", sector.getSector(), (sectorDate.getTime() - date.getTime()) / 60000);
                                } else {
                                    counterSectorToIrrigate++;
                                }
                            }
                            if (counterSectorToIrrigate == irrigationController.getSectorsToIrrigate().size())
                                System.out.printf("Não está nenhum setor a ser regado para a rega nº %d marcada!\n", counterIrrigationDate);
                            System.out.println();
                            counterSectorToIrrigate = 0;
                        }
                    }
                    break;
                case 8:
                    irrigationController = fileVerification();
                    System.out.println();
                    break;
                case 9:
                    if (distributionNetwork == null) {
                        System.out.println("ERRO: Carregue o ficheiro com os dados para o grafo (Funcionalidade 1)\n");
                    } else {
                        if(distributionNetwork.testHubsExistence()) {
                            System.out.println("Introduza o dia para o qual deseja gerar a lista de expedição:");
                            int day;
                            do {
                                day = ler.nextInt();
                                if (day <= 0) {
                                    System.out.println("ERRO: deverá introduzir um número positivo!");
                                }
                            } while (day <= 0);


                            List<Shipment> shipmentList = distributionNetwork.generateShipmentList(day);
                            if (shipmentList == null)
                                System.out.println("Não existe dados para o dia selecionado!");
                            else {
                                for (Shipment s : shipmentList) {
                                    System.out.println(s);
                                }
                            }

                        }else System.out.println("ERRO: não existem hubs definidos!");
                        System.out.println();
                    }
                    break;

                case 10:
                    if (distributionNetwork == null) {
                        System.out.println("ERRO: Carregue o ficheiro com os dados para o grafo (Funcionalidade 1)\n");
                    }
                    else {
                        if (distributionNetwork.testHubsExistence()) {
                            System.out.println("Introduza o dia para o qual deseja gerar a lista de expedição:");
                            int day = -1;
                            do {
                                try {
                                    day = ler.nextInt();
                                    if (day <= 0) {
                                        System.out.println("ERRO: introduza um número positivo!");
                                    }
                                } catch (Exception e) {
                                    System.out.println("ERRO: introduza um número positivo!");
                                }
                            } while (day <= 0);

                            System.out.println("Introduza o número de produtores, mais próximos ao hub do cliente que abastecem, para o qual deseja gerar a lista de expedição:");
                            int n = -1;
                            do {
                                try {
                                    n = ler.nextInt();
                                    if (n <= 0) {
                                        System.out.println("ERRO: introduza um número positivo!");
                                    }
                                } catch (Exception e) {
                                    System.out.println("ERRO: introduza um número positivo!");
                                }
                            } while (n <= 0);

                            List<Shipment> shipmentList = distributionNetwork.generateShipmentList(day,n);

                            if (shipmentList == null)
                                System.out.println("Não existe dados para o dia selecionado!");
                            else {
                                for (Shipment s : shipmentList) {
                                    System.out.println(s);
                                }
                            }
                        }
                        else System.out.println("ERRO: não existem hubs definidos!");
                    }
                    break;

                case 11:
                    if (distributionNetwork == null){
                        System.out.println("ERRO: Carregue o ficheiro com os dados para o grafo (Funcionalidade 1)\n");
                        break;
                    }
                    if (distributionNetwork.getBuyersWithOrders() == null || distributionNetwork.getProducersWithOrders() == null){
                        System.out.println("ERRO: Carregue o ficheiro com os dados dos cabazes (Funcionalidade 2)\n");
                        break;
                    }

                    int day;
                    System.out.println("Insira o dia para o qual deseja gerar o percurso de entrega.");
                    do {
                        try {
                            day = Integer.parseInt(ler.nextLine());
                            if (day < 0) {
                                System.out.println("Por favor introduza um número positivo.");
                            }
                        } catch (Exception e) {
                            System.out.println("Por favor introduza um número positivo.");
                            day = -1;
                        }
                    } while (day < 0);


                    int option;
                    System.out.println("Escolha o tipo de lista de expedição para o qual deseja gerar o percurso de entrega.");
                    System.out.println("1. Gerar lista de expedição sem restrições.");
                    System.out.println("2. Gerar lista de expedição com restrições.");
                    do {
                        try {
                            option = Integer.parseInt(ler.nextLine());
                            if (option < 1 || option > 2) {
                                System.out.println("Por favor introduza os valores 1 ou 2.");
                            }
                        } catch (Exception e) {
                            System.out.println("Por favor introduza os valores 1 ou 2.");
                            option = -1;
                        }
                    } while (option < 1 || option > 2);

                    Map<Shipment,ArrayList<Delivery>> result = distributionNetwork.generateDeliveryRoutes(day,option);
                    if (result == null){
                        System.out.println("ERRO: Não existe uma lista de expedição deste tipo válida para este dia. Por favor gere uma lista de expedição primeiro. (Funcionalidade 9 e 10)\n");
                        break;
                    }

                    double total_distance = 0;
                    for (Map.Entry<Shipment,ArrayList<Delivery>> entry : result.entrySet()){
                        System.out.println(entry.getKey());
                        for (Delivery delivery : entry.getValue()){
                            System.out.println(delivery);
                            total_distance += delivery.getDeliveryRoute().getMiles();
                        }
                        System.out.println();
                    }
                    System.out.println("Distância total : " + total_distance);
                    break;
                case 12:

                    if (distributionNetwork == null) {
                        System.out.println("ERRO: Carregue o ficheiro com os dados para o grafo. (Funcionalidade 1)\n");
                        break;
                    }
                    if (distributionNetwork.getBuyersWithOrders() == null || distributionNetwork.getProducersWithOrders() == null) {
                        System.out.println("ERRO: Carregue o ficheiro com os dados dos cabazes. (Funcionalidade 2)\n");
                        break;
                    }
                    if(hubs == null){
                        System.out.println("ERRO: Por favor defina os hubs. (Funcionalidade 4)\n");
                    }
                    String optionLeaving;
                    do {
                        System.out.println("Para que dia gostaria de fazer a análise?");
                        int day1;
                        do {
                            try {
                                day1 = ler.nextInt();
                                if (day1 < 1) {
                                    System.out.println("Deve inserir um dia superior a 0.");
                                    System.out.printf("\nPara que dia gostaria de fazer a análise?\n");
                                }
                            } catch (Exception e) {
                                System.out.println("Deve inserir um dia superior a 0.");
                                System.out.printf("\nPara que dia gostaria de fazer a análise?\n");
                                day1 = -1;
                            }
                        } while (day1 < 1);
                        System.out.println("Escolha o método de expedição que deseja analisar.");
                        System.out.println("1. Gerar lista de expedição sem restrições.");
                        System.out.println("2. Gerar lista de expedição com restrições.");
                        int option1;
                        do {
                            try {
                                option1 = ler.nextInt();
                                ler.nextLine();
                                if (option1 < 1 || option1 > 2) {
                                    System.out.println("Deverá escolher uma opção entre 1 e 2");
                                    System.out.printf("\nEscolha o método de expedição que deseja analisar.\n");
                                }
                            } catch (Exception e) {
                                System.out.println("Deverá escolher uma opção entre 1 e 2");
                                System.out.printf("\nEscolha o método de expedição que deseja analisar.\n");
                                option1 = -1;
                            }
                        } while (option1 < 1 || option1 > 2);

                        Map<Shipment,ArrayList<Delivery>> result1 = distributionNetwork.generateDeliveryRoutes(day1,option1);
                        if (result1 == null){
                            System.out.println();
                            System.out.print("ERRO: Não existe uma lista de expedição deste tipo válida para este dia. Por favor gere uma lista de expedição primeiro. (Funcionalidade 9 e 10)\n");
                            break;
                        }

                        ShipmentAnalysis analysis = distributionNetwork.generateAnalysis(option1, day1);
                        int basketNumber = 0;
                        System.out.printf("\n\nAnálise dos cabazes : \n");
                        for(BasketAnalysis basketAnalysis:analysis.getListBasketAnalytics()){
                            basketNumber++;
                            System.out.printf("\nCabaz nº%d:\n", basketNumber);
                            System.out.printf("Número de Produtos = %d\n",basketAnalysis.getNumberOfProductors());
                            System.out.printf("Número de produtos totalmente satisfeitos = %d\n", basketAnalysis.getNumberOfProductors());
                            System.out.printf("Número de produtos instatisfeitos = %d\n", basketAnalysis.getNumberOfProductsTotallySatisfied());
                            System.out.printf("Percentagem de satisfação = %d\n",basketAnalysis.getNumberOfProductsNotSatisfied());
                        }
                        System.out.printf("\n\nAnálise dos clientes : \n");
                        for(ClientAnalysis clientAnalysis : analysis.getListClientAnalytics()){
                            System.out.printf("\nID do Cliente: %s\n",clientAnalysis.getBuyer().getLocId());
                            System.out.printf("Número de cabazes totalmente satisfeitos = %d\n", clientAnalysis.getNumberOfBasketsTotallySatisfied());
                            System.out.printf("Número de cabazes parcialmente satisfeitos = %d\n",clientAnalysis.getNumberOfBasketsPartiallySatisfied());
                            System.out.printf("Número de produtores distintos = %d\n", clientAnalysis.getNumberOfDistintProductors());
                        }
                        System.out.printf("\n\nAnálise dos hubs : \n");
                        for(HubAnalysis hubAnalysis:analysis.getListHubAnalysis()){
                            System.out.printf("\nEmpresa : %s\n", hubAnalysis.getCompany());
                            System.out.printf("Número de clientes = %d\n",hubAnalysis.getNumberOfClients());
                            System.out.printf("Número de produtores = %d\n",hubAnalysis.getNumberOfProducers());
                        }
                        System.out.printf("\n\nAnálise dos produtores : \n");
                        for(ProducerAnalysis producerAnalysis : analysis.getListProducerAnalysis()){
                            System.out.printf("\nProdutor : %s\n", producerAnalysis.getProducer());
                            System.out.printf("Número de clientes = %d\n", producerAnalysis.getNumberOfClients());
                            System.out.printf("Número de hubs = %d\n", producerAnalysis.getNumberOfHubs());
                            System.out.printf("Número de cabazes totalmente satisfeitos = %d\n", producerAnalysis.getNumberOfBasketsFullySatisfied());
                            System.out.printf("Número de cabazes parcialmente satisfeitos = %d\n", producerAnalysis.getGetNumberOfBasketsPartiallySatisfied());
                            System.out.printf("Número de produtos que acabaram = %d\n", producerAnalysis.getNumberOfProductsDepleted());
                        }
                        System.out.println();
                        System.out.printf("\nGostaria de continuar a calcular estatísticas para uma lista de expedição? (Y/N)\n");
                        do {
                            optionLeaving = ler.nextLine();
                            if (!optionLeaving.equals("y") && !optionLeaving.equals("Y") && !optionLeaving.equals("n") && !optionLeaving.equals("N")) {
                                System.out.println("Deverá escolher Y para aceitar e N para sair");
                                System.out.printf("\nGostaria de continuar a calcular estatísticas para uma lista de expedição. (Y/N) \n");
                            }
                        } while (!optionLeaving.equals("y") && !optionLeaving.equals("Y") && !optionLeaving.equals("n") && !optionLeaving.equals("N"));
                    } while (optionLeaving.equals("y") || optionLeaving.equals("Y"));
                    System.out.println();
                    break;
            }
        }
        while (i != 13);
    }

    public static Date readDateMenu(Date date) throws ParseException {
        System.out.println("\nInsira a data (dd-MM-aaaa HH:mm:ss ou aaaa-MM-dd HH:mm:ss):");
        return readDay(date);
    }

    public static IrrigationController fileVerification() throws IOException, ParseException {
        IrrigationController irrigationController = null;
        boolean flag = true;
        while (flag) {
            System.out.println("\nIntroduza o nome do ficheiro CSV:");
            String file = ler.nextLine();
            File testFile = new File(file);
            if (testFile.exists()) {
                List<String> infoIrrigation = Files.lines(Paths.get(file), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
                irrigationController = new IrrigationController(infoIrrigation);
                System.out.println("\n------------Descarregando-------------");
                System.out.println("----------Processo concluido----------");
                flag = false;
            } else {
                System.out.println("\nERRO: O nome do ficheiro introduzido não existe!");
            }
        }

        return irrigationController;
    }

    public static Date readDay(Date date) throws ParseException {
        String day;
        Date date1 = null;
        boolean validDate = false;
        boolean validDate2 = false;
        while (!validDate || !validDate2) {
            day = ler.nextLine();
            int dateType = isValidDate(day);
            if (dateType == 1) {
                date1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").parse(day);
                validDate = true;
            } else if (dateType == 2) {
                date1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(day);
                validDate = true;
            } else {
                System.out.println("\nERRO: O formato da data introduzida está errada, utilize o formato dd-MM-aaaa HH:mm:ss ou aaaa-MM-dd HH:mm:ss!");
                System.out.println("\nPor favor, introduza uma nova data:");
            }
            Calendar calendar1 = Calendar.getInstance();
            calendar1.setTime(new Date(System.currentTimeMillis()));
            calendar1.add(Calendar.DAY_OF_MONTH, 30);
            Date date3 = calendar1.getTime();
            Calendar calendar2 = Calendar.getInstance();
            calendar2.setTime(new Date(System.currentTimeMillis()));
            calendar2.add(Calendar.SECOND, -1);
            Date date2 = calendar2.getTime();
            if (date1.before(date3) && date1.after(date2)) {
                validDate2 = true;
            } else {
                System.out.println("\nERRO: A data introduzida está errada, a data tem que estar no intervalo entre o momento de criação e 30 dias após este");
                System.out.println("\nPor favor, introduza uma nova data:");
            }
        }
        return date1;
    }

    public static int isValidDate(String d) {
        String regex = "[0-2][0-9]-[1][0-2]-[0-9]{4} [0-5][0-9]:[0-5][0-9]:[0-5][0-9]", regex2 = "[0-9]{4}-[1][0-2]-[0-2][0-9] [0-5][0-9]:[0-5][0-9]:[0-5][0-9]",
                regex3 = "[3][0-1]-[0][1-9]-[0-9]{4} [0-5][0-9]:[0-5][0-9]:[0-5][0-9]", regex4 = "[0-9]{4}-[0][1-9]-[3][0-1] [0-5][0-9]:[0-5][0-9]:[0-5][0-9]",
                regex5 = "[3][0-1]-[1][0-2]-[0-9]{4} [0-5][0-9]:[0-5][0-9]:[0-5][0-9]", regex6 = "[0-9]{4}-[1][0-2]-[3][0-1] [0-5][0-9]:[0-5][0-9]:[0-5][0-9]",
                regex7 = "[0-2][0-9]-[0][1-9]-[0-9]{4} [0-5][0-9]:[0-5][0-9]:[0-5][0-9]", regex8 = "[0-9]{4}-[0][1-9]-[0-2][0-9] [0-5][0-9]:[0-5][0-9]:[0-5][0-9]";
        Pattern pattern = Pattern.compile(regex), pattern2 = Pattern.compile(regex2), pattern3 = Pattern.compile(regex3), pattern4 = Pattern.compile(regex4),
                pattern5 = Pattern.compile(regex5), pattern6 = Pattern.compile(regex6), pattern7 = Pattern.compile(regex7), pattern8 = Pattern.compile(regex8);
        Matcher matcher = pattern.matcher(d), matcher2 = pattern2.matcher(d), matcher3 = pattern3.matcher(d), matcher4 = pattern4.matcher(d),
                matcher5 = pattern5.matcher(d), matcher6 = pattern6.matcher(d), matcher7 = pattern7.matcher(d), matcher8 = pattern8.matcher(d);
        if (matcher.matches() || matcher3.matches() || matcher5.matches() || matcher7.matches())
            return 1;
        else if (matcher2.matches() || matcher4.matches() || matcher6.matches() || matcher8.matches())
            return 2;
        else
            return 0;
    }

}