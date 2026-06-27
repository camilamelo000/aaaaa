package com.farmacia.clientes.service;

import com.farmacia.clientes.dto.ClienteDTO;
import com.farmacia.clientes.model.Cliente;
import com.farmacia.clientes.repository.ClienteRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClienteService {

    private final ClienteRepository repository;

    public ClienteService(ClienteRepository repository) {
        this.repository = repository;
    }

    public Cliente salvar(ClienteDTO dto) {

        Cliente cliente = new Cliente();

        cliente.setNome(dto.getNome());
        cliente.setCpf(dto.getCpf());
        cliente.setIdade(dto.getIdade());
        cliente.setConvenio(dto.getConvenio());
        cliente.setPercentualConvenio(dto.getPercentualConvenio());
        cliente.setBonificacao(dto.getBonificacao());
        cliente.setPercentualBonificacao(dto.getPercentualBonificacao());

        return repository.save(cliente);
    }

    public List<Cliente> listar() {
        return repository.findAll();
    }

    public Optional<Cliente> buscarPorId(Long id) {
        return repository.findById(id);
    }

    public Optional<Cliente> buscarPorCpf(String cpf) {
        return repository.findByCpf(cpf);
    }

    public Cliente atualizar(Long id, ClienteDTO dto) {

        Cliente cliente = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cliente não encontrado."));

        cliente.setNome(dto.getNome());
        cliente.setCpf(dto.getCpf());
        cliente.setIdade(dto.getIdade());
        cliente.setConvenio(dto.getConvenio());
        cliente.setPercentualConvenio(dto.getPercentualConvenio());
        cliente.setBonificacao(dto.getBonificacao());
        cliente.setPercentualBonificacao(dto.getPercentualBonificacao());

        return repository.save(cliente);
    }

    public void excluir(Long id) {

        Cliente cliente = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cliente não encontrado."));

        repository.delete(cliente);
    }

}