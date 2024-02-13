package Project.model;

import java.util.LinkedList;
import java.util.Objects;

public class Delivery {
    private LinkedList<DistributionNetworkMember> visitedVertices;
    private DistributionNetwork.Track deliveryRoute;


    public Delivery(LinkedList<DistributionNetworkMember> visitedVertices, DistributionNetwork.Track deliveryRoute) {
        this.visitedVertices = visitedVertices;
        this.deliveryRoute = deliveryRoute;
    }

    public LinkedList<DistributionNetworkMember> getVisitedVertices() {
        return visitedVertices;
    }

    public void setVisitedVertices(LinkedList<DistributionNetworkMember> visitedVertices) {
        this.visitedVertices = visitedVertices;
    }

    public DistributionNetwork.Track getDeliveryRoute() {
        return deliveryRoute;
    }

    public void setDeliveryRoute(DistributionNetwork.Track deliveryRoute) {
        this.deliveryRoute = deliveryRoute;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Delivery delivery = (Delivery) o;
        return Objects.equals(visitedVertices, delivery.visitedVertices) && Objects.equals(deliveryRoute, delivery.deliveryRoute);
    }

    @Override
    public int hashCode() {
        return Objects.hash(visitedVertices, deliveryRoute);
    }

    @Override
    public String toString() {
        return "Entrega: " +
                "pontos de passagem = " + visitedVertices +
                ", percurso de entrega = " + deliveryRoute;
    }
}
