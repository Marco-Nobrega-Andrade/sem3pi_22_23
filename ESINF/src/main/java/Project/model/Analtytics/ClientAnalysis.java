package Project.model.Analtytics;

import Project.model.Buyer;

import java.util.Objects;

public class ClientAnalysis {

    private Buyer buyer;
    private int numberOfBasketsTotallySatisfied;
    private int numberOfBasketsPartiallySatisfied;
    private int numberOfDistintProductors;

    public ClientAnalysis(Buyer buyer, int numberOfBasketsTotallySatisfied, int numberOfBasketsPartiallySatisfied, int numberOfDistintProductors) {
        this.buyer = buyer;
        this.numberOfBasketsTotallySatisfied = numberOfBasketsTotallySatisfied;
        this.numberOfBasketsPartiallySatisfied = numberOfBasketsPartiallySatisfied;
        this.numberOfDistintProductors = numberOfDistintProductors;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ClientAnalysis)) return false;
        ClientAnalysis that = (ClientAnalysis) o;
        return numberOfBasketsTotallySatisfied == that.numberOfBasketsTotallySatisfied && numberOfBasketsPartiallySatisfied == that.numberOfBasketsPartiallySatisfied && numberOfDistintProductors == that.numberOfDistintProductors && Objects.equals(buyer, that.buyer);
    }

    public Buyer getBuyer() {
        return buyer;
    }

    public int getNumberOfBasketsTotallySatisfied() {
        return numberOfBasketsTotallySatisfied;
    }

    public int getNumberOfBasketsPartiallySatisfied() {
        return numberOfBasketsPartiallySatisfied;
    }

    public int getNumberOfDistintProductors() {
        return numberOfDistintProductors;
    }

    @Override
    public int hashCode() {
        return Objects.hash(buyer, numberOfBasketsTotallySatisfied, numberOfBasketsPartiallySatisfied, numberOfDistintProductors);
    }
}
