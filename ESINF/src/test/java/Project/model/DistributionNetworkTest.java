package Project.model;

import Project.graph.Edge;
import Project.graph.Graph;
import Project.model.Analtytics.*;
import org.junit.Before;
import org.junit.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

import static org.junit.Assert.*;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class DistributionNetworkTest {
    private DistributionNetwork distributionNetworkSmall;
    private DistributionNetwork distributionNetworkBig;
    private DistributionNetwork distributionNetworkUS301;
    private DistributionNetwork distributionNetworkUS303;
    private DistributionNetwork distributionNetworkUS303_2;
    private DistributionNetwork distributionNetworkUS308;

    private DistributionNetwork distributionNetworkUS309_small;

    @Before
    public void setup() throws IOException {
        this.distributionNetworkSmall = new DistributionNetwork();
        List<String> memberInfoSmall = Files.lines(Paths.get("Files/Small/clientes-produtores_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfoSmall = Files.lines(Paths.get("Files/Small/distancias_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> basketsInfoSmall = Files.lines(Paths.get("Files/Small/cabazes_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetworkSmall.loadGraph(memberInfoSmall, trackInfoSmall);
        distributionNetworkSmall.loadBaskets(basketsInfoSmall);

        this.distributionNetworkBig = new DistributionNetwork();
        List<String> memberInfoBig = Files.lines(Paths.get("Files/Big/clientes-produtores_big.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfoBig = Files.lines(Paths.get("Files/Big/distancias_big.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> basketsInfoBig = Files.lines(Paths.get("Files/Big/cabazes_big.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());

        distributionNetworkBig.loadGraph(memberInfoBig, trackInfoBig);
        distributionNetworkBig.loadBaskets(basketsInfoBig);

        distributionNetworkUS301 = new DistributionNetwork();
        List<String> memberInfoUS301 = Files.lines(Paths.get("Files/TestUS301/clientes.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfoUS301 = Files.lines(Paths.get("Files/TestUS301/distancias.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetworkUS301.loadGraph(memberInfoUS301, trackInfoUS301);

        distributionNetworkUS303 = new DistributionNetwork();
        List<String> memberInfoUS303 = Files.lines(Paths.get("Files/TestUS303/clientes.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfoUS303 = Files.lines(Paths.get("Files/TestUS303/distance.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetworkUS303.loadGraph(memberInfoUS303, trackInfoUS303);

        distributionNetworkUS303_2 = new DistributionNetwork();
        List<String> memberInfoUS303_2 = Files.lines(Paths.get("Files/TestUS303/clientes.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfoUS303_2 = Files.lines(Paths.get("Files/TestUS303/distancia.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetworkUS303_2.loadGraph(memberInfoUS303_2, trackInfoUS303_2);

        distributionNetworkUS308 = new DistributionNetwork();
        List<String> memberInfoUS308 = Files.lines(Paths.get("Files/TestUS308/members.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfoUS308 = Files.lines(Paths.get("Files/TestUS308/distancias.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> basketsInfoUS308 = Files.lines(Paths.get("Files/TestUS308/cabazes.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetworkUS308.loadGraph(memberInfoUS308, trackInfoUS308);
        distributionNetworkUS308.loadBaskets(basketsInfoUS308);

        distributionNetworkUS309_small = new DistributionNetwork();
        List<String> memberInfoUS309_small = Files.lines(Paths.get("Files/TestUS309/cliente-produtores_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfoUS309_small = Files.lines(Paths.get("Files/TestUS309/distancias_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> basketsInfoUS309_small = Files.lines(Paths.get("Files/TestUS309/cabazes_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetworkUS309_small.loadGraph(memberInfoUS309_small,trackInfoUS309_small);
        distributionNetworkUS309_small.loadBaskets(basketsInfoUS309_small);

    }

    @Test
    public void integralGraphCheck1() {
        List<DistributionNetworkMember> testVerticesList = new ArrayList<>();
        List<List<DistributionNetworkMember>> testEdgesList = new ArrayList<>();
        Client c1 = new Client("CT1", 40.6389, -8.6553, "C1");
        Client c2 = new Client("CT3", 41.5333, -8.4167, "C3");
        Client c3 = new Client("CT13", 39.2369, -8.685, "C9");
        Client c4 = new Client("CT12", 41.1495, -8.6108, "C6");
        Company comp = new Company("CT5", 39.823, -7.4931, "E3");
        Producer p1 = new Producer("CT6", 40.2111, -8.4291, "P2");
        Producer p2 = new Producer("CT10", 39.7444, -8.8072, "P3");
        testVerticesList.add(c1);
        testVerticesList.add(c2);
        testVerticesList.add(c3);
        testVerticesList.add(c4);
        testVerticesList.add(comp);
        testVerticesList.add(p1);
        testVerticesList.add(p2);
        List<DistributionNetworkMember> edge1 = new ArrayList<>();
        edge1.add(p2);
        edge1.add(c3);
        List<DistributionNetworkMember> edge2 = new ArrayList<>();
        edge2.add(p2);
        edge2.add(p1);
        List<DistributionNetworkMember> edge3 = new ArrayList<>();
        edge3.add(p2);
        edge3.add(c1);
        List<DistributionNetworkMember> edge4 = new ArrayList<>();
        edge4.add(p2);
        edge4.add(comp);
        List<DistributionNetworkMember> edge5 = new ArrayList<>();
        edge5.add(c4);
        edge5.add(c2);
        testEdgesList.add(edge1);
        testEdgesList.add(edge2);
        testEdgesList.add(edge3);
        testEdgesList.add(edge4);
        testEdgesList.add(edge5);
        boolean actual = distributionNetworkUS301.integralGraphCheck(testVerticesList, testEdgesList);
        assertTrue(actual);
    }

    @Test
    public void integralGraphCheck2() {
        List<DistributionNetworkMember> testVerticesList = new ArrayList<>();
        List<List<DistributionNetworkMember>> testEdgesList = new ArrayList<>();
        Client c1 = new Client("CT1", 40.6389, -8.6553, "C1");
        Client c2 = new Client("CT3", 41.5333, -8.4167, "C3");
        Client c3 = new Client("CT13", 39.2369, -8.685, "C9");
        Client c4 = new Client("CT12", 41.1495, -8.6108, "C6");
        Company comp = new Company("CT5", 39.823, -7.4931, "E3");
        Producer p1 = new Producer("CT6", 40.2111, -8.4291, "P2");
        Producer p2 = new Producer("CT10", 39.7444, -8.8072, "P3");
        testVerticesList.add(c1);
        testVerticesList.add(c2);
        testVerticesList.add(c3);
        testVerticesList.add(comp);
        testVerticesList.add(p1);
        testVerticesList.add(p2);
        List<DistributionNetworkMember> edge1 = new ArrayList<>();
        edge1.add(p2);
        edge1.add(c2);
        List<DistributionNetworkMember> edge2 = new ArrayList<>();
        edge2.add(p2);
        edge2.add(p1);
        List<DistributionNetworkMember> edge3 = new ArrayList<>();
        edge3.add(p2);
        edge3.add(c1);
        List<DistributionNetworkMember> edge4 = new ArrayList<>();
        edge4.add(p2);
        edge4.add(comp);
        testEdgesList.add(edge1);
        testEdgesList.add(edge2);
        testEdgesList.add(edge3);
        testEdgesList.add(edge4);
        boolean actual = distributionNetworkUS301.integralGraphCheck(testVerticesList, testEdgesList);
        assertFalse(actual);
    }

    @Test
    public void checkGraphVertices1() {
        List<DistributionNetworkMember> testVerticesList = new ArrayList<>();
        Client c1 = new Client("CT1", 40.6389, -8.6553, "C1");
        Client c2 = new Client("CT2", 38.0333, -7.8833, "C2");
        Client c3 = new Client("CT3", 41.5333, -8.4167, "C3");
        Client c4 = new Client("CT15", 41.7, -8.8333, "C4");
        Client c5 = new Client("CT16", 41.3002, -7.7398, "C5");
        Client c6 = new Client("CT12", 41.1495, -8.6108, "C6");
        Client c7 = new Client("CT7", 38.5667, -7.9, "C7");
        Client c8 = new Client("CT8", 37.0161, -7.935, "C8");
        Client c9 = new Client("CT13", 39.2369, -8.685, "C9");
        Company comp1 = new Company("CT14", 38.5243, -8.8926, "E1");
        Company comp2 = new Company("CT11", 39.3167, -7.4167, "E2");
        Company comp3 = new Company("CT5", 39.823, -7.4931, "E3");
        Company comp4 = new Company("CT9", 40.5364, -7.2683, "E4");
        Company comp5 = new Company("CT4", 41.8, -6.75, "E5");
        Producer p1 = new Producer("CT17", 40.6667, -7.9167, "P1");
        Producer p2 = new Producer("CT6", 40.2111, -8.4291, "P2");
        Producer p3 = new Producer("CT10", 39.7444, -8.8072, "P3");
        testVerticesList.add(c1);
        testVerticesList.add(c2);
        testVerticesList.add(c3);
        testVerticesList.add(c4);
        testVerticesList.add(c5);
        testVerticesList.add(c6);
        testVerticesList.add(c7);
        testVerticesList.add(c8);
        testVerticesList.add(c9);
        testVerticesList.add(comp1);
        testVerticesList.add(comp2);
        testVerticesList.add(comp3);
        testVerticesList.add(comp4);
        testVerticesList.add(comp5);
        testVerticesList.add(p1);
        testVerticesList.add(p2);
        testVerticesList.add(p3);
        Boolean actual = distributionNetworkSmall.checkGraphVertices(testVerticesList);
        assertTrue(actual);
    }

    @Test
    public void checkGraphVertices2() {
        List<DistributionNetworkMember> testVerticesList = new ArrayList<>();
        Client c1 = new Client("CT1", 40.6389, -8.6553, "C1");
        Client c2 = new Client("CT2", 38.0333, -7.8833, "C2");
        Client c3 = new Client("CT3", 41.5333, -8.4167, "C3");
        Client c4 = new Client("CT15", 41.7, -8.8333, "C4");
        Client c5 = new Client("CT16", 41.3002, -7.7398, "C5");
        Client c6 = new Client("CT12", 41.1495, -8.6108, "C6");
        Client c7 = new Client("CT7", 38.5667, -7.9, "C7");
        Client c8 = new Client("CT8", 37.0161, -7.935, "C8");
        Client c9 = new Client("CT13", 39.2369, -8.685, "C9");
        Company comp1 = new Company("CT14", 38.5243, -8.8926, "E1");
        Company comp2 = new Company("CT11", 39.3167, -7.4167, "E2");
        Company comp3 = new Company("CT5", 39.823, -7.4931, "E3");
        Company comp4 = new Company("CT9", 40.5364, -7.2683, "E4");
        Company comp5 = new Company("CT4", 41.8, -6.75, "E5");
        Producer p1 = new Producer("CT17", 40.6667, -7.9167, "P1");
        Producer p2 = new Producer("CT6", 40.2111, -8.4291, "P2");
        testVerticesList.add(c1);
        testVerticesList.add(c2);
        testVerticesList.add(c3);
        testVerticesList.add(c4);
        testVerticesList.add(c5);
        testVerticesList.add(c6);
        testVerticesList.add(c7);
        testVerticesList.add(c8);
        testVerticesList.add(c9);
        testVerticesList.add(comp1);
        testVerticesList.add(comp2);
        testVerticesList.add(comp3);
        testVerticesList.add(comp4);
        testVerticesList.add(comp5);
        testVerticesList.add(p1);
        testVerticesList.add(p2);
        Boolean actual = distributionNetworkSmall.checkGraphVertices(testVerticesList);
        assertFalse(actual);
    }

    @Test
    public void checkGraphEdges1() {
        List<List<DistributionNetworkMember>> testEdgesList = new ArrayList<>();
        Client c1 = new Client("CT1", 40.6389, -8.6553, "C1");
        Client c2 = new Client("CT3", 41.5333, -8.4167, "C3");
        Client c3 = new Client("CT13", 39.2369, -8.685, "C9");
        Client c4 = new Client("CT12", 41.1495, -8.6108, "C6");
        Company comp = new Company("CT5", 39.823, -7.4931, "E3");
        Producer p1 = new Producer("CT6", 40.2111, -8.4291, "P2");
        Producer p2 = new Producer("CT10", 39.7444, -8.8072, "P3");
        List<DistributionNetworkMember> edge1 = new ArrayList<>();
        edge1.add(p2);
        edge1.add(c3);
        List<DistributionNetworkMember> edge2 = new ArrayList<>();
        edge2.add(p2);
        edge2.add(p1);
        List<DistributionNetworkMember> edge3 = new ArrayList<>();
        edge3.add(p2);
        edge3.add(c1);
        List<DistributionNetworkMember> edge4 = new ArrayList<>();
        edge4.add(p2);
        edge4.add(comp);
        List<DistributionNetworkMember> edge5 = new ArrayList<>();
        edge5.add(c4);
        edge5.add(c2);
        testEdgesList.add(edge1);
        testEdgesList.add(edge2);
        testEdgesList.add(edge3);
        testEdgesList.add(edge4);
        testEdgesList.add(edge5);
        boolean actual = distributionNetworkUS301.checkGraphEdges(testEdgesList);
        assertTrue(actual);
    }

    @Test
    public void checkGraphEdges2() {
        List<List<DistributionNetworkMember>> testEdgesList = new ArrayList<>();
        Client c1 = new Client("CT1", 40.6389, -8.6553, "C1");
        Client c2 = new Client("CT3", 41.5333, -8.4167, "C3");
        Client c3 = new Client("CT13", 39.2369, -8.685, "C9");
        Client c4 = new Client("CT12", 41.1495, -8.6108, "C6");
        Company comp = new Company("CT5", 39.823, -7.4931, "E3");
        Producer p1 = new Producer("CT6", 40.2111, -8.4291, "P2");
        Producer p2 = new Producer("CT10", 39.7444, -8.8072, "P3");
        List<DistributionNetworkMember> edge1 = new ArrayList<>();
        edge1.add(p2);
        edge1.add(c2);
        List<DistributionNetworkMember> edge2 = new ArrayList<>();
        edge2.add(p2);
        edge2.add(p1);
        List<DistributionNetworkMember> edge3 = new ArrayList<>();
        edge3.add(p2);
        edge3.add(c1);
        List<DistributionNetworkMember> edge4 = new ArrayList<>();
        edge4.add(p2);
        edge4.add(comp);
        testEdgesList.add(edge1);
        testEdgesList.add(edge2);
        testEdgesList.add(edge3);
        testEdgesList.add(edge4);
        boolean actual = distributionNetworkUS301.checkGraphEdges(testEdgesList);
        assertFalse(actual);
    }

    @Test
    public void isConexSmall() {
        int res = distributionNetworkSmall.isConex();
        int expected = 6;
        assertEquals(expected, res);
    }

    @Test
    public void isConexBig() {
        int res = distributionNetworkBig.isConex();
        int expected = 28;
        assertEquals(expected, res);
    }


    @Test
    public void isConexNotConex() throws IOException {
        DistributionNetwork distributionNetwork = new DistributionNetwork();
        List<String> memberInfo = Files.lines(Paths.get("Files/TestUs302/clientes_produtoresNotConex.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfo = Files.lines(Paths.get("Files/TestUs302/DistancesNotConex.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetwork.loadGraph(memberInfo, trackInfo);
        int res = distributionNetwork.isConex();
        int expected = -1;
        assertEquals(expected, res);
    }

    @Test
    public void isConexNull() {
        DistributionNetwork distributionNetwork = new DistributionNetwork();
        int res = distributionNetwork.isConex();
        int expected = -1;
        assertEquals(expected, res);
    }

    @Test
    public void getClosestHub() throws IOException {
        DistributionNetwork distributionNetwork = new DistributionNetwork();
        List<String> memberInfo = Files.lines(Paths.get("Files/TestUS304/clientes-produtores_very_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfo = Files.lines(Paths.get("Files/TestUS304/distancias_very_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetwork.loadGraph(memberInfo, trackInfo);
        distributionNetwork.defineHubs(2);
        Map<DistributionNetworkMember, DistributionNetworkMember> res = distributionNetwork.getClosestHub();
        Map<DistributionNetworkMember, DistributionNetworkMember> expected = new HashMap<>();
        expected.put(new DistributionNetworkMember("CT1"), new DistributionNetworkMember("CT9"));
        expected.put(new DistributionNetworkMember("CT6"), new DistributionNetworkMember("CT9"));
        expected.put(new DistributionNetworkMember("CT10"), new DistributionNetworkMember("CT4"));
        expected.put(new DistributionNetworkMember("CT15"), new DistributionNetworkMember("CT4"));
        assertEquals(expected, res);
    }

    @Test
    public void getClosestHubWithOneHub() throws IOException {
        DistributionNetwork distributionNetwork = new DistributionNetwork();
        List<String> memberInfo = Files.lines(Paths.get("Files/TestUS304/clientes-produtores_very_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfo = Files.lines(Paths.get("Files/TestUS304/distancias_very_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetwork.loadGraph(memberInfo, trackInfo);
        distributionNetwork.defineHubs(1);
        Map<DistributionNetworkMember, DistributionNetworkMember> res = distributionNetwork.getClosestHub();
        Map<DistributionNetworkMember, DistributionNetworkMember> expected = new HashMap<>();
        expected.put(new DistributionNetworkMember("CT1"), new DistributionNetworkMember("CT9"));
        expected.put(new DistributionNetworkMember("CT4"), new DistributionNetworkMember("CT9"));
        expected.put(new DistributionNetworkMember("CT6"), new DistributionNetworkMember("CT9"));
        expected.put(new DistributionNetworkMember("CT10"), new DistributionNetworkMember("CT9"));
        expected.put(new DistributionNetworkMember("CT15"), new DistributionNetworkMember("CT9"));
        assertEquals(expected, res);
    }

    @Test
    public void getClosestHubWithNoHubs() throws IOException {
        DistributionNetwork distributionNetwork = new DistributionNetwork();
        List<String> memberInfo = Files.lines(Paths.get("Files/TestUS304/clientes-produtores_very_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfo = Files.lines(Paths.get("Files/TestUS304/distancias_very_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetwork.loadGraph(memberInfo, trackInfo);
        distributionNetwork.defineHubs(0);
        Map<DistributionNetworkMember, DistributionNetworkMember> res = distributionNetwork.getClosestHub();
        assertNull(res);
    }

    @Test
    public void getClosestHubWithNoClients() throws IOException {
        DistributionNetwork distributionNetwork = new DistributionNetwork();
        List<String> memberInfo = Files.lines(Paths.get("Files/TestUS304/clientes-produtores_NoClients.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfo = Files.lines(Paths.get("Files/TestUS304/distancias_small_WithOnePathBetweenHubs.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetwork.loadGraph(memberInfo, trackInfo);
        distributionNetwork.defineHubs(2);
        Map<DistributionNetworkMember, DistributionNetworkMember> res = distributionNetwork.getClosestHub();
        assertNull(res);
    }

    @Test
    public void getClosestHubTimeSpentSmall() {
        this.distributionNetworkSmall.defineHubs(2);
        Map<DistributionNetworkMember, DistributionNetworkMember> res = this.distributionNetworkSmall.getClosestHub();
        assertNotNull(res);
    }

    @Test
    public void getClosestHubTimeSpentBig() {
        this.distributionNetworkBig.defineHubs(3);
        Map<DistributionNetworkMember, DistributionNetworkMember> res = this.distributionNetworkBig.getClosestHub();
        assertNotNull(res);
    }


    @Test
    public void minimumSpanningNetworkSmall() {
        Graph<DistributionNetworkMember, DistributionNetwork.Track> graphResult = distributionNetworkSmall.minimumSpanningNetwork();
        int totalWeightResult = 0;
        for (Edge<DistributionNetworkMember, DistributionNetwork.Track> edge : graphResult.edges()) {
            totalWeightResult += edge.getWeight().getMiles();
        }
        // Because this algorithm only applies to undirected graphs, all edges are counted twice
        totalWeightResult /= 2;
        int totalWeightExpected = 1185232;
        assertEquals(totalWeightExpected, totalWeightResult);
    }

    @Test
    public void minimumSpanningNetworkBig() {
        Graph<DistributionNetworkMember, DistributionNetwork.Track> graphResult = distributionNetworkBig.minimumSpanningNetwork();
        int totalWeightResult = 0;
        for (Edge<DistributionNetworkMember, DistributionNetwork.Track> edge : graphResult.edges()) {
            totalWeightResult += edge.getWeight().getMiles();
        }
        // Because this algorithm only applies to undirected graphs, all edges are counted twice
        totalWeightResult /= 2;
        int totalWeightExpected = 4231982;
        assertEquals(totalWeightExpected, totalWeightResult);
    }

    @Test
    public void minimumSpanningNetworkEmpty() {
        distributionNetworkSmall = new DistributionNetwork();
        Graph<DistributionNetworkMember, DistributionNetwork.Track> graphResult = distributionNetworkSmall.minimumSpanningNetwork();
        assertNull(graphResult);
    }

    @Test
    public void defineHubTest() {
        List<DistributionNetworkMember> hubGotted = distributionNetworkUS301.defineHubs(2);

        DistributionNetworkMember e1 = new Company("CT5", 39.823, -7.4931, "E3");

        List<DistributionNetworkMember> hubExpected = new ArrayList<>();
        hubExpected.add(e1);

        assertEquals(hubExpected, hubGotted);
    }

    @Test
    public void defineHubTest1() {
        List<DistributionNetworkMember> hubGotted = distributionNetworkUS303.defineHubs(2);

        DistributionNetworkMember e1 = new Company("CT1", 40.6389, -8.6553, "E1");
        DistributionNetworkMember e2 = new Company("CT2", 41.5333, -8.4167, "E2");

        List<DistributionNetworkMember> hubExpected = new ArrayList<>();
        hubExpected.add(e1);
        hubExpected.add(e2);

        assertEquals(hubExpected, hubGotted);
    }

    @Test
    public void defineHubTest2() {
        List<DistributionNetworkMember> hubGotted = distributionNetworkUS303_2.defineHubs(2);

        DistributionNetworkMember e1 = new Company("CT2", 40.6389, -8.6553, "E1");
        DistributionNetworkMember e2 = new Company("CT3", 41.5333, -8.4167, "E2");

        List<DistributionNetworkMember> hubExpected = new ArrayList<>();
        hubExpected.add(e2);
        hubExpected.add(e1);

        assertEquals(hubExpected, hubGotted);
    }

    @Test
    public void defineHubTimeTestSmall() {
        List<DistributionNetworkMember> hubGotted = distributionNetworkSmall.defineHubs(2);
        assertEquals(hubGotted, hubGotted);
    }

    @Test
    public void defineHubTimeTestBig() {
        List<DistributionNetworkMember> hubGotted = distributionNetworkBig.defineHubs(2);
        assertEquals(hubGotted, hubGotted);
    }

    @Test
    public void defineHubIsNull1() {
        List<DistributionNetworkMember> hubGotted = distributionNetworkSmall.defineHubs(0);
        List<DistributionNetworkMember> hubExpected = null;
        assertEquals(hubExpected, hubGotted);
    }

    @Test
    public void defineHubIsNull2() {
        List<DistributionNetworkMember> hubGotted = distributionNetworkSmall.defineHubs(-1);
        List<DistributionNetworkMember> hubExpected = null;
        assertEquals(hubExpected, hubGotted);
    }

    @Test
    public void loadBaskets() throws IOException {
        DistributionNetwork distributionNetwork = new DistributionNetwork();
        List<String> memberInfoSmall = Files.lines(Paths.get("Files/Small/clientes-produtores_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfoSmall = Files.lines(Paths.get("Files/Small/distancias_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> basketsInfo = Files.lines(Paths.get("Files/TestUS307/cabazes_US307.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetwork.loadGraph(memberInfoSmall, trackInfoSmall);
        distributionNetwork.loadBaskets(basketsInfo);

        //ORDER BY DAY OF C1
        Map<Integer, ArrayList<Product>> expectedC1 = new HashMap<>();
        Buyer buyer = (Buyer) distributionNetwork.getNetwork().vertex(0);
        assertEquals(expectedC1, buyer.getOrderByDay());

        //ORDER BY DAY OF P3
        Map<Integer, Map<Integer, ArrayList<Product>>> expectedP3 = new HashMap<>();
        ArrayList<Product> products = new ArrayList<>();
        expectedP3.put(2, new HashMap<>());
        expectedP3.get(2).put(1, new ArrayList<>());
        expectedP3.get(2).get(1).add(new Product(1, 1.0));
        expectedP3.get(2).put(2, new ArrayList<>());
        expectedP3.get(2).get(2).add(new Product(2, 1.0));
        Producer producer = (Producer) distributionNetwork.getNetwork().vertex(16);
        assertEquals(expectedP3, producer.getOrderByDay());

        //ORDER BY DAY OF E4
        Map<Integer, ArrayList<Product>> expectedE4 = new HashMap<>();
        products = new ArrayList<>();
        products.add(new Product(2, 2.0));
        products.add(new Product(3, 4.0));
        expectedE4.put(1, products);
        buyer = (Buyer) distributionNetwork.getNetwork().vertex(12);
        assertEquals(expectedE4, buyer.getOrderByDay());

        //ORDER BY DAY OF C3
        Map<Integer, ArrayList<Product>> expectedC3 = new HashMap<>();
        products = new ArrayList<>();
        products.add(new Product(1, 5.0));
        products.add(new Product(2, 2.0));
        products.add(new Product(3, 9.0));
        expectedC3.put(1, products);
        buyer = (Buyer) distributionNetwork.getNetwork().vertex(2);
        assertEquals(expectedC3, buyer.getOrderByDay());

        // CHECK BUYERS LIST
        Map<Integer, ArrayList<Buyer>> buyersList = new HashMap<>();
        buyersList.put(1, new ArrayList<>());
        buyersList.get(1).add((Buyer) distributionNetwork.getNetwork().vertex(12));
        buyersList.get(1).add((Buyer) distributionNetwork.getNetwork().vertex(2));

        // CHECK PRODUCERS LIST
        Map<Integer, Map<Integer, ArrayList<Producer>>> producersList = new HashMap<>();
        producersList.put(2, new HashMap<>());
        producersList.get(2).put(1, new ArrayList<>());
        producersList.get(2).put(2, new ArrayList<>());
        producersList.get(2).get(1).add((Producer) distributionNetwork.getNetwork().vertex(16));
        producersList.get(2).get(2).add((Producer) distributionNetwork.getNetwork().vertex(16));
        assertEquals(buyersList, distributionNetwork.getBuyersWithOrders());
        assertEquals(producersList, distributionNetwork.getProducersWithOrders());
    }

    @Test
    public void loadBasketsOfUnexistingMembers() throws IOException {
        DistributionNetwork distributionNetwork = new DistributionNetwork();
        List<String> memberInfoSmall = Files.lines(Paths.get("Files/Small/clientes-produtores_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfoSmall = Files.lines(Paths.get("Files/Small/distancias_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> basketsInfo = Files.lines(Paths.get("Files/TestUS307/cabazes_membros_inexistentes.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetwork.loadGraph(memberInfoSmall, trackInfoSmall);

        // CHECK THAT 0 OF 2 DAYS HAVE BEEN READ SUCCESSFULLY
        int expected = 0;
        assertEquals(expected, distributionNetwork.loadBaskets(basketsInfo));
    }

    @Test
    public void loadBasketsWithSomeUnexistingMembers() throws IOException {
        DistributionNetwork distributionNetwork = new DistributionNetwork();
        List<String> memberInfoSmall = Files.lines(Paths.get("Files/Small/clientes-produtores_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> trackInfoSmall = Files.lines(Paths.get("Files/Small/distancias_small.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        List<String> basketsInfo = Files.lines(Paths.get("Files/TestUS307/cabazes_US307_com_membros_inexistentes.csv"), StandardCharsets.ISO_8859_1).collect(Collectors.toList());
        distributionNetwork.loadGraph(memberInfoSmall, trackInfoSmall);

        // CHECK THAT 4 OF 6 DAYS HAVE BEEN READ SUCCESSFULLY
        int expected = 4;
        assertEquals(expected, distributionNetwork.loadBaskets(basketsInfo));

        //ORDER BY DAY OF C1
        Map<Integer, ArrayList<Product>> expectedC1 = new HashMap<>();
        Buyer buyer = (Buyer) distributionNetwork.getNetwork().vertex(0);
        assertEquals(expectedC1, buyer.getOrderByDay());

        //ORDER BY DAY OF P3
        Map<Integer, Map<Integer, ArrayList<Product>>> expectedP3 = new HashMap<>();
        ArrayList<Product> products = new ArrayList<>();
        expectedP3.put(2, new HashMap<>());
        expectedP3.get(2).put(1, new ArrayList<>());
        expectedP3.get(2).get(1).add(new Product(1, 1.0));
        expectedP3.get(2).put(2, new ArrayList<>());
        expectedP3.get(2).get(2).add(new Product(2, 1.0));
        Producer producer = (Producer) distributionNetwork.getNetwork().vertex(16);
        assertEquals(expectedP3, producer.getOrderByDay());

        //ORDER BY DAY OF E4
        Map<Integer, ArrayList<Product>> expectedE4 = new HashMap<>();
        products = new ArrayList<>();
        products.add(new Product(2, 2.0));
        products.add(new Product(3, 4.0));
        expectedE4.put(1, products);
        buyer = (Buyer) distributionNetwork.getNetwork().vertex(12);
        assertEquals(expectedE4, buyer.getOrderByDay());

        //ORDER BY DAY OF C3
        Map<Integer, ArrayList<Product>> expectedC3 = new HashMap<>();
        products = new ArrayList<>();
        products.add(new Product(1, 5.0));
        products.add(new Product(2, 2.0));
        products.add(new Product(3, 9.0));
        expectedC3.put(1, products);
        buyer = (Buyer) distributionNetwork.getNetwork().vertex(2);
        assertEquals(expectedC3, buyer.getOrderByDay());

        // CHECK BUYERS LIST
        Map<Integer, ArrayList<Buyer>> buyersList = new HashMap<>();
        buyersList.put(1, new ArrayList<>());
        buyersList.get(1).add((Buyer) distributionNetwork.getNetwork().vertex(12));
        buyersList.get(1).add((Buyer) distributionNetwork.getNetwork().vertex(2));

        // CHECK PRODUCERS LIST
        Map<Integer, Map<Integer, ArrayList<Producer>>> producersList = new HashMap<>();
        producersList.put(2, new HashMap<>());
        producersList.get(2).put(1, new ArrayList<>());
        producersList.get(2).put(2, new ArrayList<>());
        producersList.get(2).get(1).add((Producer) distributionNetwork.getNetwork().vertex(16));
        producersList.get(2).get(2).add((Producer) distributionNetwork.getNetwork().vertex(16));
        assertEquals(buyersList, distributionNetwork.getBuyersWithOrders());
        assertEquals(producersList, distributionNetwork.getProducersWithOrders());
    }

    @Test
    public void generateShipmentList() {
        distributionNetworkBig.defineHubs(10);
        List<Shipment> actual = distributionNetworkBig.generateShipmentList(5);
        assertEquals(actual, actual);
    }

    @Test
    public void generateShipmentListUS308_1() {
        distributionNetworkUS308.defineHubs(1);
        List<Shipment> actual = distributionNetworkUS308.generateShipmentList(1);
        List<Shipment> expected = new ArrayList<>();
        Client c1 = new Client("CT1",0.0,0.0,"C");
        Client c2 = new Client("CT2",0.0,0.0,"C");
        Company closestHub = new Company("CT3",0.0,0.0,"E");
        Producer p1 = new Producer("CT4",0.0,0.0,"P");
        Double q1 = 1.0;
        Double q2 = 2.0;
        Double q3 = 5.5;
        Double q4 = 4.5;
        Product prod1 = new Product(1,0.0);
        Product prod2 = new Product(2,0.0);
        Product prod3 = new Product(3,0.0);
        Shipment s1 = new Shipment(c1,closestHub);
        s1.addProducer(p1);
        s1.addQuantity(q1);
        s1.addQuantity(q2);
        s1.addProduct(prod1);
        s1.addProduct(prod2);
        Shipment s2 = new Shipment(c2,closestHub);
        s2.addProducer(p1);
        s2.addQuantity(q1);
        s2.addQuantity(q3);
        s2.addQuantity(q4);
        s2.addProduct(prod1);
        s2.addProduct(prod2);
        s2.addProduct(prod3);
        expected.add(s1);
        expected.add(s2);
        assertEquals(expected, actual);
    }

    @Test
    public void generateShipmentListUS308_2() {
        distributionNetworkUS308.defineHubs(1);
        List<Shipment> actual = distributionNetworkUS308.generateShipmentList(1);
        List<Shipment> expected = new ArrayList<>();
        Client c1 = new Client("CT1",0.0,0.0,"C");
        Client c2 = new Client("CT2",0.0,0.0,"C");
        Company closestHub = new Company("CT3",0.0,0.0,"E");
        Producer p1 = new Producer("CT4",0.0,0.0,"P");
        Double q1 = 1.0;
        Double q2 = 2.0;
        Double q3 = 5.5;
        Double q4 = 4.5;
        Product prod1 = new Product(1,0.0);
        Product prod2 = new Product(2,0.0);
        Product prod3 = new Product(3,0.0);
        Shipment s1 = new Shipment(c1,closestHub);
        s1.addProducer(p1);
        s1.addQuantity(q1);
        s1.addQuantity(q2);
        s1.addProduct(prod1);
        s1.addProduct(prod2);
        Shipment s2 = new Shipment(c2,closestHub);
        s2.addProducer(p1);
        s2.addQuantity(q1);
        s2.addQuantity(q3);
        s2.addQuantity(q4);
        s2.addProduct(prod1);
        s2.addProduct(prod2);
        expected.add(s1);
        expected.add(s2);
        assertNotEquals(expected, actual);
    }

    @Test
    public void generateShipmentListUS308NonExistingDay() {
        distributionNetworkUS308.defineHubs(1);
        List<Shipment> actual = distributionNetworkUS308.generateShipmentList(2);
        assertNull(actual);
    }

    @Test
    public void testHubsExistence1() {
        distributionNetworkUS308.defineHubs(1);
        assertTrue(distributionNetworkUS308.testHubsExistence());
    }

    @Test
    public void testHubsExistence2() {
        assertFalse(distributionNetworkUS308.testHubsExistence());
    }

    @Test
    public void generateShipmentList2() {
        distributionNetworkBig.defineHubs(1);
        List<Shipment> actual = distributionNetworkBig.generateShipmentList(1);
        assertEquals(actual, actual);
    }

    @Test
    public void generateShipmentListWithRestrictions() {
        distributionNetworkBig.defineHubs(10);
        int day = 1;
        int n = 2;
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = distributionNetworkBig.getBuyersWithOrders();
        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = distributionNetworkBig.getProducersWithOrders();
        List<Shipment> actual = distributionNetworkBig.generateShipmentList(day, n);
        assertEquals(actual, actual);
    }
    @Test
    public void testGenerateShipmentList_noNullParamsDay1_Small() {
        distributionNetworkUS309_small.defineHubs(10);
        int day = 1;
        int n = 3;

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));
        buyer1.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 4.8),new Product( 2, 3.0))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));
        buyer2.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.0),new Product( 2, 3.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 7.0))));
        order1.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 3.3))));

        Map<Integer,ArrayList<Product>> order2 = new HashMap<>();
        order2.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 2.0))));

        producer1.getOrderByDay().put(1, order1);
        producer1.getOrderByDay().put(2, order2);

        Map<Integer,ArrayList<Product>> order3 = new HashMap<>();
        order3.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        Map<Integer,ArrayList<Product>> order4 = new HashMap<>();
        order4.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 1.0))));
        order4.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 6.0))));

        Producer producer2 = new Producer( "CT6", 41.1495,-8.6108, "P2");

        //Geração de dados para o mapa de produtor do shipment
        producer2.getOrderByDay().put(1, order3);
        producer2.getOrderByDay().put(2, order4);

        Map<String, Producer> produtor1 = new HashMap<>();
        Map<String, Producer> produtor2 = new HashMap<>();

        produtor1.put("CT1", producer1);
        produtor1.put("CT6", producer2);
        produtor2.put("CT1", producer1);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));
        buyersWithOrders.put(2, new ArrayList<>(Arrays.asList(buyer1, buyer2)));

        //Geração de dados para producersWithOrders
        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = new HashMap<>();

        Map<Integer, ArrayList<Producer>> day1Producers = new HashMap<>();
        day1Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day1Producers.put(2, new ArrayList<>(List.of(producer1)));

        Map<Integer, ArrayList<Producer>> day2Producers = new HashMap<>();
        day2Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day2Producers.put(2, new ArrayList<>(Arrays.asList(producer1, producer2)));

        producersWithOrders.put(1, day1Producers);
        producersWithOrders.put(2, day2Producers);

        //Obtenção dos shipments
        List<Shipment> shipmentsActual = distributionNetworkUS309_small.generateShipmentList(day, n);

        Company hub1 = new Company("CT2", 38.0333, -7.8833,"E1");
        Company hub2 = new Company("CT5", 41.3002, -7.7398,"E2");

        //Geração de um shipment
        List<Shipment> shipmentsExpected = new ArrayList<>();
        shipmentsExpected.add(new Shipment(buyer1,hub2,produtor1,Arrays.asList(2.2, 3.3),Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));
        shipmentsExpected.add(new Shipment(buyer2,hub1,produtor2, List.of(5.0), List.of(new Product(1, 5.0))));

        assertEquals(shipmentsExpected,shipmentsActual);
    }

    @Test
    public void testGenerateShipmentList_noNullParamsDay2_Small() {
        distributionNetworkUS309_small.defineHubs(10);
        int day = 2;
        int n = 3;

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));
        buyer1.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 4.8),new Product( 2, 3.0))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));
        buyer2.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.0),new Product( 2, 3.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 7.0))));
        order1.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 3.3))));

        Map<Integer,ArrayList<Product>> order2 = new HashMap<>();
        order2.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 2.0))));

        producer1.getOrderByDay().put(1, order1);
        producer1.getOrderByDay().put(2, order2);

        Map<Integer,ArrayList<Product>> order3 = new HashMap<>();
        order3.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        Map<Integer,ArrayList<Product>> order4 = new HashMap<>();
        order4.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 1.0))));
        order4.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 6.0))));

        Producer producer2 = new Producer( "CT6", 41.1495,-8.6108, "P2");

        //Geração de dados para o mapa de produtor do shipment
        producer2.getOrderByDay().put(1, order3);
        producer2.getOrderByDay().put(2, order4);

        Map<String, Producer> produtor1 = new HashMap<>();
        Map<String, Producer> produtor2 = new HashMap<>();

        produtor1.put("CT6", producer2);
        produtor2.put("CT1",producer1);
        produtor2.put("CT6", producer2);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));
        buyersWithOrders.put(2, new ArrayList<>(Arrays.asList(buyer1, buyer2)));

        //Geração de dados para producersWithOrders
        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = new HashMap<>();

        Map<Integer, ArrayList<Producer>> day1Producers = new HashMap<>();
        day1Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day1Producers.put(2, new ArrayList<>(List.of(producer1)));

        Map<Integer, ArrayList<Producer>> day2Producers = new HashMap<>();
        day2Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day2Producers.put(2, new ArrayList<>(Arrays.asList(producer1, producer2)));

        producersWithOrders.put(1, day1Producers);
        producersWithOrders.put(2, day2Producers);

        //Obtenção dos shipments
        List<Shipment> shipmentsActual = distributionNetworkUS309_small.generateShipmentList(day, n);

        Company hub1 = new Company("CT2", 38.0333, -7.8833,"E1");
        Company hub2 = new Company("CT5", 41.3002, -7.7398,"E2");

        //Geração de um shipment
        List<Shipment> shipmentsExpected = new ArrayList<>();
        shipmentsExpected.add(new Shipment(buyer1,hub2,produtor1, List.of(3.0),Arrays.asList(new Product( 2, 3.0))));
        shipmentsExpected.add(new Shipment(buyer2,hub1,produtor2, Arrays.asList(2.0,3.0), Arrays.asList(new Product(1,2.0),new Product(2, 3.0))));

        assertEquals(shipmentsExpected,shipmentsActual);
    }

    @Test
    public void testGenerateShipmentList_buyersWithOrdersIsNull() {
        distributionNetworkUS309_small.defineHubs(10);
        int day = 2;
        int n = 3;

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));
        buyer1.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 4.8),new Product( 2, 3.0))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));
        buyer2.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.0),new Product( 2, 3.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 7.0))));
        order1.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 3.3))));

        Map<Integer,ArrayList<Product>> order2 = new HashMap<>();
        order2.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 2.0))));

        producer1.getOrderByDay().put(1, order1);
        producer1.getOrderByDay().put(2, order2);

        Map<Integer,ArrayList<Product>> order3 = new HashMap<>();
        order3.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        Map<Integer,ArrayList<Product>> order4 = new HashMap<>();
        order4.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 1.0))));
        order4.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 6.0))));

        Producer producer2 = new Producer( "CT6", 41.1495,-8.6108, "P2");

        //Geração de dados para o mapa de produtor do shipment
        producer2.getOrderByDay().put(1, order3);
        producer2.getOrderByDay().put(2, order4);

        Map<String, Producer> produtor1 = new HashMap<>();
        Map<String, Producer> produtor2 = new HashMap<>();

        produtor1.put("CT6", producer2);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();

        //Geração de dados para producersWithOrders
        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = new HashMap<>();

        Map<Integer, ArrayList<Producer>> day1Producers = new HashMap<>();
        day1Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day1Producers.put(2, new ArrayList<>(List.of(producer1)));

        Map<Integer, ArrayList<Producer>> day2Producers = new HashMap<>();
        day2Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day2Producers.put(2, new ArrayList<>(Arrays.asList(producer1, producer2)));

        producersWithOrders.put(1, day1Producers);
        producersWithOrders.put(2, day2Producers);

        try {
            distributionNetworkUS309_small.generateShipmentList(day, n);
        } catch (IllegalArgumentException e) {
            assertEquals("Não existem clientes com encomendas para o dia 2 definidos no sistema", e.getMessage());
        }
    }
    @Test
    public void testGenerateShipmentList_producersWithOrdersIsNull() {
        distributionNetworkUS309_small.defineHubs(10);
        int day = 1;
        int n = 3;

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));
        buyer1.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 4.8),new Product( 2, 3.0))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));
        buyer2.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.0),new Product( 2, 3.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 7.0))));
        order1.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 3.3))));

        Map<Integer,ArrayList<Product>> order2 = new HashMap<>();
        order2.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 2.0))));

        producer1.getOrderByDay().put(1, order1);
        producer1.getOrderByDay().put(2, order2);

        Map<Integer,ArrayList<Product>> order3 = new HashMap<>();
        order3.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        Map<Integer,ArrayList<Product>> order4 = new HashMap<>();
        order4.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 1.0))));
        order4.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 6.0))));

        Producer producer2 = new Producer( "CT6", 41.1495,-8.6108, "P2");

        //Geração de dados para o mapa de produtor do shipment
        producer2.getOrderByDay().put(1, order3);
        producer2.getOrderByDay().put(2, order4);

        Map<String, Producer> emptyProdutor = new HashMap<>();

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));
        buyersWithOrders.put(2, new ArrayList<>(Arrays.asList(buyer1, buyer2)));

        //Geração de dados para producersWithOrders

        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = new HashMap<>();
        distributionNetworkUS309_small.setProducersWithOrders(producersWithOrders);

        //Obtenção dos shipments
        List<Shipment> shipmentsActual = distributionNetworkUS309_small.generateShipmentList(day, n);

        Company hub1 = new Company("CT2", 38.0333, -7.8833,"E1");
        Company hub2 = new Company("CT5", 41.3002, -7.7398,"E2");

        //Geração de um shipment
        List<Shipment> shipmentsExpected = null;

        assertEquals(shipmentsExpected,shipmentsActual);
    }

    @Test
    public void testGenerateShipmentList_N_EqualThanZero() {
        distributionNetworkUS309_small.defineHubs(10);
        int day = 1;
        int n = 0;

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));
        buyer1.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 4.8),new Product( 2, 3.0))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));
        buyer2.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.0),new Product( 2, 3.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 7.0))));
        order1.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 3.3))));

        Map<Integer,ArrayList<Product>> order2 = new HashMap<>();
        order2.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 2.0))));

        producer1.getOrderByDay().put(1, order1);
        producer1.getOrderByDay().put(2, order2);

        Map<Integer,ArrayList<Product>> order3 = new HashMap<>();
        order3.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        Map<Integer,ArrayList<Product>> order4 = new HashMap<>();
        order4.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 1.0))));
        order4.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 6.0))));

        Producer producer2 = new Producer( "CT6", 41.1495,-8.6108, "P2");

        //Geração de dados para o mapa de produtor do shipment
        producer2.getOrderByDay().put(1, order3);
        producer2.getOrderByDay().put(2, order4);

        Map<String, Producer> produtor1 = new HashMap<>();
        Map<String, Producer> produtor2 = new HashMap<>();

        produtor1.put("CT1", producer1);
        produtor1.put("CT6", producer2);
        produtor2.put("CT1", producer1);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));
        buyersWithOrders.put(2, new ArrayList<>(Arrays.asList(buyer1, buyer2)));

        //Geração de dados para producersWithOrders
        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = new HashMap<>();

        Map<Integer, ArrayList<Producer>> day1Producers = new HashMap<>();
        day1Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day1Producers.put(2, new ArrayList<>(List.of(producer1)));

        Map<Integer, ArrayList<Producer>> day2Producers = new HashMap<>();
        day2Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day2Producers.put(2, new ArrayList<>(Arrays.asList(producer1, producer2)));

        producersWithOrders.put(1, day1Producers);
        producersWithOrders.put(2, day2Producers);

        //Obtenção dos shipments
        try {
            List<Shipment> shipmentsActual = distributionNetworkUS309_small.generateShipmentList(day, n);
        } catch (IllegalArgumentException e) {
            assertEquals("O número de produtores tem de ser maior que 0", e.getMessage());
        }
    }

    @Test
    public void testGenerateShipmentList_N_LessThanZero() {
        distributionNetworkUS309_small.defineHubs(10);
        int day = 1;
        int n = -1;

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));
        buyer1.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 4.8),new Product( 2, 3.0))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));
        buyer2.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.0),new Product( 2, 3.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 7.0))));
        order1.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 3.3))));

        Map<Integer,ArrayList<Product>> order2 = new HashMap<>();
        order2.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 2.0))));

        producer1.getOrderByDay().put(1, order1);
        producer1.getOrderByDay().put(2, order2);

        Map<Integer,ArrayList<Product>> order3 = new HashMap<>();
        order3.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        Map<Integer,ArrayList<Product>> order4 = new HashMap<>();
        order4.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 1.0))));
        order4.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 6.0))));

        Producer producer2 = new Producer( "CT6", 41.1495,-8.6108, "P2");

        //Geração de dados para o mapa de produtor do shipment
        producer2.getOrderByDay().put(1, order3);
        producer2.getOrderByDay().put(2, order4);

        Map<String, Producer> produtor1 = new HashMap<>();
        Map<String, Producer> produtor2 = new HashMap<>();

        produtor1.put("CT1", producer1);
        produtor1.put("CT6", producer2);
        produtor2.put("CT1", producer1);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));
        buyersWithOrders.put(2, new ArrayList<>(Arrays.asList(buyer1, buyer2)));

        //Geração de dados para producersWithOrders
        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = new HashMap<>();

        Map<Integer, ArrayList<Producer>> day1Producers = new HashMap<>();
        day1Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day1Producers.put(2, new ArrayList<>(List.of(producer1)));

        Map<Integer, ArrayList<Producer>> day2Producers = new HashMap<>();
        day2Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day2Producers.put(2, new ArrayList<>(Arrays.asList(producer1, producer2)));

        producersWithOrders.put(1, day1Producers);
        producersWithOrders.put(2, day2Producers);

        //Obtenção dos shipments
        try {
            List<Shipment> shipmentsActual = distributionNetworkUS309_small.generateShipmentList(day, n);
        } catch (IllegalArgumentException e) {
            assertEquals("O número de produtores tem de ser maior que 0", e.getMessage());
        }
    }

    @Test
    public void testGenerateShipmentList_DayNotExist() {
        distributionNetworkUS309_small.defineHubs(10);
        int day = 7;
        int n = 1;

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));
        buyer1.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 4.8),new Product( 2, 3.0))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));
        buyer2.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.0),new Product( 2, 3.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 7.0))));
        order1.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 3.3))));

        Map<Integer,ArrayList<Product>> order2 = new HashMap<>();
        order2.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 2.0))));

        producer1.getOrderByDay().put(1, order1);
        producer1.getOrderByDay().put(2, order2);

        Map<Integer,ArrayList<Product>> order3 = new HashMap<>();
        order3.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        Map<Integer,ArrayList<Product>> order4 = new HashMap<>();
        order4.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 1.0))));
        order4.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 6.0))));

        Producer producer2 = new Producer( "CT6", 41.1495,-8.6108, "P2");

        //Geração de dados para o mapa de produtor do shipment
        producer2.getOrderByDay().put(1, order3);
        producer2.getOrderByDay().put(2, order4);

        Map<String, Producer> produtor1 = new HashMap<>();
        Map<String, Producer> produtor2 = new HashMap<>();

        produtor1.put("CT1", producer1);
        produtor1.put("CT6", producer2);
        produtor2.put("CT1", producer1);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));
        buyersWithOrders.put(2, new ArrayList<>(Arrays.asList(buyer1, buyer2)));

        //Geração de dados para producersWithOrders
        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = new HashMap<>();

        Map<Integer, ArrayList<Producer>> day1Producers = new HashMap<>();
        day1Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day1Producers.put(2, new ArrayList<>(List.of(producer1)));

        Map<Integer, ArrayList<Producer>> day2Producers = new HashMap<>();
        day2Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day2Producers.put(2, new ArrayList<>(Arrays.asList(producer1, producer2)));

        producersWithOrders.put(1, day1Producers);
        producersWithOrders.put(2, day2Producers);

        //Obtenção dos shipments
        try {
            List<Shipment> shipmentsActual = distributionNetworkUS309_small.generateShipmentList(day, n);
        } catch (IllegalArgumentException e) {
            assertEquals("Não existem clientes com encomendas para o dia "+day+" definidos no sistema", e.getMessage());
        }

    }
    @Test
    public void testGenerateShipmentList_noHubsDefined() {
        distributionNetworkUS309_small.defineHubs(0);
        int day = 1;
        int n = 1;

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));
        buyer1.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 4.8),new Product( 2, 3.0))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));
        buyer2.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.0),new Product( 2, 3.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 7.0))));
        order1.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 3.3))));

        Map<Integer,ArrayList<Product>> order2 = new HashMap<>();
        order2.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 2.0))));

        producer1.getOrderByDay().put(1, order1);
        producer1.getOrderByDay().put(2, order2);

        Map<Integer,ArrayList<Product>> order3 = new HashMap<>();
        order3.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        Map<Integer,ArrayList<Product>> order4 = new HashMap<>();
        order4.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 1.0))));
        order4.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 6.0))));

        Producer producer2 = new Producer( "CT6", 41.1495,-8.6108, "P2");

        //Geração de dados para o mapa de produtor do shipment
        producer2.getOrderByDay().put(1, order3);
        producer2.getOrderByDay().put(2, order4);

        Map<String, Producer> produtor1 = new HashMap<>();
        Map<String, Producer> produtor2 = new HashMap<>();

        produtor1.put("CT1", producer1);
        produtor1.put("CT6", producer2);
        produtor2.put("CT1", producer1);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));
        buyersWithOrders.put(2, new ArrayList<>(Arrays.asList(buyer1, buyer2)));

        //Geração de dados para producersWithOrders
        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = new HashMap<>();

        Map<Integer, ArrayList<Producer>> day1Producers = new HashMap<>();
        day1Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day1Producers.put(2, new ArrayList<>(List.of(producer1)));

        Map<Integer, ArrayList<Producer>> day2Producers = new HashMap<>();
        day2Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day2Producers.put(2, new ArrayList<>(Arrays.asList(producer1, producer2)));

        producersWithOrders.put(1, day1Producers);
        producersWithOrders.put(2, day2Producers);

        //Obtenção dos shipments
        try {
            List<Shipment> shipmentsActual = distributionNetworkUS309_small.generateShipmentList(day, n);
        } catch (IllegalArgumentException e) {
            assertEquals("Não existem hubs definidos no sistema", e.getMessage());
        }
    }

    //US310
    @Test
    public void generateDeliveryRoutes(){
        distributionNetworkUS308.defineHubs(1);
        distributionNetworkUS308.generateShipmentList(1);
        Map<Shipment,ArrayList<Delivery>> result = distributionNetworkUS308.generateDeliveryRoutes(1,1);
        Map<Shipment,ArrayList<Delivery>> expected = new HashMap<>();
        // Shipments
        Client c1 = new Client("CT1",0.0,0.0,"C");
        Client c2 = new Client("CT2",0.0,0.0,"C");
        Company closestHub = new Company("CT3",0.0,0.0,"E");
        Producer p1 = new Producer("CT4",0.0,0.0,"P");
        Double q1 = 1.0;
        Double q2 = 2.0;
        Double q3 = 5.5;
        Double q4 = 4.5;
        Product prod1 = new Product(1,0.0);
        Product prod2 = new Product(2,0.0);
        Product prod3 = new Product(3,0.0);
        Shipment s1 = new Shipment(c1,closestHub);
        s1.addProducer(p1);
        s1.addQuantity(q1);
        s1.addQuantity(q2);
        s1.addProduct(prod1);
        s1.addProduct(prod2);
        Shipment s2 = new Shipment(c2,closestHub);
        s2.addProducer(p1);
        s2.addQuantity(q1);
        s2.addQuantity(q3);
        s2.addQuantity(q4);
        s2.addProduct(prod1);
        s2.addProduct(prod2);
        s2.addProduct(prod3);


        //Deliveries
        LinkedList<DistributionNetworkMember> visitedVertices1 = new LinkedList<>();

        visitedVertices1.add(p1);
        visitedVertices1.add(closestHub);
        DistributionNetwork.Track deliveryRoute1 = new DistributionNetwork.Track(110848);
        Delivery delivery1 = new Delivery(visitedVertices1,deliveryRoute1);

        ArrayList<Delivery> deliveries1= new ArrayList<>();
        deliveries1.add(delivery1);

        expected.put(s1,deliveries1);



        ArrayList<Delivery> deliveries2= new ArrayList<>();
        deliveries2.add(delivery1);

        expected.put(s2,deliveries2);
        assertEquals(result,expected);
    }

    @Test
    public void generateDeliveryRoutesNullExpeditionList(){
        distributionNetworkUS308.defineHubs(1);
        distributionNetworkUS308.generateShipmentList(1);
        // Day 2 expedition list was not created, so it should be null
        Map<Shipment,ArrayList<Delivery>> result = distributionNetworkUS308.generateDeliveryRoutes(2,1);
        assertNull(result);
    }
    @Test
    public void generateDeliveryRoutesTimeSpent(){
        long startTime = System.currentTimeMillis();
        distributionNetworkBig.defineHubs(1);
        System.out.println("End define hubs");
        long endTimeDefineHubs = System.currentTimeMillis();
        long totalTimeDefineHubs = endTimeDefineHubs - startTime;
        System.out.println(totalTimeDefineHubs/1000+" s");

        distributionNetworkBig.generateShipmentList(1);
        System.out.println("End generate shipment list");
        long endTimeGenerateShipmentList = System.currentTimeMillis();
        long totalTimeDefineHubsShipmentList = endTimeGenerateShipmentList - endTimeDefineHubs;
        System.out.println(totalTimeDefineHubsShipmentList/1000+" s");

        Map<Shipment,ArrayList<Delivery>> result = distributionNetworkBig.generateDeliveryRoutes(1,1);
        System.out.println("End generate delivery routes.");
        long endTimeGenerateDeliveryRoutes = System.currentTimeMillis();
        long totalTimeGenerateDeliveryRoutes = endTimeGenerateDeliveryRoutes - endTimeGenerateShipmentList;
        System.out.println(totalTimeGenerateDeliveryRoutes/1000+" s");
        assertEquals(result,result);
    }

    @Test
    public void testGenerateForAllDaysShipmentList() {
        distributionNetworkUS309_small.defineHubs(10);
        int day = 2;
        int n = 3;

        //Geração de dados dos clientes
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        buyer1.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.2),new Product( 2, 3.3))));
        buyer1.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 4.8),new Product( 2, 3.0))));

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        buyer2.getOrderByDay().put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));
        buyer2.getOrderByDay().put(2, new ArrayList<Product>(Arrays.asList(new Product( 1, 2.0),new Product( 2, 3.0))));

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");

        Map<Integer,ArrayList<Product>> order1 = new HashMap<>();
        order1.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 7.0))));
        order1.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 3.3))));

        Map<Integer,ArrayList<Product>> order2 = new HashMap<>();
        order2.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 2.0))));

        producer1.getOrderByDay().put(1, order1);
        producer1.getOrderByDay().put(2, order2);

        Map<Integer,ArrayList<Product>> order3 = new HashMap<>();
        order3.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 5.0))));

        Map<Integer,ArrayList<Product>> order4 = new HashMap<>();
        order4.put(1, new ArrayList<Product>(Arrays.asList(new Product( 1, 1.0))));
        order4.put(2, new ArrayList<Product>(Arrays.asList(new Product( 2, 6.0))));

        Producer producer2 = new Producer( "CT6", 41.1495,-8.6108, "P2");

        //Geração de dados para o mapa de produtor do shipment
        producer2.getOrderByDay().put(1, order3);
        producer2.getOrderByDay().put(2, order4);

        Map<String, Producer> produtor1 = new HashMap<>();
        Map<String, Producer> produtor2 = new HashMap<>();

        produtor1.put("CT6", producer2);
        produtor2.put("CT1",producer1);
        produtor2.put("CT6", producer2);

        //Geração de dados para buyersWithOrders
        Map<Integer, ArrayList<Buyer>> buyersWithOrders = new HashMap<>();
        buyersWithOrders.put(1, new ArrayList<>(Arrays.asList(buyer1, buyer2)));
        buyersWithOrders.put(2, new ArrayList<>(Arrays.asList(buyer1, buyer2)));

        //Geração de dados para producersWithOrders
        Map<Integer, Map<Integer, ArrayList<Producer>>> producersWithOrders = new HashMap<>();

        Map<Integer, ArrayList<Producer>> day1Producers = new HashMap<>();
        day1Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day1Producers.put(2, new ArrayList<>(List.of(producer1)));

        Map<Integer, ArrayList<Producer>> day2Producers = new HashMap<>();
        day2Producers.put(1, new ArrayList<>(Arrays.asList(producer1, producer2)));
        day2Producers.put(2, new ArrayList<>(Arrays.asList(producer1, producer2)));

        producersWithOrders.put(1, day1Producers);
        producersWithOrders.put(2, day2Producers);

        //Obtenção dos shipments
        List<Shipment> shipmentsActual = distributionNetworkUS309_small.generateShipmentList(day, n);

        Company hub1 = new Company("CT2", 38.0333, -7.8833,"E1");
        Company hub2 = new Company("CT5", 41.3002, -7.7398,"E2");

        //Geração de um shipment
        List<Shipment> shipmentsExpected = new ArrayList<>();
        shipmentsExpected.add(new Shipment(buyer1,hub2,produtor1, List.of(3.0),Arrays.asList(new Product( 2, 3.0))));
        shipmentsExpected.add(new Shipment(buyer2,hub1,produtor2, Arrays.asList(2.0,3.0), Arrays.asList(new Product(1,2.0),new Product(2, 3.0))));

        assertEquals(shipmentsExpected,shipmentsActual);
    }
    @Test
    public void generateAnalysisTestNull() {
        distributionNetworkSmall.defineHubs(10);
        ShipmentAnalysis shipmentAnalysis = distributionNetworkSmall.generateAnalysis(1,2);
        assertNull(shipmentAnalysis);

    }

    @Test
    public void generateAnalysisTestSmallUS309() {
        distributionNetworkUS309_small.defineHubs(1);
        List<Shipment> shi = distributionNetworkUS309_small.generateShipmentList(1);
        ShipmentAnalysis test = distributionNetworkUS309_small.generateAnalysis(1,1);

        //Buyer
        Buyer buyer1 = new Buyer("CT4", 41.7, -8.8333);

        Buyer buyer2 = new Buyer( "CT3", 41.5333,-8.4167);

        //Producer

        //Geração de dados dos produtores
        Producer producer1 = new Producer("CT1", 40.6389, -8.6553,"P1");
        Producer producer2 = new Producer( "CT6", 41.1495,-8.6108, "P2");

        //Companhia
        Company hub1 = new Company("CT2", 38.0333, -7.8833,"E1");

        ArrayList<BasketAnalysis> listB = new ArrayList<>();
        listB.add(new BasketAnalysis(2,0,100.0,1));
        listB.add(new BasketAnalysis(1,0,100.0,1));


        ArrayList<ClientAnalysis> listC = new ArrayList<>();

        listC.add(new ClientAnalysis(buyer1,1,0,1));
        listC.add(new ClientAnalysis(buyer2,1,0,1));

        ArrayList<ProducerAnalysis> listP = new ArrayList<>();
        listP.add(new ProducerAnalysis(producer1,1,1,0,1,1));
        listP.add(new ProducerAnalysis(producer2,1,1,0,1,1));

        ArrayList<HubAnalysis> listH = new ArrayList<>();
        listH.add(new HubAnalysis(hub1,2,2));
        ShipmentAnalysis expected = new ShipmentAnalysis(listB,listC,listP,listH);

        assertEquals(test,expected);
    }

    @Test
    public void generateAnalysisBig() {
        distributionNetworkBig.defineHubs(10);
        List<Shipment> actual = distributionNetworkBig.generateShipmentList(5);
        assertEquals(actual, actual);
        ShipmentAnalysis shipmentAnalysis = distributionNetworkBig.generateAnalysis(1,5);
        assertEquals(shipmentAnalysis,shipmentAnalysis);
    }
}


