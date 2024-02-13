package Project.model.Analtytics;

import java.util.ArrayList;
import java.util.Objects;

public class ShipmentAnalysis {

    ArrayList<BasketAnalysis> listBasketAnalytics;
    ArrayList<ClientAnalysis> listClientAnalytics;
    ArrayList<ProducerAnalysis> listProducerAnalysis;
    ArrayList<HubAnalysis> listHubAnalysis;

    public ShipmentAnalysis(ArrayList<BasketAnalysis> listBasketAnalytics, ArrayList<ClientAnalysis> listClientAnalytics, ArrayList<ProducerAnalysis> listProducerAnalysis, ArrayList<HubAnalysis> listHubAnalysis) {
        this.listBasketAnalytics = listBasketAnalytics;
        this.listClientAnalytics = listClientAnalytics;
        this.listProducerAnalysis = listProducerAnalysis;
        this.listHubAnalysis = listHubAnalysis;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ShipmentAnalysis)) return false;
        ShipmentAnalysis that = (ShipmentAnalysis) o;
        return Objects.equals(listBasketAnalytics, that.listBasketAnalytics) && Objects.equals(listClientAnalytics, that.listClientAnalytics) && Objects.equals(listProducerAnalysis, that.listProducerAnalysis) && Objects.equals(listHubAnalysis, that.listHubAnalysis);
    }

    @Override
    public int hashCode() {
        return Objects.hash(listBasketAnalytics, listClientAnalytics, listProducerAnalysis, listHubAnalysis);
    }

    public ArrayList<BasketAnalysis> getListBasketAnalytics() {
        return listBasketAnalytics;
    }

    public ArrayList<ClientAnalysis> getListClientAnalytics() {
        return listClientAnalytics;
    }

    public ArrayList<ProducerAnalysis> getListProducerAnalysis() {
        return listProducerAnalysis;
    }

    public ArrayList<HubAnalysis> getListHubAnalysis() {
        return listHubAnalysis;
    }
}
