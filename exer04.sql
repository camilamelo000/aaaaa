-- EXERCICIO 4A --

update grupo_produto
set descricaogrupo_produto = "Cadernos/Fichários"
where idgrupo_produto = 1;

select * from grupo_produto;

DELIMITER &&
CREATE PROCEDURE AlterarGrupoDescricao(varId int, varDescricao varchar(50))
	begin
		update grupo_produto
		set descricaogrupo_produto = varDescricao
		where idgrupo_produto = varId;
	end;
&& 
DELIMITER ;

call AlterarGrupoDescricao(1, "Cadernos/Fichários");
call AlterarGrupoDescricao(2, "Canetas/Lápis");
call AlterarGrupoDescricao(3, "Produtos de Informática");
call AlterarGrupoDescricao(4, "Mochilas/Estojos");
call AlterarGrupoDescricao(5, "Material de escritório");

select * from grupo_produto;


DELIMITER &&
CREATE PROCEDURE AlterarProduto(varId int, varDescricao varchar(50))
	begin
		update produto
		set descricaoproduto = varDescricao
		where codigoproduto = varId;
	end;
&& 
DELIMITER ;

call AlterarProduto(1, "Lápis preto");
call AlterarProduto(2, "Caneta bic");
call AlterarProduto(3, "Régua 15 cm");
call AlterarProduto(4, "Régua 30 cm");
call AlterarProduto(5, "Fichário Tilibra");
call AlterarProduto(6, "Mouse");

select * from produto;


DELIMITER &&
CREATE PROCEDURE AlterarGrupoId(varIdProduto int, varIdGrupo int)
	begin
		update produto
		set grupo_produto_idgrupo_produto = varIdGrupo
		where codigoproduto = varIdProduto;
	end;
&& 
DELIMITER ;

call AlterarGrupoId(1, 2);
call AlterarGrupoId(6, 3);
call AlterarGrupoId(3, 5);
call AlterarGrupoId(4, 5);

select * from produto;


-- EXERCICIO 4B --

DELIMITER &&
CREATE FUNCTION buscaMaiorIdProduto()
	RETURNS int
    NO SQL
BEGIN
	declare varMaiorId int;
	select codigoproduto into varMaiorId
    from produto
	order by codigoproduto desc
	limit 1;
	RETURN varMaiorId;
END&&
DELIMITER ;

select buscaMaiorIdProduto();

DELIMITER &&
CREATE PROCEDURE AdicionarProduto(
	varDescricao varchar(50), 
	preco_unitario decimal(15,2), 
	grupo_produto_idgrupo_produto int
)
begin
	declare calculo int;
	select ifnull(buscaMaiorIdProduto(), 0) + 1 into calculo;
	INSERT INTO dbvendasNovo.produto (codigoproduto, descricaoproduto, preco_unitario, grupo_produto_idgrupo_produto)
	VALUES (calculo, varDescricao, preco_unitario, grupo_produto_idgrupo_produto);
end;
&& 
DELIMITER ;

call AdicionarProduto("Toner HP", 50.00, 3);

select * from produto;



