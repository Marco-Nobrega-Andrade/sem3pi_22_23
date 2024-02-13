package Project.model;

import java.util.Objects;

public class Product {
    private int id;
    private Double quantity;
    private int daysLeft;

    public Product(int id, Double quantity) {
        this.id = id;
        this.quantity = quantity;
        this.daysLeft = 3;
    }

    public int getId() {
        return id;
    }

    public Double getQuantity() {
        return quantity;
    }

    public int getDaysLeft() {
        return daysLeft;
    }
    public void decreaseDaysLeft(){
        this.daysLeft = daysLeft - 1;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Product product)) return false;
        return id == product.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    public void setQuantity(double q) {
        this.quantity = q;
    }

    @Override
    public String toString() {
        return "id = " + id;
    }
}
