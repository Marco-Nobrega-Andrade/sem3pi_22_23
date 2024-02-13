package Project.model.Analtytics;

import Project.model.*;

import java.util.*;

public class ShipmentsAnalysisAlgortihms {

    public static ArrayList<BasketAnalysis> basketAnalyticsPerShipmentList(List<Shipment> shipments, int day){

        int numberOfProductsTotallySatisfied;
        int numberOfProductsNotSatisfied;
        double satisfiedPercentage;
        int numberOfProductors;

        ArrayList<BasketAnalysis> listBasketAnalytics = new ArrayList<>();
        for (Shipment ship: shipments) {
            if (!ship.getProdutor().isEmpty()) {
                numberOfProductsTotallySatisfied = ship.getProduto().size();
                numberOfProductors = ship.getProdutor().entrySet().size();
                satisfiedPercentage = ( ((double)(numberOfProductsTotallySatisfied)/ship.getCliente().getOrderByDay().get(day).size())*100);
            }else{
                numberOfProductsTotallySatisfied = 0;
                numberOfProductors = 0;
                satisfiedPercentage = 0;
            }
            numberOfProductsNotSatisfied = (ship.getCliente().getOrderByDay().get(day).size() - ship.getProduto().size());
            listBasketAnalytics.add(new BasketAnalysis(numberOfProductsTotallySatisfied,
                    numberOfProductsNotSatisfied, satisfiedPercentage, numberOfProductors));

        }
        return listBasketAnalytics;
    }



    public static ArrayList<ClientAnalysis>  clientAnalyticsPerShipmentList(List<Shipment> shipments, int day, List<Buyer> buyers) {

        int numberOfBasketsTotallySatisfied;
        int numberOfBasketsPartiallySatisfied;
        Map<String,Producer> mapProducters;

        ArrayList<ClientAnalysis> listClientAnalysis = new ArrayList<>();


        for (Buyer b : buyers) {
            numberOfBasketsTotallySatisfied = 0;
            numberOfBasketsPartiallySatisfied = 0;
            mapProducters = new HashMap<>();
            for (Shipment ship : shipments) {
                if (ship.getCliente().equals(b)) {
                    if (!ship.getProdutor().isEmpty()) {
                        if ((ship.getCliente().getOrderByDay().get(day).size() - ship.getProduto().size()) == 0) {
                            numberOfBasketsTotallySatisfied++;
                            addProducer(ship, mapProducters);
                        } else {
                            numberOfBasketsPartiallySatisfied++;
                            addProducer(ship, mapProducters);
                        }
                    }
                }
            }
            listClientAnalysis.add(new ClientAnalysis(b,numberOfBasketsTotallySatisfied,numberOfBasketsPartiallySatisfied,mapProducters.entrySet().size()));
        }

        return listClientAnalysis;
    }

    private static Map<String,Producer> addProducer(Shipment ship, Map<String, Producer> mapProducters){

        for(Producer p: ship.getProdutor().values()) {
            mapProducters.putIfAbsent(p.getLocId(), p);
        }

        return mapProducters;
    }

    public static ArrayList<ProducerAnalysis>  producerAnalyticsPerShipmentList(List<Shipment> shipments,int day) {

        Map<String,Producer> mapProducer = new HashMap<>();

        Map<String,Buyer> mapBuyer;

        Map<String, Company> mapHub;

        int numberOfProductsDepleted;
        int numberOfBasketsFullySatisfied;
        int numberOfBasketsPartiallySatisfied;

        ArrayList<ProducerAnalysis> listProducerAnalysis = new ArrayList<>();

        for (Shipment ship : shipments) {
            addProducer(ship, mapProducer);
        }

        for(Producer prod: mapProducer.values()){

            mapHub = new HashMap<>();
            mapBuyer = new HashMap<>();

            numberOfProductsDepleted = numberOfDepletedProducts(prod,day);
            numberOfBasketsFullySatisfied = 0;
            numberOfBasketsPartiallySatisfied =0;
            for (Shipment ship : shipments){
                if (ship.getProdutor().get(prod.getLocId())!=null){
                    if (ship.getProdutor().entrySet().size() == 1 && (ship.getCliente().getOrderByDay().get(day).size() - ship.getProduto().size()) == 0){
                        numberOfBasketsFullySatisfied++;
                    }else{
                        numberOfBasketsPartiallySatisfied++;
                    }

                    mapBuyer.computeIfAbsent(ship.getCliente().getLocId(), k -> ship.getCliente());
                    mapHub.computeIfAbsent(ship.getHub().getLocId(), k -> ship.getHub());
                }
            }
            listProducerAnalysis.add(new ProducerAnalysis(prod,numberOfProductsDepleted,numberOfBasketsFullySatisfied,numberOfBasketsPartiallySatisfied,mapBuyer.entrySet().size(),mapHub.entrySet().size()));
        }

        return listProducerAnalysis;
    }


    private static int numberOfDepletedProducts(Producer prod, int day){

        boolean depleted;
        int numberDepleted = 0;
        Collection<ArrayList<Product>> values = prod.getOrderByDay().get(day).values();
        for (ArrayList<Product> id : values){
            depleted= false;
            for (int i = id.size()-1; i>=0; i--) {
                if (id.get(i).getQuantity() == 0){
                    depleted = true;
                }else{
                    depleted =false;
                }
            }
            if (depleted){
                numberDepleted++;
            }
        }

        return numberDepleted;
    }

    public static ArrayList<HubAnalysis> hubAnalyticsPerShipmentList(List<Shipment> shipments) {

        Map<String,Company> mapHub = new HashMap<>();
        Map<String,Buyer> mapBuyer;
        Map<String,Producer> mapProducer;
        ArrayList<HubAnalysis> listHubAnalysis = new ArrayList<>();

        for (Shipment s: shipments) {
            mapHub.computeIfAbsent(s.getHub().getLocId(), k-> s.getHub());
        }

        for (Company hub: mapHub.values()){
            mapBuyer = new HashMap<>();
            mapProducer = new HashMap<>();
            for (Shipment ship: shipments) {
               if (ship.getHub().equals(hub)) {
                   mapBuyer.computeIfAbsent(ship.getCliente().getLocId(), k -> ship.getCliente());
                   addProducer(ship, mapProducer);
               }
            }
            listHubAnalysis.add(new HubAnalysis(hub,mapBuyer.entrySet().size(),mapProducer.entrySet().size()));
        }


        return listHubAnalysis;
    }

}
