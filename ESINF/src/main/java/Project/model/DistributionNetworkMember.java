package Project.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class DistributionNetworkMember{

    private final String locId;
    private double latitude;
    private double longitude;
    public DistributionNetworkMember(String locId,double latitude, double longitude){
        this.locId = locId;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public DistributionNetworkMember(String locId) {
        this.locId = locId;
    }

    public String getLocId() {
        return locId;
    }

    public Double getLatitude() {
        return latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null) return false;
        if (this == o) return true;
        DistributionNetworkMember that = (DistributionNetworkMember) o;
        return locId.equals(that.locId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(locId);
    }

    @Override
    public String toString() {
        return locId;
    }
}
