import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.TimeUnit;

class Recurso {
    private final String nome;
    private final Lock lock = new ReentrantLock();

    public Recurso(String nome) {
        this.nome = nome;
    }

    public String getNome() {
        return nome;
    }

    public boolean tryLock(long timeout, TimeUnit unit) throws InterruptedException {
        return lock.tryLock(timeout, unit);
    }

    public void unlock() {
        lock.unlock();
    }
}

class ThreadRecursos implements Runnable {
    private final String nome;
    private final List<Recurso> recursosNecessarios;
    private final SistemaAlocacaoRecursos gerenciador;
    private final Random random = new Random();

    public ThreadRecursos(String nome, List<Recurso> recursosNecessarios, SistemaAlocacaoRecursos gerenciador) {
        this.nome = nome;
        this.recursosNecessarios = recursosNecessarios;
        this.gerenciador = gerenciador;
    }

    @Override
    public void run() {
        System.out.println(nome + " tentando adquirir recursos: " + recursosNecessarios);
        if (gerenciador.alocarRecursos(this, recursosNecessarios)) {
            System.out.println(nome + " adquiriu os recursos e está trabalhando...");
            try {
                Thread.sleep((long) (Math.random() * 500)); // Simula trabalho
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            } finally {
                System.out.println(nome + " liberando os recursos: " + recursosNecessarios);
                gerenciador.liberarRecursos(this, recursosNecessarios);
            }
        } else {
            System.out.println(nome + " não conseguiu todos os recursos.");
        }
    }

    public String getNome() {
        return nome;
    }
}

class SistemaAlocacaoRecursos {
    private final List<Recurso> recursosDisponiveis;
    private final Map<ThreadRecursos, List<Recurso>> recursosAlocados = new HashMap<>();
    private final List<ThreadRecursos> threads = new ArrayList<>();

    public SistemaAlocacaoRecursos(List<Recurso> recursosDisponiveis) {
        this.recursosDisponiveis = recursosDisponiveis;
    }

    public void adicionarThread(ThreadRecursos thread) {
        threads.add(thread);
    }

    public synchronized boolean alocarRecursos(ThreadRecursos thread, List<Recurso> recursosNecessarios) {
        List<Recurso> alocadosParaEstaThread = new ArrayList<>();
        try {
            for (Recurso recurso : recursosNecessarios) {
                if (recurso.tryLock(100, TimeUnit.MILLISECONDS)) {
                    alocadosParaEstaThread.add(recurso);
                } else {
                    // Não conseguiu todos os recursos, libera os que já tem
                    for (Recurso liberacao : alocadosParaEstaThread) {
                        liberacao.unlock();
                    }
                    return false;
                }
            }
            recursosAlocados.put(thread, alocadosParaEstaThread);
            return true;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            for (Recurso liberacao : alocadosParaEstaThread) {
                liberacao.unlock();
            }
            return false;
        }
    }

    public synchronized void liberarRecursos(ThreadRecursos thread, List<Recurso> recursosLiberar) {
        List<Recurso> alocados = recursosAlocados.get(thread);
        if (alocados != null && alocados.containsAll(recursosLiberar)) {
            for (Recurso recurso : recursosLiberar) {
                recurso.unlock();
            }
            alocados.removeAll(recursosLiberar);
            if (alocados.isEmpty()) {
                recursosAlocados.remove(thread);
            }
        }
    }

    // Implementação simplificada de detecção de deadlock (muito básica e não completa)
    public synchronized boolean detectarDeadlock() {
        // Uma implementação real exigiria um grafo de espera e análise de ciclos
        // Este é apenas um exemplo conceitual
        if (recursosAlocados.size() > recursosDisponiveis.size()) {
            System.out.println("Possível deadlock detectado (mais threads com recursos do que recursos disponíveis).");
            return true;
        }
        return false;
    }

    public void abortarThread(ThreadRecursos vitima) {
        List<Recurso> recursosDaVitima = recursosAlocados.remove(vitima);
        if (recursosDaVitima != null) {
            System.out.println("Abortando thread " + vitima.getNome() + " e liberando seus recursos.");
            for (Recurso recurso : recursosDaVitima) {
                recurso.unlock();
            }
            // Implementar mecanismo de rollback aqui (depende da lógica da thread)
            System.out.println("Rollback para thread " + vitima.getNome() + " (se aplicável).");
        }
    }

    // Seleção de vítima baseada em prioridade dinâmica (exemplo simples)
    public ThreadRecursos selecionarVitima() {
        // Em um sistema real, as prioridades poderiam ser ajustadas dinamicamente
        // com base no tempo de espera, recursos que a thread possui, etc.
        if (!recursosAlocados.isEmpty()) {
            return recursosAlocados.keySet().iterator().next(); // Escolhe a primeira thread alocada como vítima
        }
        return null;
    }
}

public class SistemaGerenciamentoRecursos {
    public static void main(String[] args) throws InterruptedException {
        List<Recurso> recursos = List.of(new Recurso("A"), new Recurso("B"));
        SistemaAlocacaoRecursos gerenciador = new SistemaAlocacaoRecursos(recursos);

        ThreadRecursos t1 = new ThreadRecursos("Thread 1", List.of(recursos.get(0), recursos.get(1)), gerenciador);
        ThreadRecursos t2 = new ThreadRecursos("Thread 2", List.of(recursos.get(1), recursos.get(0)), gerenciador);

        gerenciador.adicionarThread(t1);
        gerenciador.adicionarThread(t2);

        new Thread(t1).start();
        new Thread(t2).start();

        // Simula a detecção de deadlock após um tempo
        Thread.sleep(2000);
        if (gerenciador.detectarDeadlock()) {
            ThreadRecursos vitima = gerenciador.selecionarVitima();
            if (vitima != null) {
                gerenciador.abortarThread(vitima);
            }
        }
    }
}
