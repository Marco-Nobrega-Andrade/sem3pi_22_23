package Project.model;

import Project.graph.Algorithms;
import Project.graph.Graph;
import Project.graph.map.MapGraph;
import Project.model.Analtytics.*;

import java.util.*;
import java.util.function.BinaryOperator;

public class DistributionNetwork {
    private Graph<DistributionNetworkMember, Track> network;

    private List<DistributionNetworkMember> hubs;

    private Map<String, Integer> keyMemberId = new HashMap<>();
    //             Map<Day, Map<ProductID, producers>>
    private Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders;
    //              Map<Day, ArrayList<Buyers>>
    private Map<Integer, ArrayList<Buyer>> buyersWithOrders;

    private Map<Integer, List<Shipment>> shipmentListOrderByDayWithoutRestrictions = new HashMap<>();

    private Map<Integer, List<Shipment>> shipmentListOrderByDayWithRestrictions = new HashMap<>();


    public Graph<DistributionNetworkMember, Track> getNetwork() {
        return network;
    }

    public Map<Integer, Map<Integer, ArrayList<Producer>>> getProducersWithOrders() {
        return producersWithOrders;
    }

    public Map<Integer, ArrayList<Buyer>> getBuyersWithOrders() {
        return buyersWithOrders;
    }


    public static class Track {

        private final double miles;
        public Track(double miles) {
            this.miles = miles;
        }

        public double getMiles() {
            return miles;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            Track track = (Track) o;
            return Double.compare(track.miles, miles) == 0;
        }

        @Override
        public int hashCode() {
            return Objects.hash(miles);
        }

        @Override
        public String toString() {
            return "Caminho: " +
                    miles + "m";
        }

    }

    private final BinaryOperator<Track> binaryOperator = new BinaryOperator<Track>() {
        @Override
        public Track apply(Track track, Track track2) {
            return new Track(track.getMiles() + track2.getMiles());
        }
    };

    private final Comparator<Track> trackComparator = new Comparator<Track>() {
        @Override
        public int compare(Track t1, Track t2) {
            return Double.compare(t1.getMiles(), t2.getMiles());
        }
    };

    private final Track zero = new Track(0);



    public boolean testHubsExistence(){
        if(hubs == null) return false;
        return true;
    }

    public DistributionNetwork() {
        this.network = new MapGraph<>(false);
    }

    public void setProducersWithOrders(Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders) {
        this.producersWithOrders=producersWithOrders;
    }

    public boolean integralGraphCheck(List<DistributionNetworkMember> verticesList, List<List<DistributionNetworkMember>> edgesList) {
        return checkGraphVertices(verticesList) & checkGraphEdges(edgesList);
    }

    public boolean checkGraphVertices(List<DistributionNetworkMember> verticesList) {
        Graph<DistributionNetworkMember, Track> clonedGraph = network.clone();
        for (DistributionNetworkMember distributionNetworkMember : verticesList) {
            clonedGraph.removeVertex(distributionNetworkMember);
        }
        if (clonedGraph.vertices().isEmpty()) return true;
        return false;
    }

    public boolean checkGraphEdges(List<List<DistributionNetworkMember>> edgesList) {
        Graph<DistributionNetworkMember, Track> clonedGraph = network.clone();
        for (List<DistributionNetworkMember> edge : edgesList) {
            clonedGraph.removeEdge(edge.get(0), edge.get(1));
            clonedGraph.removeEdge(edge.get(1), edge.get(0));
        }
        if (clonedGraph.edges().isEmpty()) return true;
        return false;
    }

    public void loadGraph(List<String> membersInfo, List<String> trackInfo) {
        network = new MapGraph<>(false);
        insertVertices(membersInfo);
        insertEdges(trackInfo);
    }

