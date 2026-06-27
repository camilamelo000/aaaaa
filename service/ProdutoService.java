package com.farmacia.produtos.service;

import com.farmacia.produtos.dto.ProdutoDTO;
import com.farmacia.produtos.model.Produto;
import com.farmacia.produtos.repository.ProdutoRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProdutoService {

    private final ProdutoRepository repository;

    public ProdutoService(ProdutoRepository repository) {
        this.repository = repository;
    }

    public Produto salvar(ProdutoDTO dto) {

        Produto produto = new Produto();

        produto.setNome(dto.getNome());
        produto.setPreco(dto.getPreco());
        produto.setTipo(dto.getTipo());
        produto.setEstoque(dto.getEstoque());

        return repository.save(produto);
    }

    public List<Produto> listar() {
        return repository.findAll();
    }

    public Optional<Produto> buscarPorId(Long id) {
        return repository.findById(id);
    }

    public Produto atualizar(Long id, ProdutoDTO dto) {

        Produto produto = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Produto não encontrado."));

        produto.setNome(dto.getNome());
        produto.setPreco(dto.getPreco());
        produto.setTipo(dto.getTipo());
        produto.setEstoque(dto.getEstoque());

        return repository.save(produto);
    }

    public void excluir(Long id) {

        Produto produto = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Produto não encontrado."));

        repository.delete(produto);
    }

}