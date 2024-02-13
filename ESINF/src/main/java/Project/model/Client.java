package Project.model;

public class Client extends Buyer{

    private String clientId;

    public Client(String locId, double latitude, double longitude,String clientId) {
        super(locId, latitude, longitude);
        this.clientId = clientId;
    }

    public String getClientId() {
        return clientId;
    }

}
