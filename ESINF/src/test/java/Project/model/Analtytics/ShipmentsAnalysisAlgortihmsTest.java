package Project.model.Analtytics;

import Project.model.*;
import org.junit.jupiter.api.Test;

import java.util.*;

import static org.junit.jupiter.api.Assertions.assertEquals;

class ShipmentsAnalysisAlgortihmsTest {

    @Test
    void basketAnalyticsPerShipmentList() {
        ArrayList<Shipment> shipments = new ArrayList<>();

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 0.0))));

        producer1.getOrderByDay().put(1, order1);

        Map<String, Producer> produtor1 = new HashMap<>();

        produtor1.put("CT1", producer1);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));

        //Obtenção dos shipments

        Company hub1 = new Company("CT2", 38.0333, -7.8833,"E1");
        Company hub2 = new Company("CT5", 41.3002, -7.7398,"E2");

        //Geração de um shipment
        shipments.add(new Shipment(buyer1,hub2,produtor1, List.of(3.0),Arrays.asList(new Product( 2, 3.0))));
        shipments.add(new Shipment(buyer2,hub1,new HashMap<>(), new ArrayList<>(), new ArrayList<>()));

        ArrayList<BasketAnalysis> test = ShipmentsAnalysisAlgortihms.basketAnalyticsPerShipmentList(shipments,1);

        BasketAnalysis b1= new BasketAnalysis(1,1,50.0,1);
        BasketAnalysis b2= new BasketAnalysis(0,1,0,0);

        ArrayList<BasketAnalysis> expected = new ArrayList<>();
        expected.add(b1);
        expected.add(b2);

        assertEquals(test,expected);
    }

    @Test
    void clientAnalyticsPerShipmentList() {

        ArrayList<Shipment> shipments = new ArrayList<>();

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 0.0))));

        producer1.getOrderByDay().put(1, order1);

        Map<String, Producer> produtor1 = new HashMap<>();

        produtor1.put("CT1", producer1);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));


        //Obtenção dos shipments

        Company hub1 = new Company("CT2", 38.0333, -7.8833,"E1");
        Company hub2 = new Company("CT5", 41.3002, -7.7398,"E2");

        //Geração de um shipment
        shipments.add(new Shipment(buyer1,hub2,produtor1, List.of(3.0),Arrays.asList(new Product( 2, 3.0))));
        shipments.add(new Shipment(buyer2,hub1,new HashMap<>(), new ArrayList<>(), new ArrayList<>()));

        ArrayList<ClientAnalysis> test = ShipmentsAnalysisAlgortihms.clientAnalyticsPerShipmentList(shipments,1,buyersWithOrders.get(1));

        ClientAnalysis c1= new ClientAnalysis(buyer1,0,1,1);
        ClientAnalysis c2= new ClientAnalysis(buyer2,0,0,0);

        ArrayList<ClientAnalysis> expected = new ArrayList<>();
        expected.add(c1);
        expected.add(c2);

        assertEquals(expected,test);
    }

    @Test
    void producerAnalyticsPerShipmentList() {
        ArrayList<Shipment> shipments = new ArrayList<>();

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 0.0))));

        producer1.getOrderByDay().put(1, order1);

        Map<String, Producer> produtor1 = new HashMap<>();

        produtor1.put("CT1", producer1);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));


        //Obtenção dos shipments

        Company hub1 = new Company("CT2", 38.0333, -7.8833,"E1");
        Company hub2 = new Company("CT5", 41.3002, -7.7398,"E2");

        //Geração de um shipment
        shipments.add(new Shipment(buyer1,hub2,produtor1, List.of(3.0),Arrays.asList(new Product( 2, 3.0))));
        shipments.add(new Shipment(buyer2,hub1,new HashMap<>(), new ArrayList<>(), new ArrayList<>()));

        ArrayList<ProducerAnalysis> test = ShipmentsAnalysisAlgortihms.producerAnalyticsPerShipmentList(shipments,1);

        ArrayList<ProducerAnalysis> expected = new ArrayList<>();

        ProducerAnalysis p1 = new ProducerAnalysis(producer1,1,0,1,1,1);

        expected.add(p1);
        assertEquals(test,expected);
    }

    @Test
    void hubAnalyticsPerShipmentList() {ArrayList<Shipment> shipments = new ArrayList<>();

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 0.0))));

        producer1.getOrderByDay().put(1, order1);

        Map<String, Producer> produtor1 = new HashMap<>();

        produtor1.put("CT1", producer1);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));


        //Obtenção dos shipments

        Company hub1 = new Company("CT2", 38.0333, -7.8833,"E1");
        Company hub2 = new Company("CT5", 41.3002, -7.7398,"E2");

        //Geração de um shipment
        shipments.add(new Shipment(buyer1,hub1,produtor1, List.of(3.0),Arrays.asList(new Product( 2, 3.0))));
        shipments.add(new Shipment(buyer2,hub2,new HashMap<>(), new ArrayList<>(), new ArrayList<>()));

        ArrayList<HubAnalysis> test = ShipmentsAnalysisAlgortihms.hubAnalyticsPerShipmentList(shipments);

        ArrayList<HubAnalysis> expected = new ArrayList<>();

        HubAnalysis h1 = new HubAnalysis(hub1,1,1);
        HubAnalysis h2 = new HubAnalysis(hub2,1,0);

        expected.add(h1);
        expected.add(h2);
        assertEquals(test,expected);
    }
}