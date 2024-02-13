package Project.model.Analtytics;

import java.util.Objects;

public class BasketAnalysis {

    private int numberOfProductsTotallySatisfied;
    private int numberOfProductsNotSatisfied;
    private double satisfiedPercentage;
    private int numberOfProductors;

    public BasketAnalysis(int numberOfProductsTotallySatisfied, int numberOfProductsNotSatisfied, double satisfiedPercentage, int numberOfProductors) {
        this.numberOfProductsTotallySatisfied = numberOfProductsTotallySatisfied;
        this.numberOfProductsNotSatisfied = numberOfProductsNotSatisfied;
        this.satisfiedPercentage = satisfiedPercentage;
        this.numberOfProductors = numberOfProductors;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof BasketAnalysis)) return false;
        BasketAnalysis that = (BasketAnalysis) o;
        return numberOfProductsTotallySatisfied == that.numberOfProductsTotallySatisfied && numberOfProductsNotSatisfied == that.numberOfProductsNotSatisfied && Double.compare(that.satisfiedPercentage, satisfiedPercentage) == 0 && numberOfProductors == that.numberOfProductors;
    }

    @Override
    public int hashCode() {
        return Objects.hash(numberOfProductsTotallySatisfied, numberOfProductsNotSatisfied, satisfiedPercentage, numberOfProductors);
    }

    public int getNumberOfProductsTotallySatisfied() {
        return numberOfProductsTotallySatisfied;
    }

    public int getNumberOfProductsNotSatisfied() {
        return numberOfProductsNotSatisfied;
    }

    public double getSatisfiedPercentage() {
        return satisfiedPercentage;
    }

    public int getNumberOfProductors() {
        return numberOfProductors;
    }

    @Override
    public String toString() {
        return "Análise de Cabazes :" +
                "Número de produtos totalmente satisfeitos = " + numberOfProductsTotallySatisfied +
                "Número de produtos instatisfeitos =" + numberOfProductsNotSatisfied +
                "Percentagem de satisfação = " + satisfiedPercentage +
                "Número de Produtos = " + numberOfProductors;
    }
}
