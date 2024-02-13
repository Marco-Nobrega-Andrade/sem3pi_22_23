package Project.graph;

import Project.graph.matrix.MatrixGraph;
import Project.model.*;
import com.sun.source.tree.WhileLoopTree;

import java.lang.reflect.Array;
import java.util.*;
import java.util.function.BinaryOperator;

/**
 *
 * @author DEI-ISEP
 *
 */
public class Algorithms {

    /** Performs breadth-first search of a Graph starting in a vertex
     *
     * @param g Graph instance
     * @param vert vertex that will be the source of the search
     * @return a LinkedList with the vertices of breadth-first search
     */
    public static <V, E> LinkedList<V> BreadthFirstSearch(Graph<V, E> g, V vert) {
        if(g.key(vert) == -1) return null;

        boolean[] visited = new boolean[g.numVertices()];
        LinkedList<V> qbfs = new LinkedList<>();
        LinkedList<V> qaux = new LinkedList<>();

        qbfs.add(vert);
        qaux.add(vert);
        visited[g.key(vert)] = true;

        while (!qaux.isEmpty()){
            vert = qaux.getFirst();
            qaux.remove();
            for (V adjVertex : g.adjVertices(vert) ){
                if(!visited[g.key(adjVertex)] ){
                    qbfs.add(adjVertex);
                    qaux.add(adjVertex);
                    visited[g.key(adjVertex)] = true;
                }
            }
        }

        return qbfs;
    }

    /** Performs depth-first search starting in a vertex
     *
     * @param g Graph instance
     * @param vOrig vertex of graph g that will be the source of the search
     * @param visited set of previously visited vertices
     * @param qdfs return LinkedList with vertices of depth-first search
     */
    private static <V, E> void DepthFirstSearch(Graph<V, E> g, V vOrig, boolean[] visited, LinkedList<V> qdfs) {
        if (visited[g.key(vOrig)]){
            return;
        }

        qdfs.add(vOrig);
        visited[g.key(vOrig)] = true;

        for (V vAdj : g.adjVertices(vOrig)){
            DepthFirstSearch(g,vAdj,visited,qdfs);
        }

    }

    /** Performs depth-first search starting in a vertex
     *
     * @param g Graph instance
     * @param vert vertex of graph g that will be the source of the search

     * @return a LinkedList with the vertices of depth-first search
     */
    public static <V, E> LinkedList<V> DepthFirstSearch(Graph<V, E> g, V vert) {
        if (g.key(vert) == -1){
            return null;
        }
        LinkedList<V> qdfs = new LinkedList<>();
        DepthFirstSearch(g,vert,new boolean[g.numVertices()],qdfs);
        return qdfs;
    }

