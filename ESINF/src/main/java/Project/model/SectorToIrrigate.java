package Project.model;

import javax.print.DocFlavor;
import java.util.Objects;

public class SectorToIrrigate {
    private String sector;
    private int duration;
    private String regularity;

    public SectorToIrrigate(String sector, int duration, String regularity) {
        this.sector = sector;
        this.duration = duration;
        this.regularity = regularity;
    }

    public int getDuration() {
        return duration;
    }

    public String getSector() {
        return sector;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SectorToIrrigate that = (SectorToIrrigate) o;
        return duration == that.duration && Objects.equals(sector, that.sector) && Objects.equals(regularity, that.regularity);
    }

    @Override
    public int hashCode() {
        return Objects.hash(sector, duration, regularity);
    }
}
