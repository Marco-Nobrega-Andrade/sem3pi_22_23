package Project.model;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class IrrigationController {
    private ArrayList<Date> irrigationHours;
    private ArrayList<SectorToIrrigate> sectorsToIrrigate;


    public IrrigationController() {
        this.irrigationHours = new ArrayList<>();
        this.sectorsToIrrigate = new ArrayList<>();
    }
    public IrrigationController(List<String> info) throws ParseException {
        this.irrigationHours = new ArrayList<>();
        this.sectorsToIrrigate = new ArrayList<>();
        boolean flag = true;
        for (String line : info) {
            String[] lineSplit = line.split(",");
            if(flag){
                SimpleDateFormat df = new SimpleDateFormat("HH:mm");

                Date data = new Date(System.currentTimeMillis());

                Calendar calendar = Calendar.getInstance();
                calendar.setTime(data);

                int year = calendar.get(Calendar.YEAR);
                int month = calendar.get(Calendar.MONTH);
                int day = calendar.get(Calendar.DAY_OF_MONTH);

                for (int i = 0; i < lineSplit.length; i++) {
                    int minutes = df.parse(lineSplit[i]).getMinutes();
                    int hours = df.parse(lineSplit[i]).getHours();
                    calendar.set(year,month,day,hours,minutes,0);
                    irrigationHours.add(calendar.getTime());
                }
                flag = false;
            }else {
                sectorsToIrrigate.add(new SectorToIrrigate(lineSplit[0],Integer.parseInt(lineSplit[1]),lineSplit[2]));
            }
        }
    }

    public void setIrrigationHours(ArrayList<Date> irrigationHours) {
        this.irrigationHours = irrigationHours;
    }

    public void setSectorsToIrrigate(ArrayList<SectorToIrrigate> sectorsToIrrigate) {
        this.sectorsToIrrigate = sectorsToIrrigate;
    }

    public ArrayList<Date> getIrrigationHours() {
        return irrigationHours;
    }

    public ArrayList<SectorToIrrigate> getSectorsToIrrigate() {
        return sectorsToIrrigate;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        IrrigationController that = (IrrigationController) o;
        return Objects.equals(irrigationHours, that.irrigationHours) && Objects.equals(sectorsToIrrigate, that.sectorsToIrrigate);
    }

    @Override
    public int hashCode() {
        return Objects.hash(irrigationHours, sectorsToIrrigate);
    }
}
