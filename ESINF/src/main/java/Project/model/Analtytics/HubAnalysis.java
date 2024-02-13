package Project.model.Analtytics;

import Project.model.Company;

import java.util.Objects;

public class HubAnalysis {

    private Company company;
    private int numberOfClients;
    private int numberOfProducers;

    public HubAnalysis(Company company, int numberOfClients, int numberOfProducers) {
        this.company = company;
        this.numberOfClients = numberOfClients;
        this.numberOfProducers = numberOfProducers;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof HubAnalysis)) return false;
        HubAnalysis that = (HubAnalysis) o;
        return numberOfClients == that.numberOfClients && numberOfProducers == that.numberOfProducers && Objects.equals(company, that.company);
    }

    @Override
    public int hashCode() {
        return Objects.hash(company, numberOfClients, numberOfProducers);
    }

    public Company getCompany() {
        return company;
    }

    public int getNumberOfClients() {
        return numberOfClients;
    }

    public int getNumberOfProducers() {
        return numberOfProducers;
    }
}
