-- Compatibilidade mínima entre inventory + core revolt
USE `revolt`;

-- accounts: queries do core usam priority e o inventory usa premium/rolepass
ALTER TABLE `accounts`
  ADD COLUMN IF NOT EXISTS `priority` INT(11) NOT NULL DEFAULT 0 AFTER `gems`;

-- characters: prepare.lua usa card/created/time em fluxos de personagem
ALTER TABLE `characters`
  ADD COLUMN IF NOT EXISTS `card` VARCHAR(50) DEFAULT NULL AFTER `phone`,
  ADD COLUMN IF NOT EXISTS `created` BIGINT(20) NOT NULL DEFAULT 0 AFTER `seevideo`,
  ADD COLUMN IF NOT EXISTS `time` BIGINT(20) NOT NULL DEFAULT 0 AFTER `created`;

-- tabelas utilitárias que o core costuma esperar em vários fluxos comuns
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `Passport` INT(11) NOT NULL,
  `Type` VARCHAR(50) NOT NULL,
  `Date` VARCHAR(50) NOT NULL,
  `Value` INT(11) NOT NULL DEFAULT 0,
  `Balance` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_transactions_passport` (`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `taxs` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `Passport` INT(10) NOT NULL DEFAULT 0,
  `Name` VARCHAR(50) NOT NULL,
  `Date` VARCHAR(50) NOT NULL,
  `Hour` VARCHAR(50) NOT NULL,
  `Value` INT(11) NOT NULL,
  `Message` LONGTEXT DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_taxs_passport` (`Passport`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `casados` (
  `id` INT(11) NOT NULL,
  `membro1` INT(11) NOT NULL DEFAULT 0,
  `membro2` INT(11) NOT NULL DEFAULT 0,
  `casados` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
