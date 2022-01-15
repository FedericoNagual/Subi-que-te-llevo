
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`PerfilConductor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PerfilConductor` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `usuario` VARCHAR(45) NULL,
  `contra` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Persona` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `apellido` VARCHAR(45) NULL,
  `dni` INT NULL,
  `rutaFoto` VARCHAR(255) NULL,
  `mail` VARCHAR(60) NULL,
  `PerfilConductor_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Persona_PerfilConductor1_idx` (`PerfilConductor_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Persona_PerfilConductor1`
    FOREIGN KEY (`PerfilConductor_ID`)
    REFERENCES `mydb`.`PerfilConductor` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Marca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Marca` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Modelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Modelo` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `Marca_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Modelo_Marca1_idx` (`Marca_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Modelo_Marca1`
    FOREIGN KEY (`Marca_ID`)
    REFERENCES `mydb`.`Marca` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Vehiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Vehiculo` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `color` VARCHAR(45) NULL,
  `patente` VARCHAR(45) NULL,
  `kilometros` INT NULL,
  `seguridad` BIT(1) NULL,
  `estado` BIT(1) NULL,
  `Modelo_ID` INT NOT NULL,
  `PerfilConductor_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Vehiculo_Modelo1_idx` (`Modelo_ID` ASC) VISIBLE,
  INDEX `fk_Vehiculo_PerfilConductor1_idx` (`PerfilConductor_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Vehiculo_Modelo1`
    FOREIGN KEY (`Modelo_ID`)
    REFERENCES `mydb`.`Modelo` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vehiculo_PerfilConductor1`
    FOREIGN KEY (`PerfilConductor_ID`)
    REFERENCES `mydb`.`PerfilConductor` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Pais`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pais` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Provincia` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `Pais_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Provincia_Pais1_idx` (`Pais_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Provincia_Pais1`
    FOREIGN KEY (`Pais_ID`)
    REFERENCES `mydb`.`Pais` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Localidad`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Localidad` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `codigoPostal` VARCHAR(45) NULL,
  `Provincia_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Localidad_Provincia1_idx` (`Provincia_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Localidad_Provincia1`
    FOREIGN KEY (`Provincia_ID`)
    REFERENCES `mydb`.`Provincia` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ubicacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Ubicacion` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `calle` VARCHAR(45) NULL,
  `numero` VARCHAR(45) NULL,
  `Localidad_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Ubicacion_Localidad1_idx` (`Localidad_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Ubicacion_Localidad1`
    FOREIGN KEY (`Localidad_ID`)
    REFERENCES `mydb`.`Localidad` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`EstadoViaje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`EstadoViaje` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `observacion` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Viaje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Viaje` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `cantidadDeLugaresDisponibles` INT NULL,
  `fecha` DATE NULL,
  `hora` TIME NULL,
  `precioDelViaje` FLOAT NULL,
  `equipaje` BIT(1) NULL,
  `observacion` VARCHAR(255) NULL,
  `PerfilConductor_ID` INT NOT NULL,
  `Vehiculo_ID` INT NOT NULL,
  `Origen_ID` INT NOT NULL,
  `Destino_ID` INT NOT NULL,
  `EstadoViaje_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Viaje_PerfilConductor_idx` (`PerfilConductor_ID` ASC) VISIBLE,
  INDEX `fk_Viaje_Vehiculo1_idx` (`Vehiculo_ID` ASC) VISIBLE,
  INDEX `fk_Viaje_Ubicacion1_idx` (`Origen_ID` ASC) VISIBLE,
  INDEX `fk_Viaje_Ubicacion2_idx` (`Destino_ID` ASC) VISIBLE,
  INDEX `fk_Viaje_EstadoViaje1_idx` (`EstadoViaje_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Viaje_PerfilConductor`
    FOREIGN KEY (`PerfilConductor_ID`)
    REFERENCES `mydb`.`PerfilConductor` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Viaje_Vehiculo1`
    FOREIGN KEY (`Vehiculo_ID`)
    REFERENCES `mydb`.`Vehiculo` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Viaje_Ubicacion1`
    FOREIGN KEY (`Origen_ID`)
    REFERENCES `mydb`.`Ubicacion` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Viaje_Ubicacion2`
    FOREIGN KEY (`Destino_ID`)
    REFERENCES `mydb`.`Ubicacion` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Viaje_EstadoViaje1`
    FOREIGN KEY (`EstadoViaje_ID`)
    REFERENCES `mydb`.`EstadoViaje` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`EstadoPasajeroDetalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`EstadoPasajeroDetalle` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `observacion` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PasajeroDetalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PasajeroDetalle` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `detalle` VARCHAR(255) NULL,
  `Persona_ID` INT NOT NULL,
  `Viaje_ID` INT NOT NULL,
  `EstadoPasajeroDetalle_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_PasajeroDetalle_Persona1_idx` (`Persona_ID` ASC) VISIBLE,
  INDEX `fk_PasajeroDetalle_Viaje1_idx` (`Viaje_ID` ASC) VISIBLE,
  INDEX `fk_PasajeroDetalle_EstadoPasajeroDetalle1_idx` (`EstadoPasajeroDetalle_ID` ASC) VISIBLE,
  CONSTRAINT `fk_PasajeroDetalle_Persona1`
    FOREIGN KEY (`Persona_ID`)
    REFERENCES `mydb`.`Persona` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PasajeroDetalle_Viaje1`
    FOREIGN KEY (`Viaje_ID`)
    REFERENCES `mydb`.`Viaje` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PasajeroDetalle_EstadoPasajeroDetalle1`
    FOREIGN KEY (`EstadoPasajeroDetalle_ID`)
    REFERENCES `mydb`.`EstadoPasajeroDetalle` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