    public int loadBaskets(List<String> basketsInfo) {
        producersWithOrders = new HashMap<>();
        buyersWithOrders = new HashMap<>();
        int successfulLines = 0;
        ArrayList<Product> listProduct;
        for (String s : basketsInfo) {
            String[] values = s.split(",");
            if (s.charAt(2) != 'l' & s.charAt(1) != 'l') {
                if (values[0].charAt(0) == '"') {
                    values[0] = values[0].replace("\"", "");
                }
                int day = Integer.parseInt(values[1]);
                try {
                    int vKey = keyMemberId.get(values[0]); // obter a key do vértice através do Loc id
                    listProduct = new ArrayList<>();
                    for (int i = 2; i < values.length; i++) {
                        if (Double.parseDouble(values[i]) != 0) {
                            //inserção de cabazes se forem produtores
                            if (values[0].charAt(0) == 'P') {
                                // inserção no producersWithOrders------------------------------------------------------
                                //check se já existe o dia no map
                                if (!producersWithOrders.containsKey(day)) {
                                    producersWithOrders.put(day, new HashMap<>());
                                }
                                //check se já existe o tipo de produto nesse dia
                                if (!producersWithOrders.get(day).containsKey(i - 1)) {
                                    producersWithOrders.get(day).put(i - 1, new ArrayList<>());
                                }
                                producersWithOrders.get(day).get(i - 1).add((Producer) network.vertex(vKey));
                                Producer producer = (Producer) network.vertex(vKey);
                                // inserção no getOrderByDay do produtor------------------------------------------------------
                                //check se já existe o dia no map
                                if (!producer.getOrderByDay().containsKey(day)) {
                                    producer.getOrderByDay().put(day, new HashMap<>());
                                }
                                //adicionar o produto ao getOrderByDay
                                producer.getOrderByDay().get(day).put(i - 1, new ArrayList<>());
                                producer.getOrderByDay().get(day).get(i - 1).add(new Product(i - 1, Double.parseDouble(values[i])));
                            }
                            listProduct.add(new Product(i - 1, Double.parseDouble(values[i])));
                        }
                    }
                    //inserção de cabazes se forem compradores
                    if (values[0].charAt(0) != 'P' && !listProduct.isEmpty()) {
                        // inserção em buyersWithOrders------------------------------------------------------
                        if (!buyersWithOrders.containsKey(day)) {
                            buyersWithOrders.put(day, new ArrayList<>());
                        }
                        buyersWithOrders.get(day).add((Buyer) network.vertex(vKey));
                        // inserção no getOrderByDay do comprador------------------------------------------------------
                        Buyer buyer = (Buyer) network.vertex(vKey);
                        buyer.getOrderByDay().put(day, listProduct);
                    }
                    successfulLines++;
                } catch (NullPointerException ignored) {
                }
            }
        }
        return successfulLines;
    }

    private void insertVertices(List<String> membersInfo) {
        int counter = 0;
        for (String s : membersInfo) {
            String[] values = s.split(",");
            if (s.charAt(0) != 'L') {
                if (values[3].charAt(0) == 'C')
                    network.addVertex(new Client(values[0], Double.parseDouble(values[1]), Double.parseDouble(values[2]), values[3]));
                else if (values[3].charAt(0) == 'E')
                    network.addVertex(new Company(values[0], Double.parseDouble(values[1]), Double.parseDouble(values[2]), values[3]));
                else
                    network.addVertex(new Producer(values[0], Double.parseDouble(values[1]), Double.parseDouble(values[2]), values[3]));
                keyMemberId.put(values[3], counter);
                counter++;
            }
        }
    }

    private void insertEdges(List<String> trackInfo) {
        for (String s : trackInfo) {
            String[] values = s.split(",");
            if (s.charAt(0) != 'L')
                network.addEdge(new DistributionNetworkMember(values[0]), new DistributionNetworkMember(values[1]), new Track(Double.parseDouble(values[2])));
        }
    }

    public int isConex() {
        boolean isConex = Algorithms.isConnected(network);
        if (!isConex) {
            return -1;
        }
        ArrayList<Integer> shortestpath = new ArrayList<>();
        for (int i = 0; i < network.vertices().size() - 1; i++) {
            for (int j = i + 1; j < network.vertices().size(); j++) {
                shortestpath.add(Algorithms.minEdgeBFS(network, network.vertices().get(i), network.vertices().get(j)));
            }
        }
        int diameter = Integer.MIN_VALUE;
        for (int g = 0; g < shortestpath.size(); g++) {
            if (shortestpath.get(g) > diameter) diameter = shortestpath.get(g);
        }
        return diameter;
    }

    public Graph<DistributionNetworkMember, Track> minimumSpanningNetwork() {
        return Algorithms.minimumSpanningTreeKruskal(network, trackComparator);
    }

