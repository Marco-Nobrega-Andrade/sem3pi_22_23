package Project.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Buyer extends DistributionNetworkMember{
    private Map<Integer, ArrayList<Product>> orderByDay;
    public Buyer(String locId, double latitude, double longitude) {
        super(locId, latitude, longitude);
        orderByDay = new HashMap<>();
    }
    public Map<Integer, ArrayList<Product>> getOrderByDay() {
        return orderByDay;
    }
    public void removeFromOrderByDay(Product product){
        orderByDay.remove(product);
    }
}
