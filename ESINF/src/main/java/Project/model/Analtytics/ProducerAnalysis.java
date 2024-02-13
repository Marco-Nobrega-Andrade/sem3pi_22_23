package Project.model.Analtytics;

import Project.model.Producer;

import java.util.Objects;

public class ProducerAnalysis {

    private Producer producer;
    private int numberOfProductsDepleted;
    private int numberOfBasketsFullySatisfied;
    private int getNumberOfBasketsPartiallySatisfied;
    private int numberOfClients;
    private int numberOfHubs;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ProducerAnalysis)) return false;
        ProducerAnalysis that = (ProducerAnalysis) o;
        return numberOfProductsDepleted == that.numberOfProductsDepleted && numberOfBasketsFullySatisfied == that.numberOfBasketsFullySatisfied && getNumberOfBasketsPartiallySatisfied == that.getNumberOfBasketsPartiallySatisfied && numberOfClients == that.numberOfClients && numberOfHubs == that.numberOfHubs && Objects.equals(producer, that.producer);
    }

    @Override
    public int hashCode() {
        return Objects.hash(producer, numberOfProductsDepleted, numberOfBasketsFullySatisfied, getNumberOfBasketsPartiallySatisfied, numberOfClients, numberOfHubs);
    }

    public ProducerAnalysis(Producer producer, int numberOfProductsDepleted, int numberOfBasketsFullySatisfied, int getNumberOfBasketsPartiallySatisfied, int numberOfClients, int numberOfHubs) {
        this.producer = producer;
        this.numberOfProductsDepleted = numberOfProductsDepleted;
        this.numberOfBasketsFullySatisfied = numberOfBasketsFullySatisfied;
        this.getNumberOfBasketsPartiallySatisfied = getNumberOfBasketsPartiallySatisfied;
        this.numberOfClients = numberOfClients;
        this.numberOfHubs = numberOfHubs;
    }

    public Producer getProducer() {
        return producer;
    }

    public int getNumberOfProductsDepleted() {
        return numberOfProductsDepleted;
    }

    public int getNumberOfBasketsFullySatisfied() {
        return numberOfBasketsFullySatisfied;
    }

    public int getGetNumberOfBasketsPartiallySatisfied() {
        return getNumberOfBasketsPartiallySatisfied;
    }

    public int getNumberOfClients() {
        return numberOfClients;
    }

    public int getNumberOfHubs() {
        return numberOfHubs;
    }
}