    public Map<DistributionNetworkMember, DistributionNetworkMember> getClosestHub() {
        LinkedList<DistributionNetworkMember> shortPath = new LinkedList<>();
        double size;
        Map<DistributionNetworkMember, DistributionNetworkMember> closestHub = new HashMap<>();
        for (DistributionNetworkMember v : network.vertices()) {
            double min = Double.MAX_VALUE;
            DistributionNetworkMember vMin = null;
            if (!hubs.contains(v)) {
                for (DistributionNetworkMember hub : hubs) {
                    Track shortPathEdge = Algorithms.shortestPath(network, v, hub, trackComparator, binaryOperator, zero, shortPath);
                    if (shortPathEdge != null) {
                        size = shortPathEdge.getMiles();
                        if (size < min) {
                            min = size;
                            vMin = hub;
                        }
                        closestHub.put(v, vMin);
                    }
                }
            }
        }
        if (closestHub.isEmpty()) {
            return null;
        } else {
            return closestHub;
        }
    }

    public List<DistributionNetworkMember> defineHubs(int n) {
        hubs = new ArrayList<>();
        if (n <= 0) {
            return null;
        }

        ArrayList<DistributionNetworkMember> vOrigins = new ArrayList<>();
        ArrayList<LinkedList<DistributionNetworkMember>> paths = new ArrayList<>();
        ArrayList<Track> dists = new ArrayList<>();
        for (DistributionNetworkMember v : network.vertices()) {
            if (v instanceof Company) {
                vOrigins.add(v);
            }
        }

        ArrayList<Double> results = new ArrayList<>();
        double proximidade = 0;
        double shortPath = 0;
        int num = 0;
        int k = 0;
        ArrayList<Integer> remove = new ArrayList<>();
        for (DistributionNetworkMember vOrigin : vOrigins) {

            if (Algorithms.shortestPaths(network, vOrigin, trackComparator, binaryOperator, zero, paths, dists)) {
                for (int i = 0; i < dists.size(); i++) {
                    if (dists.get(i) != null) {
                        shortPath = dists.get(i).getMiles();
                        proximidade = proximidade + shortPath;
                        if (shortPath != 0) {
                            num++;
                        }
                    }
                }

                if (num != 0) {
                    proximidade = proximidade / num;
                    results.add(proximidade);
                } else {
                    remove.add(k);
                }
                num = 0;
                proximidade = 0;

            }
            k++;
        }

        for (int i = 0; i < remove.size(); i++) {
            k = remove.get(i);
            vOrigins.remove(k);
        }

        double temp = 0;
        DistributionNetworkMember tempCompany;

        for (int i = 0; i < results.size(); i++) {
            for (int j = i; j < results.size(); j++) {
                if (results.get(i) > results.get(j)) {
                    temp = results.get(i);
                    results.set(i, results.get(j));
                    results.set(j, temp);
                    tempCompany = vOrigins.get(i);
                    vOrigins.set(i, vOrigins.get(j));
                    vOrigins.set(j, tempCompany);
                }
            }
        }
        if (n > vOrigins.size()) {
            n = vOrigins.size();
        }
        for (int i = 0; i < n; i++) {
            hubs.add(vOrigins.get(i));
        }

        return hubs;
    }

