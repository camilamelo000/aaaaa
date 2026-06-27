package com.farmacia.relatorios.service;

import com.farmacia.relatorios.dto.RelatorioDTO;
import com.farmacia.relatorios.model.Relatorio;
import com.farmacia.relatorios.repository.RelatorioRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class RelatorioService {

    private final RelatorioRepository repository;
    private final RestTemplate restTemplate;

    private static final String URL_PRODUTOS = "http://localhost:8081/produtos";
    private static final String URL_VENDAS = "http://localhost:8082/vendas";
    private static final String URL_CLIENTES = "http://localhost:8083/clientes";
    private static final String URL_NOTAS = "http://localhost:8084/notas";
    private static final String URL_RECEITAS = "http://localhost:8085/receitas";

    public RelatorioService(RelatorioRepository repository,
                            RestTemplate restTemplate) {
        this.repository = repository;
        this.restTemplate = restTemplate;
    }

    public Relatorio gerarRelatorio(RelatorioDTO dto) {

        Relatorio relatorio = new Relatorio();

        relatorio.setTipo(dto.getTipo());
        relatorio.setDescricao(dto.getDescricao());
        relatorio.setDataInicio(dto.getDataInicio());
        relatorio.setDataFim(dto.getDataFim());
        relatorio.setDataGeracao(LocalDate.now());

        Integer quantidadeRegistros = 0;

        switch (dto.getTipo().toUpperCase()) {

            case "PRODUTOS":
                Object[] produtos = restTemplate.getForObject(
                        URL_PRODUTOS,
                        Object[].class
                );

                quantidadeRegistros = produtos != null ? produtos.length : 0;
                break;

            case "VENDAS":
                Object[] vendas = restTemplate.getForObject(
                        URL_VENDAS,
                        Object[].class
                );

                quantidadeRegistros = vendas != null ? vendas.length : 0;
                break;

            case "CLIENTES":
                Object[] clientes = restTemplate.getForObject(
                        URL_CLIENTES,
                        Object[].class
                );

                quantidadeRegistros = clientes != null ? clientes.length : 0;
                break;

            case "NOTAS":
                Object[] notas = restTemplate.getForObject(
                        URL_NOTAS,
                        Object[].class
                );

                quantidadeRegistros = notas != null ? notas.length : 0;
                break;

            case "RECEITAS":
                Object[] receitas = restTemplate.getForObject(
                        URL_RECEITAS,
                        Object[].class
                );

                quantidadeRegistros = receitas != null ? receitas.length : 0;
                break;

            default:
                quantidadeRegistros = 0;
        }

        relatorio.setQuantidadeRegistros(quantidadeRegistros);

        return repository.save(relatorio);
    }

    public List<Relatorio> listar() {
        return repository.findAll();
    }

    public Optional<Relatorio> buscarPorId(Long id) {
        return repository.findById(id);
    }

    public List<Relatorio> buscarPorTipo(String tipo) {
        return repository.findByTipo(tipo);
    }

    public Relatorio atualizar(Long id, RelatorioDTO dto) {

        Relatorio relatorio = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Relatório não encontrado."));

        relatorio.setTipo(dto.getTipo());
        relatorio.setDescricao(dto.getDescricao());
        relatorio.setDataInicio(dto.getDataInicio());
        relatorio.setDataFim(dto.getDataFim());

        return repository.save(relatorio);
    }

    public void excluir(Long id) {

        Relatorio relatorio = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Relatório não encontrado."));

        repository.delete(relatorio);
    }

}