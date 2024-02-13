package Project.model;

import org.junit.Before;
import org.junit.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;


public class IrrigationControllerTest {

    private IrrigationController irrigationControllerExample;
    @Before
    public void setup() throws IOException, ParseException {
        List<String> infoIrrigation = Files.lines(Paths.get("Files/US306/irrigationControllerEx.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        irrigationControllerExample = new IrrigationController(infoIrrigation);
    }
    @Test
    public void loadInfo() throws ParseException {
        IrrigationController expected = new IrrigationController();

        ArrayList<Date> irrigationHours = expected.getIrrigationHours();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm");
        irrigationHours.add(simpleDateFormat.parse("8:30"));
        irrigationHours.add(simpleDateFormat.parse("17:00"));

        ArrayList<SectorToIrrigate> sectorsToIrrigateExpected = expected.getSectorsToIrrigate();
        sectorsToIrrigateExpected.add(new SectorToIrrigate("a",10,"t"));
        sectorsToIrrigateExpected.add(new SectorToIrrigate("b",12,"p"));
        sectorsToIrrigateExpected.add(new SectorToIrrigate("c",12,"i"));
        sectorsToIrrigateExpected.add(new SectorToIrrigate("d",5,"t"));
        sectorsToIrrigateExpected.add(new SectorToIrrigate("e",8,"i"));

        assertEquals(expected, irrigationControllerExample);
    }
}
