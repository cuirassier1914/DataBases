-- MySQL Script generated by MySQL Workbench
-- Thu Aug  9 20:16:09 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema countries
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema countries
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `countries` DEFAULT CHARACTER SET utf8mb4 ;
USE `countries` ;

-- -----------------------------------------------------
-- Table `countries`.`states`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `countries`.`states` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `countries`.`region`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `countries`.`region` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `states_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_region_states_idx` (`states_id` ASC),
  CONSTRAINT `fk_region_states`
    FOREIGN KEY (`states_id`)
    REFERENCES `countries`.`states` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `countries`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `countries`.`department` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `region_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_department_region1_idx` (`region_id` ASC),
  CONSTRAINT `fk_department_region1`
    FOREIGN KEY (`region_id`)
    REFERENCES `countries`.`region` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `countries`.`city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `countries`.`city` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `department_id` INT UNSIGNED NULL,
  `region_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_city_department1_idx` (`department_id` ASC),
  INDEX `fk_city_region1_idx` (`region_id` ASC),
  CONSTRAINT `fk_city_department1`
    FOREIGN KEY (`department_id`)
    REFERENCES `countries`.`department` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_city_region1`
    FOREIGN KEY (`region_id`)
    REFERENCES `countries`.`region` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