    public static <V, E> E shortestPath(Graph<V, E> g, V vOrig, V vDest,
                                        Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                        LinkedList<V> shortPath) {
        if (!g.validVertex(vOrig) || !g.validVertex(vDest)) {
            return null;
        }

        shortPath.clear();
        int numVerts = g.numVertices();
        boolean[] visited = new boolean[numVerts];
        V[] pathKeys = (V[]) new Object[numVerts];
        E[] dist = (E[]) new Object[numVerts];
        initializePathDist(numVerts, pathKeys, dist);

        shortestPathDijkstra(g, vOrig, ce, sum, zero, visited, pathKeys, dist);

        E lengthPath = dist[g.key(vDest)];

        if (lengthPath != null) {
            getPath(g, vOrig, vDest, pathKeys, shortPath);
            return lengthPath;
        }
        return null;
    }
    private static <V, E> void initializePathDist(int nVerts, V[] pathKeys, E[] dist) {
        for (int i = 0; i < nVerts; i++) {
            dist[i] = null;
            pathKeys[i] = null;
        }
    }
    /**
     * Computes shortest-path distance from a source vertex to all reachable
     * vertices of a graph g with non-negative edge weights
     * This implementation uses Dijkstra's algorithm
     *
     * @param g        Graph instance
     * @param vOrig    Vertex that will be the source of the path
     * @param visited  set of previously visited vertices
     * @param pathKeys minimum path vertices keys
     * @param dist     minimum distances
     */
    private static <V, E> void shortestPathDijkstra(Graph<V, E> g, V vOrig,
                                                    Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                                    boolean[] visited, V [] pathKeys, E [] dist) {
        int vkey = g.key(vOrig);
        dist[vkey] = zero;
        pathKeys[vkey] = vOrig;
        while (vOrig != null) {
            vkey = g.key(vOrig);
            visited[vkey] = true;
            for (Edge<V, E> edge : g.outgoingEdges(vOrig)) {
                int vkeyAdj = g.key(edge.getVDest());
                if (!visited[vkeyAdj]) {
                    E s = sum.apply(dist[vkey], edge.getWeight());
                    if (dist[vkeyAdj] == null || ce.compare(dist[vkeyAdj], s) > 0) {
                        dist[vkeyAdj] = s;
                        pathKeys[vkeyAdj] = vOrig;
                    }
                }
            }
            E minDist = null;
            vOrig = null;
            for (V vert : g.vertices()) {
                int i = g.key(vert);
                if (!visited[i] && (dist[i] != null) && ((minDist == null) || ce.compare(dist[i], minDist) < 0)) {
                    minDist = dist[i];
                    vOrig = vert;
                }
            }
        }
    }


    /** Shortest-path between two vertices
     *
     * @param g graph
     * @param vOrig origin vertex
     * @param vDest destination vertex
     * @param ce comparator between elements of type E
     * @param sum sum two elements of type E
     * @param zero neutral element of the sum in elements of type E
     * @param shortPath returns the vertices which make the shortest path
     * @return if vertices exist in the graph and are connected, true, false otherwise
     */

    /** Shortest-path between a vertex and all other vertices
     *
     * @param g graph
     * @param vOrig start vertex
     * @param ce comparator between elements of type E
     * @param sum sum two elements of type E
     * @param zero neutral element of the sum in elements of type E
     * @param paths returns all the minimum paths
     * @param dists returns the corresponding minimum distances
     * @return if vOrig exists in the graph true, false otherwise
     */
    public static <V, E> boolean shortestPaths(Graph<V, E> g, V vOrig,
                                               Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                               ArrayList<LinkedList<V>> paths, ArrayList<E> dists) {
        if (!g.validVertex(vOrig)) {return false;}

        paths.clear();
        dists.clear();
        int numVerts = g.numVertices();

        boolean [] visited = new boolean[numVerts];
        @SuppressWarnings("unchecked")
        V[] pathKeys = (V[]) new Object[numVerts];
        @SuppressWarnings("unchecked")
        E[] dist = (E[]) new Object[numVerts];
        initializePathDist(numVerts,pathKeys,dist);

        shortestPathDijkstra(g,vOrig,ce,sum,zero,visited,pathKeys,dist);

        dists.clear();
        paths.clear();

        for (int i = 0; i < numVerts; i++) {
            paths.add(null);
            dists.add(null);
        }

        for (V vDest: g.vertices()) {
            int key = g.key(vDest);
            if (dist[key]!=null){
                LinkedList<V> shortPath = new LinkedList<>();
                getPath(g,vOrig,vDest,pathKeys,shortPath);
                paths.set(key,shortPath);
                dists.set(key,dist[key]);
            }
        }

        return true;
    }

    /**
     * Extracts from pathKeys the minimum path between voInf and vdInf
     * The path is constructed from the end to the beginning
     *
     * @param g        Graph instance
     * @param vOrig    information of the Vertex origin
     * @param vDest    information of the Vertex destination
     * @param pathKeys minimum path vertices keys
     * @param path     stack with the minimum path (correct order)
     */
    private static <V, E> void getPath(Graph<V, E> g, V vOrig, V vDest,
                                       V [] pathKeys, LinkedList<V> path) {

        if(vOrig.equals(vDest)){
            path.push(vOrig);
        }else{
            path.push(vDest);
            int vKey = g.key(vDest);
            vDest = pathKeys[vKey];
            getPath(g, vOrig, vDest, pathKeys, path);
        }
    }

