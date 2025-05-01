-- EXEMPLO DE UMA VIEW
CREATE VIEW vwListaUsuario AS
SELECT nomeusuario 
     , apelidousuario
     , nomeperfilOperacional
     , email
     , nomenacionalidade
     , nomemunicipio
 FROM usuario U
JOIN perfiloperacional PO
  ON U.idperfilOperacional = PO.idperfilOperacional
JOIN perfilsocial PS
  ON U.idusuario = PS.idusuario
JOIN nacionalidade N
  ON PS.idnacionalidade = N.idnacionalidade
JOIN municipio M
  ON PS.naturalidade = M.idmunicipio;

-- chamar view
select * from vwListaUsuario;

-- usando a view
select nomeusuario, email, nomemunicipio 
from vwlistausuario
where nomemunicipio like 'm%';