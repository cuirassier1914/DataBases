CREATE TABLE `users_likes`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_name` (`name` ASC));

CREATE TABLE `users_likes`.`foto` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(256) NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `users_likes`.`comments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `text` TEXT NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `users_likes`.`likes` (
  `id` INT NULL AUTO_INCREMENT,
  `from_id` INT NULL,
  `to_id` INT NULL,
  `type` ENUM('foto', 'user', 'comment') NULL,
  `object_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_from` (`from_id` ASC),
  INDEX `idx_to` (`to_id` ASC),
  INDEX `idx_object` (`object_id` ASC),
  CONSTRAINT `fk_from`
    FOREIGN KEY (`from_id`)
    REFERENCES `users_likes`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_to`
    FOREIGN KEY (`to_id`)
    REFERENCES `users_likes`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

INSERT INTO `users_likes`.`users` (`name`) VALUES ('Serge');
INSERT INTO `users_likes`.`users` (`name`) VALUES ('Alexandra');
INSERT INTO `users_likes`.`users` (`name`) VALUES ('Nathalie');
INSERT INTO `users_likes`.`users` (`name`) VALUES ('Ingrid');
INSERT INTO `users_likes`.`users` (`name`) VALUES ('Nicola');
INSERT INTO `users_likes`.`users` (`name`) VALUES ('Fredy');

INSERT INTO `users_likes`.`foto` (`name`) VALUES ('cat');
INSERT INTO `users_likes`.`foto` (`name`) VALUES ('dog');
INSERT INTO `users_likes`.`foto` (`name`) VALUES ('bird');
INSERT INTO `users_likes`.`foto` (`name`) VALUES ('fox');
INSERT INTO `users_likes`.`foto` (`name`) VALUES ('wolf');
INSERT INTO `users_likes`.`foto` (`name`) VALUES ('elephant');

INSERT INTO `users_likes`.`comments` (`text`) VALUES ('Chouette !');
INSERT INTO `users_likes`.`comments` (`text`) VALUES ('Super !');
INSERT INTO `users_likes`.`comments` (`text`) VALUES ('Merveilleux !');
INSERT INTO `users_likes`.`comments` (`text`) VALUES ('Parfait !');
INSERT INTO `users_likes`.`comments` (`text`) VALUES ('Incomparable !');

INSERT INTO `users_likes`.`likes` (`from_id`, `to_id`, `type`, `object_id`) VALUES ('1', '2', 'user', '2');
INSERT INTO `users_likes`.`likes` (`from_id`, `to_id`, `type`, `object_id`) VALUES ('2', '1', 'user', '1');
INSERT INTO `users_likes`.`likes` (`from_id`, `to_id`, `type`, `object_id`) VALUES ('3', '1', 'foto', '4');
INSERT INTO `users_likes`.`likes` (`from_id`, `to_id`, `type`, `object_id`) VALUES ('4', '5', 'comment', '1');
INSERT INTO `users_likes`.`likes` (`from_id`, `to_id`, `type`, `object_id`) VALUES ('5', '1', 'user', '1');
INSERT INTO `users_likes`.`likes` (`from_id`, `to_id`, `type`, `object_id`) VALUES ('1', '5', 'foto', '2');
INSERT INTO `users_likes`.`likes` (`from_id`, `to_id`, `type`, `object_id`) VALUES ('1', '5', 'user', '5');


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
