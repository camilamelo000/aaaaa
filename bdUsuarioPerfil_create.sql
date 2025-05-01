SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `bdUsuarioPerfil` ;
CREATE SCHEMA IF NOT EXISTS `bdUsuarioPerfil` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `bdUsuarioPerfil` ;

-- -----------------------------------------------------
-- Table `perfilOperacional`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `perfilOperacional` ;

CREATE TABLE IF NOT EXISTS `perfilOperacional` (
  `idperfilOperacional` INT NOT NULL,
  `nomeperfilOperacional` VARCHAR(45) NULL,
  PRIMARY KEY (`idperfilOperacional`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `usuario` ;

CREATE TABLE IF NOT EXISTS `usuario` (
  `idusuario` INT NOT NULL,
  `nomeusuario` VARCHAR(45) NULL,
  `login` VARCHAR(80) NULL,
  `senha` VARCHAR(8) NULL,
  `apelidousuario` VARCHAR(45) NULL,
  `idperfilOperacional` INT NOT NULL,
  PRIMARY KEY (`idusuario`),
  INDEX `fk_usuario_perfilOperacional1_idx` (`idperfilOperacional` ASC),
  CONSTRAINT `fk_usuario_perfilOperacional1`
    FOREIGN KEY (`idperfilOperacional`)
    REFERENCES `perfilOperacional` (`idperfilOperacional`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `nacionalidade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nacionalidade` ;

CREATE TABLE IF NOT EXISTS `nacionalidade` (
  `idnacionalidade` INT NOT NULL,
  `nomenacionalidade` VARCHAR(100) NULL,
  PRIMARY KEY (`idnacionalidade`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `municipio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `municipio` ;

CREATE TABLE IF NOT EXISTS `municipio` (
  `idmunicipio` INT NOT NULL,
  `nomemunicipio` VARCHAR(100) NULL,
  `UF` VARCHAR(2) NULL,
  PRIMARY KEY (`idmunicipio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `perfilSocial`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `perfilSocial` ;

CREATE TABLE IF NOT EXISTS `perfilSocial` (
  `idusuario` INT NOT NULL,
  `email` VARCHAR(100) NULL,
  `telefonefixo` VARCHAR(45) NULL,
  `telefonecelular` VARCHAR(45) NULL,
  `estadocivil` ENUM('Casado','Solteiro','Divorciado','Viúvo','Amasiado') NULL DEFAULT 'Solteiro',
  `datanascimento` DATE NULL,
  `naturalidade` INT NULL,
  `idnacionalidade` INT NULL,
  PRIMARY KEY (`idusuario`),
  INDEX `fk_perfilSocial_usuario_idx` (`idusuario` ASC),
  INDEX `fk20_idx` (`idnacionalidade` ASC),
  INDEX `fk21_idx` (`naturalidade` ASC),
  CONSTRAINT `fk_perfilSocial_usuario`
    FOREIGN KEY (`idusuario`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk20`
    FOREIGN KEY (`idnacionalidade`)
    REFERENCES `nacionalidade` (`idnacionalidade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk21`
    FOREIGN KEY (`naturalidade`)
    REFERENCES `municipio` (`idmunicipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profissao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profissao` ;

CREATE TABLE IF NOT EXISTS `profissao` (
  `idprofissao` INT NOT NULL,
  `nomeprofissao` VARCHAR(45) NULL,
  PRIMARY KEY (`idprofissao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cargo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cargo` ;

CREATE TABLE IF NOT EXISTS `cargo` (
  `idcargo` INT NOT NULL,
  `descricaocargo` VARCHAR(45) NULL,
  PRIMARY KEY (`idcargo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `setor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `setor` ;

CREATE TABLE IF NOT EXISTS `setor` (
  `idsetor` INT NOT NULL,
  `nomesetor` VARCHAR(80) NULL,
  PRIMARY KEY (`idsetor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `empresa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `empresa` ;

CREATE TABLE IF NOT EXISTS `empresa` (
  `idempresa` INT NOT NULL,
  `nomeempresa` VARCHAR(80) NULL,
  `nomefantasiaempresa` VARCHAR(45) NULL,
  `idsetor` INT NOT NULL,
  PRIMARY KEY (`idempresa`),
  INDEX `fk_empresa_setor1_idx` (`idsetor` ASC),
  CONSTRAINT `fk_empresa_setor1`
    FOREIGN KEY (`idsetor`)
    REFERENCES `setor` (`idsetor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `perfilProfissional`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `perfilProfissional` ;

CREATE TABLE IF NOT EXISTS `perfilProfissional` (
  `idusuario` INT NOT NULL,
  `idperfilProfissional` VARCHAR(45) NOT NULL,
  `idprofissao` INT NULL,
  `idempresa` INT NULL,
  `idcargo` INT NULL,
  `admissao` DATE NULL,
  `demissao` DATE NULL,
  `idmunicipio` INT NULL,
  PRIMARY KEY (`idusuario`, `idperfilProfissional`),
  INDEX `fk1_idx` (`idcargo` ASC),
  INDEX `fk2_idx` (`idprofissao` ASC),
  INDEX `fk3_idx` (`idmunicipio` ASC),
  INDEX `fk_perfilProfissional_usuario1_idx` (`idusuario` ASC),
  INDEX `fk4_idx` (`idempresa` ASC),
  CONSTRAINT `fk1`
    FOREIGN KEY (`idcargo`)
    REFERENCES `cargo` (`idcargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk2`
    FOREIGN KEY (`idprofissao`)
    REFERENCES `profissao` (`idprofissao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk3`
    FOREIGN KEY (`idmunicipio`)
    REFERENCES `municipio` (`idmunicipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_perfilProfissional_usuario1`
    FOREIGN KEY (`idusuario`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk4`
    FOREIGN KEY (`idempresa`)
    REFERENCES `empresa` (`idempresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `areacurso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `areacurso` ;

CREATE TABLE IF NOT EXISTS `areacurso` (
  `idareacurso` INT NOT NULL,
  `nomeareacurso` VARCHAR(100) NULL,
  PRIMARY KEY (`idareacurso`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `curso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `curso` ;

CREATE TABLE IF NOT EXISTS `curso` (
  `idcurso` INT NOT NULL,
  `nomecurso` VARCHAR(80) NULL,
  `idareacurso` INT NOT NULL,
  PRIMARY KEY (`idcurso`),
  INDEX `fk_curso_areacurso1_idx` (`idareacurso` ASC),
  CONSTRAINT `fk_curso_areacurso1`
    FOREIGN KEY (`idareacurso`)
    REFERENCES `areacurso` (`idareacurso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `nivelFormacao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nivelFormacao` ;

CREATE TABLE IF NOT EXISTS `nivelFormacao` (
  `idnivelFormacao` INT NOT NULL,
  `descricaonivelFormacao` VARCHAR(50) NULL,
  PRIMARY KEY (`idnivelFormacao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `instituicao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `instituicao` ;

CREATE TABLE IF NOT EXISTS `instituicao` (
  `idinstituicao` INT NOT NULL,
  `nomeinstituicao` VARCHAR(80) NULL,
  `siglainstituicao` VARCHAR(10) NULL,
  PRIMARY KEY (`idinstituicao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `perfilAcademico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `perfilAcademico` ;

CREATE TABLE IF NOT EXISTS `perfilAcademico` (
  `idusuario` INT NOT NULL,
  `idperfilAcademico` INT NOT NULL,
  `idinstituicao` INT NULL,
  `idnivelformacao` INT NULL,
  `url_lattes` VARCHAR(80) NULL,
  `idcurso` INT NULL,
  `idmunicipio` INT NULL,
  PRIMARY KEY (`idusuario`, `idperfilAcademico`),
  INDEX `fk_perfilAcademico_municipio1_idx` (`idmunicipio` ASC),
  INDEX `fk10_idx` (`idcurso` ASC),
  INDEX `fk11_idx` (`idnivelformacao` ASC),
  INDEX `fk_perfilAcademico_usuario1_idx` (`idusuario` ASC),
  INDEX `fk12_idx` (`idinstituicao` ASC),
  CONSTRAINT `fk_perfilAcademico_municipio1`
    FOREIGN KEY (`idmunicipio`)
    REFERENCES `municipio` (`idmunicipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk10`
    FOREIGN KEY (`idcurso`)
    REFERENCES `curso` (`idcurso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk11`
    FOREIGN KEY (`idnivelformacao`)
    REFERENCES `nivelFormacao` (`idnivelFormacao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_perfilAcademico_usuario1`
    FOREIGN KEY (`idusuario`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk12`
    FOREIGN KEY (`idinstituicao`)
    REFERENCES `instituicao` (`idinstituicao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `funcionalidade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `funcionalidade` ;

CREATE TABLE IF NOT EXISTS `funcionalidade` (
  `idfuncionalidade` INT NOT NULL,
  `nomefuncionalidade` VARCHAR(45) NULL,
  PRIMARY KEY (`idfuncionalidade`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `perfilOperacional_funcionalidade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `perfilOperacional_funcionalidade` ;

CREATE TABLE IF NOT EXISTS `perfilOperacional_funcionalidade` (
  `idperfilOperacional` INT NOT NULL,
  `idfuncionalidade` INT NOT NULL,
  PRIMARY KEY (`idperfilOperacional`, `idfuncionalidade`),
  INDEX `fk_perfilOperacional_funcionalidade_funcionalidade1_idx` (`idfuncionalidade` ASC),
  INDEX `fk_perfilOperacional_funcionalidade_perfilOperacional1_idx` (`idperfilOperacional` ASC),
  CONSTRAINT `fk_perfilOperacional_funcionalidade_perfilOperacional1`
    FOREIGN KEY (`idperfilOperacional`)
    REFERENCES `perfilOperacional` (`idperfilOperacional`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_perfilOperacional_funcionalidade_funcionalidade1`
    FOREIGN KEY (`idfuncionalidade`)
    REFERENCES `funcionalidade` (`idfuncionalidade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
