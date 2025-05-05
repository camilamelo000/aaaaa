import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.ReentrantLock;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;
import java.util.concurrent.TimeUnit;

class Acao {
    private final String simbolo;
    private final AtomicInteger preco;
    private final List<Consumer<Integer>> observadores = new ArrayList<>();
    private final ReentrantLock lock = new ReentrantLock();

    public Acao(String simbolo, int precoInicial) {
        this.simbolo = simbolo;
        this.preco = new AtomicInteger(precoInicial);
    }

    public String getSimbolo() {
        return simbolo;
    }

    public int getPreco() {
        return preco.get();
    }

    public void setPreco(int novoPreco) {
        if (lock.tryLock()) {
            try {
                int precoAntigo = this.preco.getAndSet(novoPreco);
                notificarObservadores(novoPreco);
            } finally {
                lock.unlock();
            }
        }
    }

    public void adicionarObservador(Consumer<Integer> observador) {
        observadores.add(observador);
    }

    private void notificarObservadores(int novoPreco) {
        for (Consumer<Integer> observador : observadores) {
            observador.accept(novoPreco);
        }
    }
}

class Investidor implements Runnable {
    private final String nome;
    private final Acao acao;
    private final int precoAlvo;

    public Investidor(String nome, Acao acao, int precoAlvo) {
        this.nome = nome;
        this.acao = acao;
        this.acao.adicionarObservador(this::reagirAPreco);
    }

    public void reagirAPreco(int novoPreco) {
        if (novoPreco >= precoAlvo) {
            System.out.println("Investidor " + nome + ": Preço de " + acao.getSimbolo() + " atingiu ou ultrapassou $" + precoAlvo + " (preço atual: $" + novoPreco + ").");
        }
    }

    @Override
    public void run() {
        System.out.println("Investidor " + nome + " monitorando " + acao.getSimbolo() + " (alvo: $" + precoAlvo + ").");
    }
}

class AtualizadorPreco implements Runnable {
    private final Acao acao;
    private final Random random = new Random();

    public AtualizadorPreco(Acao acao) {
        this.acao = acao;
    }

    @Override
    public void run() {
        for (int i = 0; i < 10; i++) {
            int variacao = random.nextInt(21) - 10; // Variação entre -10 e +10
            acao.setPreco(acao.getPreco() + variacao);
            try {
                TimeUnit.MILLISECONDS.sleep(random.nextInt(500) + 500); // Intervalo entre 0.5 e 1 segundo
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
}

public class SimuladorBolsa {
    public static void main(String[] args) throws InterruptedException {
        ConcurrentHashMap<String, Acao> acoes = new ConcurrentHashMap<>();
        acoes.put("AAPL", new Acao("AAPL", 150));
        acoes.put("GOOG", new Acao("GOOG", 2500));

        ExecutorService executor = Executors.newFixedThreadPool(5);

        executor.submit(new AtualizadorPreco(acoes.get("AAPL")));
        executor.submit(new AtualizadorPreco(acoes.get("GOOG")));

        executor.submit(new Investidor("Alice", acoes.get("AAPL"), 160));
        executor.submit(new Investidor("Bob", acoes.get("GOOG"), 2550));

        executor.shutdown();
        executor.awaitTermination(1, TimeUnit.MINUTES);
    }
}
