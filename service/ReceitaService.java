package com.farmacia.receitas.service;

import com.farmacia.receitas.dto.ReceitaDTO;
import com.farmacia.receitas.model.Receita;
import com.farmacia.receitas.repository.ReceitaRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class ReceitaService {

    private final ReceitaRepository repository;

    public ReceitaService(ReceitaRepository repository) {
        this.repository = repository;
    }

    public Receita registrarReceita(ReceitaDTO dto) {

        Receita receita = new Receita();

        receita.setIdVenda(dto.getIdVenda());
        receita.setNomePaciente(dto.getNomePaciente());
        receita.setCpfPaciente(dto.getCpfPaciente());
        receita.setMedicamento(dto.getMedicamento());
        receita.setCrmMedico(dto.getCrmMedico());

        receita.setDataReceita(LocalDate.now());

        receita.setStatus("ENVIADA_ANS");

        return repository.save(receita);
    }

    public List<Receita> listar() {
        return repository.findAll();
    }

    public Optional<Receita> buscarPorId(Long id) {
        return repository.findById(id);
    }

    public List<Receita> buscarPorCpf(String cpfPaciente) {
        return repository.findByCpfPaciente(cpfPaciente);
    }

    public List<Receita> buscarPorVenda(Long idVenda) {
        return repository.findByIdVenda(idVenda);
    }

    public List<Receita> buscarPorStatus(String status) {
        return repository.findByStatus(status);
    }

    public Receita atualizar(Long id, ReceitaDTO dto) {

        Receita receita = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Receita não encontrada."));

        receita.setIdVenda(dto.getIdVenda());
        receita.setNomePaciente(dto.getNomePaciente());
        receita.setCpfPaciente(dto.getCpfPaciente());
        receita.setMedicamento(dto.getMedicamento());
        receita.setCrmMedico(dto.getCrmMedico());

        return repository.save(receita);
    }

    public void excluir(Long id) {

        Receita receita = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Receita não encontrada."));

        repository.delete(receita);
    }

}