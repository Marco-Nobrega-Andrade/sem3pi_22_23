package Project.model;

import java.util.*;

public class Shipment {
    private Buyer cliente;
    private Company hub;
    private Map<String, Producer> produtor;
    private List<Double> qntyExpedido;
    private List<Product> produto;

    public Shipment(Buyer cliente, Company hub) {
        this.cliente = cliente;
        this.hub = hub;
        this.produtor = new HashMap<>();
        this.qntyExpedido = new ArrayList<>();
        this.produto = new ArrayList<>();
    }

    public Shipment(Buyer cliente, Company hub,Map<String, Producer> produtor,
                    List<Double> qntyExpedido, List<Product> produto) {
        this.cliente = cliente;
        this.hub = hub;
        this.produtor = produtor;
        this.qntyExpedido = qntyExpedido;
        this.produto = produto;
    }

    public Company getHub() {
        return hub;
    }

    public void setHub(Company hub) {
        this.hub = hub;
    }

    public Buyer getCliente() {
        return cliente;
    }

    public void setCliente(Buyer cliente) {
        this.cliente = cliente;
    }

    public Map<String, Producer> getProdutor() {
        return produtor;
    }

    public void setProdutor(Map<String, Producer> produtor) {
        this.produtor = produtor;
    }

    public List<Double> getQntyExpedido() {
        return qntyExpedido;
    }

    public void setQntyExpedido(List<Double> qntyExpedido) {
        this.qntyExpedido = qntyExpedido;
    }

    public List<Product> getProduto() {
        return produto;
    }

    public void setProduto(List<Product> produto) {
        this.produto = produto;
    }

    public void addProducer(Producer producer){
        produtor.putIfAbsent(producer.getLocId(), producer);
    }

    public void addQuantity(Double quantity){
        qntyExpedido.add(quantity);
    }

    public void addProduct(Product product){
       produto.add(product);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Shipment shipment = (Shipment) o;
        return Objects.equals(cliente, shipment.cliente) && Objects.equals(hub, shipment.hub) && Objects.equals(produtor, shipment.produtor) && Objects.equals(qntyExpedido, shipment.qntyExpedido) && Objects.equals(produto, shipment.produto);
    }

    @Override
    public int hashCode() {
        return Objects.hash(cliente, hub, produtor, qntyExpedido, produto);
    }

    @Override
    public String toString() {
        return "Expedição: " +
                "Cliente = " + cliente +
                ", Hub = " +  hub +
                ", Produtores = " + produtor.values() +
                ", Produtos = " + produto +
                ", Quantidades expedidas p/produto = " + qntyExpedido;
    }
}