    private List<Shipment> generateShipmentList(int day, Map<Integer, ArrayList<Buyer>> buyersWithOrders,
                                               Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders) {

            List<Shipment> shipmentList = new ArrayList<>();
            Company closestHub;
            for (Buyer client : buyersWithOrders.get(day)) {
                closestHub = findNearestHub(client);
                Shipment s = new Shipment(client, closestHub);
                shipmentList.add(s);
                ArrayList<Product> clientOrder = client.getOrderByDay().get(day);
                boolean found = false;
                for (Product clientProduct : clientOrder) {
                    if (found) {
                        found = false;
                    }
                    ArrayList<Producer> producers = producersWithOrders.get(day).get(clientProduct.getId());
                    if (producers != null) {
                        for (Producer producer : producersWithOrders.get(day).get(clientProduct.getId())) {
                            if (found) continue;
                            ArrayList<Product> producerProduction = new ArrayList<>();
                            try {
                                producerProduction = producer.getOrderByDay().get(day).get(clientProduct.getId());
                            }catch (Exception e){
                            }
                            if(producerProduction!=null) {
                                for (int j = producerProduction.size() - 1; j >= 0; j--) {
                                    if (found) continue;
                                    Product producerProduct = producerProduction.get(j);
                                    if (producerProduct != null) {
                                        if (producerProduct.getQuantity() >= clientProduct.getQuantity()) {
                                            s.addProducer(producer);
                                            s.addQuantity(clientProduct.getQuantity());
                                            s.addProduct(clientProduct);
                                            found = true;
                                            producer.subtractFromOrderByDay(producerProduct, clientProduct.getQuantity(), day, j);
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
            }
            shipmentListOrderByDayWithoutRestrictions.put(day,shipmentList);

        return shipmentList;
    }

    private Company findNearestHub(Buyer client){

        ArrayList<LinkedList<DistributionNetworkMember>> paths = new ArrayList<>();
        ArrayList<Track> edges = new ArrayList<>();
        Double minDist = Double.MAX_VALUE;
        Company closestHub = null;

        if (Algorithms.shortestPaths(network, client, trackComparator, binaryOperator, zero, paths, edges)){
            for (DistributionNetworkMember hub : hubs){
                int key = network.key(hub);
                if(edges.get(key).getMiles() < minDist){
                    minDist = edges.get(key).getMiles();
                    closestHub = (Company) hub;
                }
            }
        }

        return closestHub;
    }

    /**
     * Algoritmo de Dijkstra que devolve uma lista com os N produtores mais próximos de um dado hub para um determinado dia
     *
     * @param hub            Information of the Vertex that represents the hub
     * @param n              Number of producers to find
     * @param day            Day to find the producers
     * @param product        Product to find the producers
     * @return List of producers
     */

    private List<Producer> findNearestProducers(DistributionNetworkMember hub, int n, int day, Product product, Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders ) {

        List<Producer> producers = new ArrayList<>();

        //ALL: Implementar o algoritmo de Dijkstra para encontrar os N produtores mais próximos de um dado hub para um determinado dia
        if (product!=null) {
            if (producersWithOrders.get(day)!=null&&producersWithOrders.get(day).get(product.getId())!=null){
                ArrayList<Producer> vOrigins = producersWithOrders.get(day).get(product.getId());
                Map<Double,Producer> mapMilesByProducer = new HashMap<>();
                ArrayList<Double> miles = new ArrayList<>();

                ArrayList<LinkedList<DistributionNetworkMember>> paths = new ArrayList<>();
                ArrayList<Track> dists = new ArrayList<>();

                if (Algorithms.shortestPaths(network, hub,trackComparator,binaryOperator,zero, paths, dists)) {
                    for (Producer vOrig: vOrigins){
                        int key = network.key(vOrig);
                        mapMilesByProducer.put(dists.get(key).getMiles(),vOrig);
                        miles.add(dists.get(key).getMiles());
                    }
                }
                Collections.sort(miles);

                if (n>miles.size()) n=miles.size();

                for (int i = 0; i < n; i++) {
                    producers.add(mapMilesByProducer.get(miles.get(i)));
                }
                return producers;
            } else {
                return null;
            }
        }
        return null;
    }

    private List<Shipment> generateShipmentList(int day, int n, Map<Integer, ArrayList<Buyer>> buyersWithOrders, Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders) {

        /*Retornar null se o número de produtores for menor ou igual a 0*/

        if (n <= 0) {
            throw new IllegalArgumentException("O número de produtores tem de ser maior que 0");
        }

        /* Retornar null se não existirem hubs definidos no sistema */

        if (hubs.size() == 0) {
            throw new IllegalArgumentException("Não existem hubs definidos no sistema");
        }

        boolean flag = false;
        /*Declarar e inicializar a lista de expedições*/

        List<Shipment> shippingList = new ArrayList<>();


        /*Declarar e inicializar as listas com os dados necessários para criar um Shipment(expedição)*/

        Map<String, Producer> produtor = new HashMap<>();
        List<Double> qntyExpedido = new ArrayList<>();
        List<Product> produto = new ArrayList<>();

        /*Declarar e inicializar a lista que armazena todos os clientes e empresas no grafo */

        ArrayList<Buyer> clientes = buyersWithOrders.get(day);

        /*Iterar a lista de clientes no grafo*/

        if (clientes != null) {
            for (Buyer member : clientes) {

                ArrayList<Product> products = member.getOrderByDay().get(day);

                /* Obtemos o hub mais próximo para o cliente em especifico */

                Company hub = findNearestHub(member);

                for (Product product : products) {
                    flag = false;
                    /* Obtemos os N produtores mais próximos para o hub obtido */

                    List<Producer> closestProducers = findNearestProducers(hub, n, day, product, producersWithOrders);

                    // Itera-se a lista dos N produtores mais próximos ao hub
                    if (closestProducers != null) {
                        for (Producer producer : closestProducers) {
                            // Obtemos a lista de produtos do produtor para o dia em especifico
                            List<Product> productsForDayOfProducer = producer.getOrderByDay().get(day).get(product.getId());

                        /* Iteramos a lista de produtos dos clientes por cada iteração da lista de produtos do produtor e verificamos
                        se possuem o mesmo produto, caso sim, verifica-se então se o produtor pode suplir ao cliente, cujo caso é adicionado
                        às listas os dados para criação de um Shipment */

                            if (productsForDayOfProducer != null) {
                                for (int i = productsForDayOfProducer.size() - 1; i >= 0; i--) {
                                    Product prodProducer = productsForDayOfProducer.get(i);
                                    if (product.getQuantity() <= prodProducer.getQuantity()) {
                                        produto.add(product);
                                        produtor.putIfAbsent(producer.getLocId(), producer);
                                        qntyExpedido.add(product.getQuantity());
                                        // Restamos a quantidade do produto vendido do produtor
                                        producer.subtractFromOrderByDay(prodProducer, product.getQuantity(), day, i);
                                        flag = true;
                                        break;
                                    }
                                }
                                if (flag) {
                                    break;
                                }
                            }
                        }
                    }
                }
                shippingList.add(new Shipment(member, hub, produtor, qntyExpedido, produto));
                produto = new ArrayList<>();
                produtor = new HashMap<>();
                qntyExpedido = new ArrayList<>();
            }
            shipmentListOrderByDayWithRestrictions.put(day, shippingList);
            return shippingList;
        }
        throw new IllegalArgumentException("Não existem clientes com encomendas para o dia " + day + " definidos no sistema");
    }

    private Map<Integer, Map<Integer, ArrayList<Producer>>> addLeftOver(int day, Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders) {

        //create a map that has the products of the next day and the left over products of the current day
        Map<Integer, ArrayList<Producer>> leftOver = new HashMap<>();
        Map<Integer, ArrayList<Producer>> producersWithOrdersOfNextDay = producersWithOrders.get(day+1);
        Map<Integer, ArrayList<Producer>> producersWithOrdersOfCurrentDay = producersWithOrders.get(day);

        if (producersWithOrdersOfNextDay!=null) {
            for (Map.Entry<Integer, ArrayList<Producer>> entry : producersWithOrdersOfCurrentDay.entrySet()) {
                ArrayList<Producer> producers = entry.getValue();
                ArrayList<Producer> producersOfCurrentDay = new ArrayList<>();

                for (Map.Entry<Integer, ArrayList<Producer>> entry2 : producersWithOrdersOfNextDay.entrySet()) {
                    if (entry.getKey().equals(entry2.getKey())) {
                        ArrayList<Producer> producers1 = entry2.getValue();
                        producersOfCurrentDay.addAll(producers1);
                        break;
                    }
                }

                for (Producer producer : producers) {
                    ArrayList<Product> products = producer.getOrderByDay().get(day).get(entry.getKey());
                    for (Product product : products) {
                        product.decreaseDaysLeft();
                        if (product.getQuantity() > 0 && product.getDaysLeft() > 0) {

                            try {
                                if (producer.getOrderByDay().get(day + 1).get(product.getId()) != null) {
                                    producer.getOrderByDay().get(day + 1).get(product.getId()).add(product);
                                } else {
                                    ArrayList<Product> produtos = new ArrayList<>();
                                    produtos.add(product);
                                    producer.getOrderByDay().get(day + 1).put(product.getId(), produtos);
                                }

                                if (!producersOfCurrentDay.contains(producer)) {
                                    producersOfCurrentDay.add(producer);
                                }
                            }catch(Exception e){

                            }
                        }

                    }
                }
                leftOver.put(entry.getKey(), producersOfCurrentDay);
            }

            producersWithOrders.replace(day+1,leftOver);
            return producersWithOrders;
        }

        return null;
    }

    public List<Shipment> generateShipmentList(int days, int n) {

        if(!producersWithOrders.containsKey(days)) return null;

        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = new HashMap<>(this.producersWithOrders);
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>(this.buyersWithOrders);

        for (int i = 1; i < days; i++) {
            generateShipmentList(i,n,buyersWithOrders,producersWithOrders);
            producersWithOrders = addLeftOver(i,producersWithOrders);
        }
        return generateShipmentList(days,n,buyersWithOrders,producersWithOrders);
    }

    public List<Shipment> generateShipmentList(int day) {

        if(!producersWithOrders.containsKey(day)) return null;

        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = new HashMap<>(this.producersWithOrders);
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>(this.buyersWithOrders);

        for (int i = 1; i < day; i++) {
            generateShipmentList(i,buyersWithOrders,producersWithOrders);
            if(addLeftOver(i,producersWithOrders)!=null)producersWithOrders = addLeftOver(i,producersWithOrders);
        }
        return generateShipmentList(day,buyersWithOrders,producersWithOrders);

    }

    /**
     * Decides which expedition list to use (Used for interface purposes)
     * @param day from what day the expedition list will be used
     * @param option which expedition list will be used (1 if it is the list without restrictions, 2 otherwise)
     * @return each route associated with each respective shipment
     */
    public Map<Shipment,ArrayList<Delivery>> generateDeliveryRoutes(int day, int option){
        if (option == 1){
            return generateDeliveryRoutesWithShipmentList(shipmentListOrderByDayWithoutRestrictions.get(day));
        }else{
            return generateDeliveryRoutesWithShipmentList(shipmentListOrderByDayWithRestrictions.get(day));
        }

    }

    /**
     * Generates all the routes for the expedition list
     * @param shipmentList the expedition list to generate the routes
     * @return each route associated with each respective shipment
     */
    private Map<Shipment,ArrayList<Delivery>> generateDeliveryRoutesWithShipmentList(List<Shipment> shipmentList){
        if (shipmentList == null){
            return null;
        }

        Map<Shipment,ArrayList<Delivery>> finalRoutes = new HashMap<>();

        for (Shipment shipment : shipmentList) {
            ArrayList<Delivery> shipmentRoutes = new ArrayList<>();

            ArrayList<LinkedList<DistributionNetworkMember>> paths = new ArrayList<>();
            ArrayList<Track> dists = new ArrayList<>();
            Algorithms.shortestPaths(network,shipment.getHub(),trackComparator,binaryOperator,zero,paths,dists);

            for (Producer producer : shipment.getProdutor().values()){
                LinkedList<DistributionNetworkMember> path = paths.get(network.key(producer));
                Collections.reverse(path);
                shipmentRoutes.add(new Delivery(path,dists.get(network.key(producer))));
            }
            finalRoutes.put(shipment,shipmentRoutes);
        }

        return finalRoutes;
    }

    public ShipmentAnalysis generateAnalysis(int option, int day){

        List<Shipment> shipment;
        if (option == 1){
            shipment = shipmentListOrderByDayWithoutRestrictions.get(day);
        }else{
            shipment = shipmentListOrderByDayWithRestrictions.get(day);
        }

        if (shipment !=null){
            ArrayList<BasketAnalysis> listBasketAnalytics = ShipmentsAnalysisAlgortihms.basketAnalyticsPerShipmentList(shipment,day);
            ArrayList<ClientAnalysis> listClientAnalytics = ShipmentsAnalysisAlgortihms.clientAnalyticsPerShipmentList(shipment,day,buyersWithOrders.get(day));
            ArrayList<ProducerAnalysis> listProducerAnalysis = ShipmentsAnalysisAlgortihms.producerAnalyticsPerShipmentList(shipment,day);
            ArrayList<HubAnalysis> listHubAnalysis = ShipmentsAnalysisAlgortihms.hubAnalyticsPerShipmentList(shipment);

            return new ShipmentAnalysis(listBasketAnalytics,listClientAnalytics,listProducerAnalysis,listHubAnalysis);
        }
        return  null;
    }
}
