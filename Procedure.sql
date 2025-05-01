-- Criar Procedure --
DELIMITER &&
CREATE PROCEDURE nomeFilme(varidfilme int)
	begin
		select concat('Nome do filme: ', titulo) as Título
        from cinema.filme
        where idfilme = varidfilme;
	end;
&& 
DELIMITER ;
-- o && e $$ serve para não executar os comandos, não é possivel comentar dentro do delimiter --
-- parametro será uma variável --


-- Chamada da Procedure --
call nomeFilme(10);


-- Deletar Procedure --
 drop procedure nomeFilme;
 

DELIMITER $$
CREATE PROCEDURE acessaSessao(var int)
	begin
		select * from sessao
        where sala_idsala = var;
	end;
$$
DELIMITER ;

call acessaSessao(50);
call acessaSessao(51);


-- EXERCICIO 03 --
select * from filme;
DELIMITER $$
CREATE PROCEDURE acessaFilme(filmeInfo int)
	begin
		select sa.nome as 'sala', f.titulo as 'filme', se.dataHora as 'data', se.qtdeVenda as 'vendas'
		from sala sa inner  join sessao se 
		on sa.idsala = se.sala_idsala
		inner join filme f
		on f.idfilme = se.filme_idfilme
        where f.idfilme = filmeInfo;
	end;
$$
DELIMITER ;

call acessaFilme(12);


-- EXERCICIO 04 --
select * from filme;
DELIMITER &&
CREATE PROCEDURE verificaAgend(agendGen int)
	begin
		select f.titulo as 'filme', g.descricao as 'genero', s.dataHora as 'agendamento'
		from genero g inner join filme f 
		on g.idgenero = f.genero_idgenero
		inner join sessao s
		on f.idfilme = s.filme_idfilme
        where g.idgenero = agendGen;
	end;
&&
DELIMITER ;

call verificaAgend(1); 


-- EXERCICIO 05a --
select * from genero;
DELIMITER &&
CREATE PROCEDURE addGenero(gen int)
	begin
		INSERT INTO genero (`idgenero`,`descricao`) 
        VALUES (1,'Ação')       
	end;
&&
DELIMITER ;

-- EXERCICIO 05b --


-- EXERCICIO 05c1 --
DELIMITER &&
select * filme;
select * from sessao;
CREATE PROCEDURE sessaoSemAgend(sessAgend int)
	begin
		select f.*, se.dataHora, se.qtdeVenda
		from filme f left join sessao s
		on g.idgenero = f.genero_idgenero
		where id.sessao = sessAgend;
	end;
&&
DELIMITER ;



-- EXERCICIO 05c1 --

-- EXERCICIO 06 --


