
-- -----------------------------------------------------
-- Schema users_likes
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `users_likes` DEFAULT CHARACTER SET utf8mb4 ;
USE `users_likes` ;

-- -----------------------------------------------------
-- Table `users_likes`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `users_likes`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `users_likes`.`likes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `users_likes`.`likes` (
  `id` INT NULL AUTO_INCREMENT,
  `from_id` INT NULL,
  `to_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `ind_from_id` (`from_id` ASC),
  INDEX `ind_to_id` (`to_id` ASC),
  CONSTRAINT `fk_from_id`
    FOREIGN KEY (`from_id`)
    REFERENCES `users_likes`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_to_id`
    FOREIGN KEY (`to_id`)
    REFERENCES `users_likes`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


--1

use users_likes;

DROP VIEW IF EXISTS sent;
CREATE VIEW `sent` AS
SELECT users.id, users.name, count(likes.from_id) as `likes sent`
FROM users
LEFT JOIN likes ON users.id=likes.from_id
GROUP BY  users.id;

DROP VIEW IF EXISTS `received`;
CREATE VIEW `received` AS
SELECT users.id, users.name, count(likes.to_id) as `likes received`
FROM users
LEFT JOIN likes ON users.id=likes.to_id
GROUP BY  users.id;

DROP VIEW IF EXISTS mutual;
CREATE VIEW mutual AS 
#выбрали только взаимные---
SELECT B.from_id, B.to_id FROM likes A
JOIN likes B ON
B.to_id=A.from_id
and
B.from_id=A.to_id;

SELECT users.id, users.name, 
received.`likes received`, 
sent.`likes sent`, 
count(mutual.from_id) as `mutual`
FROM users
LEFT JOIN received  ON users.id=received.id
LEFT JOIN sent ON users.id=sent.id
LEFT JOIN mutual ON users.id=mutual.from_id
GROUP BY  users.id;


-----------------2---------------------

use users_likes;

DROP VIEW IF EXISTS C;
CREATE VIEW C AS
SELECT * FROM likes WHERE to_id=3;

drop view if exists A;
CREATE VIEW A AS
SELECT from_id FROM likes
WHERE to_id=5;

drop view if exists B;
create view B as
select from_id from likes
where to_id=4;

drop view if exists AB;

create view AB as
SELECT A.from_id
FROM A
INNER JOIN B ON
A.from_id=B.from_id
GROUP BY A.from_id;

drop view if exists ABC;

create view ABC as
select AB.from_id, C.from_id as Cfrom_id, C.to_id from AB
left join C on AB.from_id=C.from_id;

select from_id as usersID from ABC where Cfrom_id is null;

-------------------3-----------------------

ALTER TABLE `users_likes`.`likes`
ADD COLUMN `type` ENUM('user', 'foto', 'comment') NOT NULL AFTER `to_id`,
ADD INDEX `ind_type` (`type` ASC);

ALTER TABLE `users_likes`.`likes`
ADD COLUMN `object_id` INT(11) NOT NULL AFTER `type`;

CREATE TABLE `users_likes`.`foto` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`));

ALTER TABLE `users_likes`.`foto`
CHANGE COLUMN `name` `text` VARCHAR(256) NULL DEFAULT NULL , RENAME TO  `users_likes`.`comments` ;


---- ---------------исключение повторных лайков-----------------

use users_likes;

DROP TRIGGER IF EXISTS trig_likes_validator;

delimiter //

CREATE TRIGGER trig_likes_validator
    BEFORE INSERT ON likes
    FOR EACH ROW
    BEGIN

    SET @a=(CASE
		WHEN EXISTS(SELECT * FROM likes WHERE
      from_id=NEW.from_id
      and
      to_id=NEW.to_id
      and
      `type`=NEW.`type`
      and
      object_id=NEW.object_id) THEN TRUE
      ELSE FALSE
      END);
      
	SET NEW.from_id=(
      CASE
      WHEN @a=TRUE
      THEN NULL
      ELSE NEW.from_id
      END),
      NEW.to_id=(
      CASE
      WHEN @a=TRUE
      THEN NULL
      ELSE NEW.to_id
      END),
      NEW.`type`=(
      CASE
      WHEN @a=TRUE
      THEN NULL
      ELSE NEW.`type`
      END),
      NEW.object_id=(
      CASE
      WHEN @a=TRUE
      THEN NULL
      ELSE NEW.object_id
      END);

    END//
delimiter ;

	    -------считать число полученных сущностью лайков и выводить список пользователей, поставивших лайки-----
use users_likes;

SELECT COUNT(id) FROM likes WHERE object_id=1 and `type`='foto';

DROP VIEW IF EXISTS `object_users`;

CREATE VIEW `object_users` AS
SELECT likes.id, likes.from_id, likes.object_id, users.`name` FROM likes
LEFT JOIN users ON likes.from_id=users.id
GROUP BY likes.id;

SELECT * FROM `objects_users`;

SELECT object_id, 
COUNT(id) as `likes quantity`, 
GROUP_CONCAT(DISTINCT `name` SEPARATOR ', ') as `by users` 
FROM object_users GROUP BY object_id;
