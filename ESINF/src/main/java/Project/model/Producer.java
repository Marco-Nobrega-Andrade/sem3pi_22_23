package Project.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class Producer extends DistributionNetworkMember{
    private Map<Integer, Map<Integer ,ArrayList<Product>>> orderByDay;

    private final String producerId;

    public Producer(String locId, double latitude, double longitude,String producerId) {
        super(locId, latitude, longitude);
        this.producerId = producerId;
        this.orderByDay = new HashMap<>();
    }

    public String getProducerId() {
        return producerId;
    }

    public Map<Integer, Map<Integer, ArrayList<Product>>> getOrderByDay() {
        return orderByDay;
    }

    public void removeFromOrderByDay(Product product){
        orderByDay.remove(product);
    }

    public void subtractFromOrderByDay(Product product, Double quantityExpedido, int day, int index) {
        ArrayList<Product> products = orderByDay.get(day).get(product.getId());
        Product product1 = products.get(index);
        product1.setQuantity(product1.getQuantity() - quantityExpedido);
    }
}
