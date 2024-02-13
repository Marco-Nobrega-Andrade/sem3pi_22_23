package Project.model;

public class Company extends Buyer{

    private final String companyId;

    public Company(String locId, double latitude, double longitude,String companyId) {
        super(locId, latitude, longitude);
        this.companyId = companyId;
    }

    public String getCompanyId() {
        return companyId;
    }

}
