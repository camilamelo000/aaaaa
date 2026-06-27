package com.farmacia.notafiscal.service;

import com.farmacia.notafiscal.dto.NotaFiscalDTO;
import com.farmacia.notafiscal.model.NotaFiscal;
import com.farmacia.notafiscal.repository.NotaFiscalRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class NotaFiscalService {

    private final NotaFiscalRepository repository;

    public NotaFiscalService(NotaFiscalRepository repository) {
        this.repository = repository;
    }

    public NotaFiscal emitirNotaFiscal(NotaFiscalDTO dto) {

        NotaFiscal notaFiscal = new NotaFiscal();

        notaFiscal.setIdVenda(dto.getIdVenda());
        notaFiscal.setCpfCliente(dto.getCpfCliente());
        notaFiscal.setValorTotal(dto.getValorTotal());

        notaFiscal.setDataEmissao(LocalDate.now());

        notaFiscal.setStatus("ENVIADA_SEFAZ");

        return repository.save(notaFiscal);
    }

    public List<NotaFiscal> listar() {
        return repository.findAll();
    }

    public Optional<NotaFiscal> buscarPorId(Long id) {
        return repository.findById(id);
    }

    public List<NotaFiscal> buscarPorCpf(String cpf) {
        return repository.findByCpfCliente(cpf);
    }

    public List<NotaFiscal> buscarPorVenda(Long idVenda) {
        return repository.findByIdVenda(idVenda);
    }

    public List<NotaFiscal> buscarPorStatus(String status) {
        return repository.findByStatus(status);
    }

    public NotaFiscal atualizar(Long id, NotaFiscalDTO dto) {

        NotaFiscal notaFiscal = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Nota Fiscal não encontrada."));

        notaFiscal.setIdVenda(dto.getIdVenda());
        notaFiscal.setCpfCliente(dto.getCpfCliente());
        notaFiscal.setValorTotal(dto.getValorTotal());

        return repository.save(notaFiscal);
    }

    public void excluir(Long id) {

        NotaFiscal notaFiscal = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Nota Fiscal não encontrada."));

        repository.delete(notaFiscal);
    }

}