    /**
     * Calculates the minimum spanning tree using Kruskal algorithm
     * @param g initial graph
     * @param cmp comparator between elements of type E
     * @return  the minimum spanning tree
     */
    public static <V,E> Graph<V,E> minimumSpanningTreeKruskal(Graph<V,E> g , Comparator<E> cmp){
        if (g == null || g.isDirected() || !Algorithms.isConnected(g)){
            return null;
        }

        Graph<V,E> mst = new MatrixGraph<>(false);
        ArrayList<Edge<V, E>> edgeList = new ArrayList<>(g.edges());
        for (V vert : g.vertices()){
            mst.addVertex(vert);
        }
        edgeList.sort( (e1,e2) -> cmp.compare(e1.getWeight(), e2.getWeight()) );

        for (Edge<V, E> edge : edgeList){
            LinkedList<V> connectedVerts = DepthFirstSearch(mst,edge.getVOrig());
            if (connectedVerts !=  null) {
                if (!connectedVerts.contains(edge.getVDest())){
                    mst.addEdge(edge.getVOrig(),edge.getVDest(), edge.getWeight());
                }
            }
        }
        return mst;
    }
    /**
     * Checks if the graph is connected
     * @param g initial graph
     * @return true if the graph is connected, false otherwise
     */
    public static <V,E> boolean isConnected(Graph<V,E> g){
        if (g == null){
            return false;
        }
        if (g.numVertices() == 0){
            return false;
        }
        LinkedList<V> vertices = Algorithms.DepthFirstSearch(g,g.vertices().get(0));
        return vertices.size() == g.numVertices();
    }

    public static <V, E> int minEdgeBFS(Graph<V, E> g, V vOrg, V vDes){
        if(g==null||vOrg==null||vDes==null) return 0;
        int[] dist= new int[g.numVertices()];
        if (BFSminEdge(g,vOrg,vDes,dist)) {
            return dist[g.key(vDes)];
        }
        return 0;
    }

    private static <V, E>  boolean BFSminEdge(Graph<V, E> g, V vOrg, V vDes, int[] dist) {
        LinkedList<V> queue = new LinkedList<>();
        boolean[] visited = new boolean[g.numVertices()];
        Arrays.fill(dist,Integer.MAX_VALUE);

        visited[g.key(vOrg)]= true;
        dist[g.key(vOrg)]=0;
        queue.add(vOrg);

        while (!queue.isEmpty()) {
            V u = queue.remove();
            for (V adj: g.adjVertices(u)){
                if ( !visited[g.key(adj)]){
                    visited[g.key(adj)] = true;
                    dist[g.key(adj)] = dist[g.key(u)] +1;
                    queue.add(adj);

                    if (adj.equals(vDes)){
                        return true;
                    }
                }
            }
        }
        return false;
    }




    public static <V, E> DistributionNetworkMember findClientWithOrderBFS(Graph<V, E> g, V vOrg){
        LinkedList<V> qAux = new LinkedList<>();
        boolean[] visited = new boolean[g.numVertices()];
        visited[g.key(vOrg)]= true;
        qAux.add(vOrg);
        while (!qAux.isEmpty()) {
            vOrg = qAux.getFirst();
            qAux.remove();
            for (V adj: g.adjVertices(vOrg)){
                if (!visited[g.key(adj)]){
                    visited[g.key(adj)] = true;
                    if(adj instanceof Client && ((Client) adj).getOrderByDay()!=null) return (Client)adj;
                    else if(adj instanceof Company && ((Company) adj).getOrderByDay()!=null) return (Company)adj;
                }
            }
        }
        return null;
    }

}