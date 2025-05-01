-- EXERCICIO 07 PT1 --

CREATE VIEW vwsolteiro AS
SELECT u.nomeusuario, p.datanascimento, p.email, p.estadocivil, u.apelidousuario 
 FROM usuario u
JOIN perfilsocial p
  ON u.idusuario = p.idusuario;

select * from vwsolteiro;

-- EXERCICIO 07 PT2 --

select * from vwsolteiro
where estadocivil like 's%';
-- like concat("%", var, "%");


-- EXERCICIO 08 PT1--

CREATE VIEW vwDadosCargo AS
SELECT pp.idusuario, u.nomeusuario, c.descricaocargo, p.nomeprofissao, s.nomesetor, e.nomeempresa, pp.admissao, pp.demissao
 FROM usuario u
JOIN perfilprofissional pp
  ON u.idusuario = pp.idusuario
JOIN cargo c
  ON c.idcargo = pp.idcargo
JOIN profissao p
  ON p.idprofissao = pp.idprofissao
JOIN empresa e
  ON e.idempresa = pp.idempresa
JOIN setor s
  ON s.idsetor = e.idsetor;
  
select * from vwDadosCargo;

-- EXERCICIO 08 PT2 --

DELIMITER $$
CREATE PROCEDURE buscaDadosCargoPorUsuario(varId int)
	begin
		select * from vwDadosCargo
        where idusuario = varId;
	end;
$$
DELIMITER ;

call buscaDadosCargoPorUsuario(1);
call buscaDadosCargoPorUsuario(4);

select * from perfilprofissional;

-- EXERCICIO 08 PT3--

DELIMITER $$
CREATE PROCEDURE buscaDadosCargoPorNome(varNome varchar(45))
	begin
		select * from vwDadosCargo
        where nomeusuario = varNome;
	end;
$$
DELIMITER ;

call buscaDadosCargoPorNome('André Leme');
call buscaDadosCargoPorNome('Arlete Antunes');


-- EXERCICIO 09 --

CREATE VIEW vwacademico AS
SELECT n.descricaonivelFormacao, i.nomeinstituicao, i.siglainstituicao, c.nomecurso, p.*
from perfilacademico p
join nivelformacao n
on p.idnivelformacao = n.idnivelFormacao
join instituicao i
on p.idinstituicao = i.idinstituicao
join curso c
on p.idcurso = c.idcurso;

DELIMITER && 
create procedure exibircurso(p_idcurso int)
      begin
          select p.nomeusuario as 'Aluno', i.idcurso as 'ID do Curso', i.nomecurso as 'Nome do Curso', i.nomeinstituicao as 'Instituição'
          from vwacademico i
          inner join vwsolteiro p
          on i.idusuario = p.idusuario
		 where idcurso = p_idcurso;
	  end;
&&
DELIMITER ;


call exibircurso(169);
call exibircurso(153);
call exibircurso(175);
call exibircurso(193);
call exibircurso(33);
call exibircurso(71);

-- EXERCICIO 04 --

#EXERCICIO 4
DELIMITER && 
create procedure exibirCurso2(p_idcurso int, p_nomeusuario varchar(45))
      begin
          select *
          from vwacademico
		  where idcurso = p_idcurso and nomeusuario = p_nomeusuario;
	  end;
&&
DELIMITER ;

drop procedure exibirCurso2;
call exibirCurso2(71, 'Janaina Cunha' );
call exibirCurso2(33, 'Andre Leme' );

