-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.32-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.15.0.7171
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para revolt
CREATE DATABASE IF NOT EXISTS `revolt` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `revolt`;

-- Copiando estrutura para tabela revolt.accounts
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `whitelist` tinyint(1) NOT NULL DEFAULT 0,
  `chars` int(10) NOT NULL DEFAULT 1,
  `gems` int(20) NOT NULL DEFAULT 0,
  `rolepass` int(20) NOT NULL DEFAULT 0,
  `premium` int(20) NOT NULL DEFAULT 0,
  `discord` varchar(50) NOT NULL DEFAULT '0',
  `steam` int(11) DEFAULT NULL,
  `license` varchar(50) NOT NULL DEFAULT '0',
  `initial` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `license` (`license`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.accounts: ~1 rows (aproximadamente)
INSERT IGNORE INTO `accounts` (`id`, `whitelist`, `chars`, `gems`, `rolepass`, `premium`, `discord`, `steam`, `license`, `initial`) VALUES
	(1, 1, 1, 0, 0, 0, '1403859088206725304', 2147483647, '6d171422731c93f7b00f768d54eddedd718ebfc0', 0);

-- Copiando estrutura para tabela revolt.banneds
CREATE TABLE IF NOT EXISTS `banneds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) NOT NULL,
  `time` int(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.banneds: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `name` varchar(50) DEFAULT 'Individuo',
  `name2` varchar(50) DEFAULT 'Indigente',
  `sex` varchar(1) NOT NULL DEFAULT 'M',
  `locate` varchar(20) NOT NULL DEFAULT 'Norte',
  `visa` int(1) NOT NULL DEFAULT 0,
  `bank` int(20) NOT NULL DEFAULT 0,
  `blood` int(1) NOT NULL DEFAULT 1,
  `fines` int(20) NOT NULL DEFAULT 0,
  `prison` int(11) NOT NULL DEFAULT 0,
  `tracking` int(30) NOT NULL DEFAULT 0,
  `spending` int(20) NOT NULL DEFAULT 0,
  `cardlimit` int(20) NOT NULL DEFAULT 0,
  `deleted` int(1) NOT NULL DEFAULT 0,
  `age` int(11) NOT NULL DEFAULT 20,
  `paypal` int(11) DEFAULT 0,
  `garage` int(11) DEFAULT 2,
  `pincode` varchar(50) DEFAULT NULL,
  `seevideo` int(11) DEFAULT 0,
  `steam` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.characters: ~0 rows (aproximadamente)
INSERT IGNORE INTO `characters` (`id`, `license`, `phone`, `name`, `name2`, `sex`, `locate`, `visa`, `bank`, `blood`, `fines`, `prison`, `tracking`, `spending`, `cardlimit`, `deleted`, `age`, `paypal`, `garage`, `pincode`, `seevideo`, `steam`) VALUES
	(4, '6d171422731c93f7b00f768d54eddedd718ebfc0', '795-059', 'Bryan', 'Alvez', 'M', 'Norte', 0, 56696, 1, 0, 0, 0, 0, 0, 0, 28, 0, 2, '1111', 0, 76561199767838378);

-- Copiando estrutura para tabela revolt.chests
CREATE TABLE IF NOT EXISTS `chests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `weight` int(10) NOT NULL DEFAULT 0,
  `perm` varchar(50) NOT NULL,
  `logs` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.chests: ~25 rows (aproximadamente)
INSERT IGNORE INTO `chests` (`id`, `name`, `weight`, `perm`, `logs`) VALUES
	(1, 'Police', 550, 'Police', 1),
	(2, 'Paramedic', 500, 'Paramedic', 1),
	(3, 'BurgerShot', 400, 'BurgerShot', 0),
	(4, 'PizzaThis', 250, 'PizzaThis', 0),
	(5, 'UwuCoffee', 250, 'UwuCoffee', 0),
	(6, 'BeanMachine', 250, 'BeanMachine', 0),
	(7, 'Ballas', 260, 'Ballas', 1),
	(8, 'Families', 250, 'Families', 0),
	(9, 'Vagos', 250, 'Vagos', 0),
	(10, 'Aztecas', 250, 'Aztecas', 0),
	(11, 'Bloods', 250, 'Bloods', 0),
	(14, 'Mechanic', 500, 'Mechanic', 0),
	(15, 'Digitalden', 500, 'Digitalden', 0),
	(16, 'Digitalden-ilegal', 500, 'Digitalden', 0),
	(17, 'Cosanostra', 500, 'Cosanostra', 0),
	(18, 'Thelost', 500, 'Thelost', 0),
	(19, 'Tijuana', 500, 'Tijuana', 0),
	(20, 'Police2', 5000, 'Police', 1),
	(21, 'Mechanic68', 500, 'Mechanic68', 1),
	(22, 'Pawnshop', 500, 'Pawnshop', 0),
	(23, 'Bennys', 500, 'Bennys', 1),
	(24, 'Bratva', 810, 'Bratva', 1),
	(25, 'Coiote', 500, 'Coiote', 1),
	(26, 'Yakuza', 250, 'Yakuza', 1),
	(27, 'Paramedic-2', 500, 'Paramedic', 1);

-- Copiando estrutura para tabela revolt.dependents
CREATE TABLE IF NOT EXISTS `dependents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Dependent` int(10) NOT NULL DEFAULT 0,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.dependents: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.dominations
CREATE TABLE IF NOT EXISTS `dominations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `faction` varchar(50) NOT NULL,
  `coords` text NOT NULL,
  `sprayObj` text DEFAULT NULL,
  `color` varchar(50) NOT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `active` bit(1) DEFAULT b'1',
  `endedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.dominations: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.dominations_disputes
CREATE TABLE IF NOT EXISTS `dominations_disputes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `territoryId` int(11) NOT NULL,
  `attacker` varchar(255) NOT NULL,
  `defender` varchar(255) NOT NULL,
  `startedAt` datetime NOT NULL DEFAULT current_timestamp(),
  `winner` varchar(50) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `finishedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.dominations_disputes: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.entitydata
CREATE TABLE IF NOT EXISTS `entitydata` (
  `dkey` varchar(100) NOT NULL,
  `dvalue` longtext DEFAULT NULL,
  PRIMARY KEY (`dkey`),
  KEY `dkey` (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.entitydata: ~3 rows (aproximadamente)
INSERT IGNORE INTO `entitydata` (`dkey`, `dvalue`) VALUES
	('Exclusivas:4', '[]'),
	('Outfit:4', '[]'),
	('Permissions:Admin', '{"4":1}'),
	('Permissions:Franca', '{"4":1}'),
	('Permissions:Police', '{"4":1}');

-- Copiando estrutura para tabela revolt.felipeex_tablet_fixa
CREATE TABLE IF NOT EXISTS `felipeex_tablet_fixa` (
  `user_id` int(11) NOT NULL,
  `penalidade` varchar(255) DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `oficial` varchar(255) DEFAULT NULL,
  `valordapenalidade` varchar(255) DEFAULT NULL,
  `data` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.felipeex_tablet_fixa: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.felipeex_tablet_img
CREATE TABLE IF NOT EXISTS `felipeex_tablet_img` (
  `user_id` int(11) NOT NULL,
  `img` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.felipeex_tablet_img: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.fidentity
CREATE TABLE IF NOT EXISTS `fidentity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `name2` varchar(50) NOT NULL DEFAULT '',
  `port` int(1) NOT NULL DEFAULT 1,
  `blood` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.fidentity: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.fines
CREATE TABLE IF NOT EXISTS `fines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Name` varchar(50) NOT NULL,
  `Date` varchar(50) NOT NULL,
  `Hour` varchar(50) NOT NULL,
  `Value` int(11) NOT NULL,
  `Message` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.fines: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.gas_station_balance
CREATE TABLE IF NOT EXISTS `gas_station_balance` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `gas_station_id` varchar(50) NOT NULL,
  `income` bit(1) NOT NULL,
  `title` varchar(255) NOT NULL,
  `amount` int(10) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.gas_station_balance: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.gas_station_business
CREATE TABLE IF NOT EXISTS `gas_station_business` (
  `gas_station_id` varchar(50) NOT NULL DEFAULT '',
  `user_id` varchar(50) NOT NULL,
  `stock` int(10) unsigned NOT NULL DEFAULT 0,
  `price` int(10) unsigned NOT NULL DEFAULT 0,
  `stock_upgrade` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `truck_upgrade` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `relationship_upgrade` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `money` int(10) unsigned NOT NULL DEFAULT 0,
  `total_money_earned` int(10) unsigned NOT NULL DEFAULT 0,
  `total_money_spent` int(10) unsigned NOT NULL DEFAULT 0,
  `gas_bought` int(10) unsigned NOT NULL DEFAULT 0,
  `gas_sold` int(10) unsigned NOT NULL DEFAULT 0,
  `distance_traveled` double unsigned NOT NULL DEFAULT 0,
  `total_visits` int(10) unsigned NOT NULL DEFAULT 0,
  `customers` int(10) unsigned NOT NULL DEFAULT 0,
  `timer` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`gas_station_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.gas_station_business: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.gas_station_jobs
CREATE TABLE IF NOT EXISTS `gas_station_jobs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `gas_station_id` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL,
  `reward` int(10) unsigned NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `progress` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.gas_station_jobs: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.hydrus_credits
CREATE TABLE IF NOT EXISTS `hydrus_credits` (
  `player_id` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `amount` int(11) DEFAULT 0,
  PRIMARY KEY (`player_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.hydrus_credits: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.hydrus_scheduler
CREATE TABLE IF NOT EXISTS `hydrus_scheduler` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `player_id` varchar(100) NOT NULL,
  `command` varchar(100) NOT NULL,
  `args` varchar(4096) NOT NULL,
  `execute_at` bigint(20) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `player_index` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.hydrus_scheduler: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.investments
CREATE TABLE IF NOT EXISTS `investments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Liquid` int(20) NOT NULL DEFAULT 0,
  `Monthly` int(20) NOT NULL DEFAULT 0,
  `Deposit` int(20) NOT NULL DEFAULT 0,
  `Last` int(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.investments: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.invoices
CREATE TABLE IF NOT EXISTS `invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Received` int(10) NOT NULL DEFAULT 0,
  `Type` varchar(50) NOT NULL,
  `Reason` longtext NOT NULL,
  `Holder` varchar(50) NOT NULL,
  `Value` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.invoices: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.org_goal_claims
CREATE TABLE IF NOT EXISTS `org_goal_claims` (
  `org_name` varchar(64) NOT NULL,
  `goal_id` varchar(64) NOT NULL,
  `last_claim` int(11) NOT NULL DEFAULT 0,
  `claimed_by` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`org_name`,`goal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.org_goal_claims: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.org_logs
CREATE TABLE IF NOT EXISTS `org_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_name` varchar(64) NOT NULL,
  `actor_passport` int(11) NOT NULL DEFAULT 0,
  `action` varchar(64) NOT NULL,
  `severity` varchar(16) NOT NULL DEFAULT 'info',
  `message` varchar(255) NOT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_revolt_org_logs_org` (`org_name`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.org_logs: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.org_role_permissions
CREATE TABLE IF NOT EXISTS `org_role_permissions` (
  `org_name` varchar(64) NOT NULL,
  `role` varchar(64) NOT NULL,
  `perm_key` varchar(64) NOT NULL,
  `allowed` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`org_name`,`role`,`perm_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.org_role_permissions: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.org_transactions
CREATE TABLE IF NOT EXISTS `org_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `Type` varchar(50) NOT NULL,
  `Value` int(20) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.org_transactions: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.organizations
CREATE TABLE IF NOT EXISTS `organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `bank` bigint(20) NOT NULL DEFAULT 0,
  `premium` bigint(20) NOT NULL DEFAULT 0,
  `buff` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_organizations_name` (`name`),
  UNIQUE KEY `uk_organizations_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.organizations: ~19 rows (aproximadamente)
INSERT IGNORE INTO `organizations` (`id`, `name`, `bank`, `premium`, `buff`) VALUES
	(1, 'Capão Redondo', 0, 0, 0),
	(2, 'Paraisópolis', 0, 0, 0),
	(3, 'Heliópolis', 0, 0, 0),
	(4, 'Cidade Tiradentes', 0, 0, 0),
	(5, 'Jardim Ângela', 0, 0, 0),
	(6, 'Vila Mariana', 0, 0, 0),
	(7, 'Itaquera', 0, 0, 0),
	(8, 'Brasilândia', 0, 0, 0),
	(9, 'Parelheiros', 0, 0, 0),
	(10, 'Grajaú', 0, 0, 0),
	(11, 'Sacomã', 0, 0, 0),
	(12, 'São Mateus', 0, 0, 0),
	(13, 'Polícia Militar', 0, 0, 0),
	(14, 'ROTA', 0, 0, 0),
	(15, 'ROTAM', 0, 0, 0),
	(16, 'Polícia Civil', 0, 0, 0),
	(17, 'Força Tática', 0, 0, 0),
	(18, 'GCM', 0, 0, 0),
	(19, 'Police', 0, 0, 0);

-- Copiando estrutura para tabela revolt.planting
CREATE TABLE IF NOT EXISTS `planting` (
  `id` int(11) NOT NULL,
  `startingPoint` bigint(20) DEFAULT NULL,
  `Coords` varchar(255) NOT NULL,
  `Time` bigint(20) DEFAULT NULL,
  `Route` int(11) NOT NULL DEFAULT 0,
  `Object` varchar(255) NOT NULL,
  `Points` int(11) NOT NULL,
  `Phase` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.planting: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.playerdata
CREATE TABLE IF NOT EXISTS `playerdata` (
  `Passport` int(11) NOT NULL,
  `dkey` varchar(100) NOT NULL,
  `dvalue` longtext DEFAULT NULL,
  PRIMARY KEY (`Passport`,`dkey`),
  KEY `Passport` (`Passport`),
  KEY `dkey` (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.playerdata: ~6 rows (aproximadamente)
INSERT IGNORE INTO `playerdata` (`Passport`, `dkey`, `dvalue`) VALUES
	(4, 'Ammos', '[]'),
	(4, 'Attachs', '[]'),
	(4, 'Clothings', '{"decals":{"item":0,"texture":0},"pants":{"item":170,"texture":0},"mask":{"item":169,"texture":0},"glass":{"item":15,"texture":8},"accessory":{"item":0,"texture":0},"backpack":{"item":0,"texture":0},"torso":{"item":686,"texture":0},"ear":{"item":-1,"texture":0},"watch":{"item":-1,"texture":0},"hat":{"item":-1,"texture":0},"tshirt":{"item":15,"texture":0},"shoes":{"item":171,"texture":1},"vest":{"item":0,"texture":0},"bracelet":{"item":-1,"texture":0},"arms":{"item":0,"texture":0}}'),
	(4, 'Datatable', '{"Weight":40,"Hunger":56,"Skin":"mp_m_freemode_01","Health":200,"Thirst":56,"Armour":0,"Inventory":{"4":{"item":"hamburger-1771392181","amount":3},"5":{"item":"dollars","amount":570},"6":{"item":"cellphone-1771392181","amount":1},"7":{"item":"radio-1772052658","amount":1},"8":{"item":"WEAPON_PISTOLMK2","amount":1},"1":{"item":"identity-4","amount":1},"2":{"item":"water","amount":2},"3":{"item":"gift","amount":1}},"Pos":{"x":-1591.35,"y":-333.96,"z":48.22},"Stress":0,"groups":{"Lider [FRANCA]":true}}'),
	(4, 'Experience', '{"Garbageman":0,"Delivery":0,"Taxi":0,"Tractor":0,"Transporter":0,"Bus":0,"Minerman":0,"Milkman":0,"Hunting":0,"Trucker":0,"Lumberman":0,"Fisherman":0,"Postal":0,"Tows":0}'),
	(4, 'nation_char', '{"noseBoneHigh":0.0,"bodyBlemishes":-1,"blush":-1,"freckles-opacity":1.0,"shapeFirst":21,"overlay":0,"bodyBlemishes-color":0,"chestHair-opacity":1.0,"eyesOpenning":0.0,"lipstick-color":0,"bodyBlemishes-opacity":1.0,"facialHair-color":0,"lipsThickness":0.0,"complexion":-1,"ageing":-1,"shapeMix":0.80000001192092,"eyes":0,"facialHair":-1,"eyebrows-opacity":1.0,"blush-opacity":1.0,"hair":199,"blush-color":0,"addBodyBlemishes-color":0,"sunDamage-opacity":1.0,"chestHair":-1,"shapeSecond":0,"noseWidth":0.0,"gender":"male","eyebrows":-1,"makeup-color":-1,"chinBoneLowering":0.0,"skinThird":0,"freckles-color":0,"chestHair-color":0,"hair-color":29,"lipstick-opacity":1.0,"skinMix":0.80000001192092,"noseBoneTwist":0.0,"lipstick":-1,"nosePeakLowering":0.0,"nosePeakLength":0.0,"blemishes":-1,"skinSecond":0,"thirdMix":0.0,"neckThickness":0.0,"cheeksBoneHigh":0.0,"sunDamage-color":0,"complexion-opacity":1.0,"complexion-color":0,"addBodyBlemishes-opacity":1.0,"chinBoneWidth":0.0,"jawBoneWidth":0.0,"nosePeakHeight":0.0,"ageing-opacity":1.0,"blemishes-opacity":1.0,"chinHole":0.0,"makeup-opacity":1.0,"blemishes-color":0,"skinFirst":21,"addBodyBlemishes":-1,"jawBoneBackLength":0.0,"shapeThird":0,"freckles":-1,"facialHair-opacity":1.0,"ageing-color":0,"chinBoneLength":0.0,"makeup":-1,"sunDamage":-1,"hair-highlightcolor":29,"cheeksWidth":0.0,"cheeksBoneWidth":0.0,"eyeBrownForward":0.0,"eyebrows-color":0,"eyeBrownHigh":0.0}');

-- Copiando estrutura para tabela revolt.port
CREATE TABLE IF NOT EXISTS `port` (
  `portId` int(11) NOT NULL AUTO_INCREMENT,
  `identity` longtext DEFAULT NULL,
  `user_id` text DEFAULT NULL,
  `portType` longtext DEFAULT NULL,
  `serial` longtext DEFAULT NULL,
  `nidentity` longtext DEFAULT NULL,
  `exam` longtext DEFAULT NULL,
  `date` text DEFAULT NULL,
  PRIMARY KEY (`portId`),
  KEY `portId` (`portId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela revolt.port: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.prison
CREATE TABLE IF NOT EXISTS `prison` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `police` varchar(255) DEFAULT '0',
  `nuser_id` int(11) NOT NULL DEFAULT 0,
  `services` int(11) NOT NULL DEFAULT 0,
  `fines` int(20) NOT NULL DEFAULT 0,
  `text` longtext DEFAULT NULL,
  `date` text DEFAULT NULL,
  `cops` varchar(50) DEFAULT NULL,
  `association` varchar(50) DEFAULT NULL,
  `residual` varchar(50) DEFAULT NULL,
  `url` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela revolt.prison: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.propertys
CREATE TABLE IF NOT EXISTS `propertys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL DEFAULT 'Homes0001',
  `Interior` varchar(20) NOT NULL DEFAULT 'Middle',
  `Keys` int(3) NOT NULL DEFAULT 3,
  `Tax` int(20) NOT NULL DEFAULT 0,
  `Passport` int(6) NOT NULL DEFAULT 0,
  `Serial` varchar(10) NOT NULL,
  `Vault` int(6) NOT NULL DEFAULT 1,
  `Fridge` int(6) NOT NULL DEFAULT 1,
  `Garage` longtext NOT NULL DEFAULT '{}',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `Passport` (`Passport`),
  KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.propertys: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.races
CREATE TABLE IF NOT EXISTS `races` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Race` int(3) NOT NULL DEFAULT 0,
  `Passport` int(5) NOT NULL DEFAULT 0,
  `Name` varchar(100) NOT NULL DEFAULT 'Individuo Indigente',
  `Vehicle` varchar(50) NOT NULL DEFAULT 'Sultan RS',
  `Points` int(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `Race` (`Race`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.races: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.razebank_transactions
CREATE TABLE IF NOT EXISTS `razebank_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `receiver_identifier` varchar(255) NOT NULL,
  `receiver_name` varchar(255) NOT NULL,
  `sender_identifier` varchar(255) NOT NULL,
  `sender_name` varchar(255) NOT NULL,
  `date` varchar(255) NOT NULL,
  `value` int(50) NOT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.razebank_transactions: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.reports
CREATE TABLE IF NOT EXISTS `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `victim_id` text DEFAULT NULL,
  `police_name` text DEFAULT NULL,
  `solved` text DEFAULT NULL,
  `victim_name` text DEFAULT NULL,
  `created_at` text DEFAULT NULL,
  `victim_report` text DEFAULT NULL,
  `updated_at` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portId` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela revolt.reports: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.revolt_blacklist
CREATE TABLE IF NOT EXISTS `revolt_blacklist` (
  `user_id` int(11) NOT NULL,
  `time` int(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`) USING BTREE,
  KEY `idx_time` (`time`) USING BTREE,
  KEY `idx_revolt_blacklist_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.revolt_blacklist: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.revolt_orgs_goals
CREATE TABLE IF NOT EXISTS `revolt_orgs_goals` (
  `user_id` int(11) NOT NULL,
  `organization` varchar(50) NOT NULL,
  `item` varchar(100) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `day` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `step` int(11) DEFAULT 1,
  `reward_step` int(11) DEFAULT 0,
  UNIQUE KEY `user_id_organization_item_day` (`user_id`,`organization`,`item`,`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.revolt_orgs_goals: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.revolt_orgs_info
CREATE TABLE IF NOT EXISTS `revolt_orgs_info` (
  `organization` varchar(50) NOT NULL,
  `alerts` text DEFAULT '{}',
  `logo` text DEFAULT NULL,
  `banner` text DEFAULT NULL,
  `discord` varchar(150) DEFAULT '',
  `bank` int(11) DEFAULT 0,
  `bank_historic` text DEFAULT '{}',
  `permissions` text DEFAULT '{}',
  `config_goals` text DEFAULT '{}',
  `salary` text DEFAULT '{}',
  `vip_name` varchar(50) DEFAULT NULL,
  `vip_salary` int(11) DEFAULT NULL,
  `vip_expires_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`organization`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.revolt_orgs_info: ~44 rows (aproximadamente)
INSERT IGNORE INTO `revolt_orgs_info` (`organization`, `alerts`, `logo`, `banner`, `discord`, `bank`, `bank_historic`, `permissions`, `config_goals`, `salary`, `vip_name`, `vip_salary`, `vip_expires_at`) VALUES
	('Abutres', '{}', NULL, NULL, '', 0, '{}', '{"Novato [ABUTRES]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [ABUTRES]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [ABUTRES]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Recrutador [ABUTRES]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [ABUTRES]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [ABUTRES]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Alemanha', '{}', NULL, NULL, '', 0, '{}', '{"Lider [ALEMANHA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Gerente [ALEMANHA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [ALEMANHA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [ALEMANHA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [ALEMANHA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [ALEMANHA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Anonymous', '{}', NULL, NULL, '', 0, '{}', '{"Recrutador [ANONYMOUS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [ANONYMOUS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [ANONYMOUS]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Gerente [ANONYMOUS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [ANONYMOUS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [ANONYMOUS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Bahamas', '{}', NULL, NULL, '', 0, '{}', '{"Recrutador [BAHAMAS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [BAHAMAS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [BAHAMAS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [BAHAMAS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [BAHAMAS]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Gerente [BAHAMAS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Bélgica', '{}', NULL, NULL, '', 0, '{}', '{"Novato [BÉLGICA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [BÉLGICA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [BÉLGICA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [BÉLGICA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [BÉLGICA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [BÉLGICA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Bennys', '{}', NULL, NULL, '', 0, '{}', '{"Sub-Lider [BENNYS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [BENNYS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [BENNYS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [BENNYS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [BENNYS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [BENNYS]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true}}', '{}', '{}', NULL, NULL, NULL),
	('Bloods', '{}', NULL, NULL, '', 0, '{}', '{"Recrutador [BLOODS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [BLOODS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [BLOODS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [BLOODS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [BLOODS]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [BLOODS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Bratva', '{}', NULL, NULL, '', 0, '{}', '{"Lider [BRATVA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Novato [BRATVA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [BRATVA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [BRATVA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [BRATVA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [BRATVA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Cassino', '{}', NULL, NULL, '', 0, '{}', '{"Novato [CASSINO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [CASSINO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [CASSINO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [CASSINO]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [CASSINO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [CASSINO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('China', '{}', NULL, NULL, '', 0, '{}', '{"Recrutador [CHINA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [CHINA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [CHINA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [CHINA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [CHINA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [CHINA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Cohab', '{}', NULL, NULL, '', 0, '{}', '{"Lider [COHAB]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Gerente [COHAB]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [COHAB]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [COHAB]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [COHAB]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [COHAB]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Colombia', '{}', NULL, NULL, '', 0, '{}', '{"Lider [COLOMBIA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [COLOMBIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [COLOMBIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [COLOMBIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [COLOMBIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [COLOMBIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Corleone', '{}', NULL, NULL, '', 0, '{}', '{"Recrutador [CORLEONE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [CORLEONE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [CORLEONE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [CORLEONE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [CORLEONE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [CORLEONE]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true}}', '{}', '{}', NULL, NULL, NULL),
	('Cpx', '{}', NULL, NULL, '', 0, '{}', '{"Sub-Lider [CPX]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [CPX]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [CPX]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Membro [CPX]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [CPX]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [CPX]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Croacia', '{}', NULL, NULL, '', 0, '{}', '{"Sub-Lider [CROACIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [CROACIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [CROACIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [CROACIA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Recrutador [CROACIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [CROACIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Disney', '{}', NULL, NULL, '', 0, '{}', '{"Novato [DISNEY]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [DISNEY]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [DISNEY]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [DISNEY]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [DISNEY]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [DISNEY]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Driftking', '{}', NULL, NULL, '', 0, '{}', '{"Lider [DRIFTKING]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Gerente [DRIFTKING]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [DRIFTKING]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [DRIFTKING]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Mecanico [DRIFTKING]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [DRIFTKING]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Egito', '{}', NULL, NULL, '', 0, '{}', '{"Membro [EGITO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [EGITO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [EGITO]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [EGITO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [EGITO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [EGITO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Franca', '{}', 'https://cdn.discordapp.com/attachments/1475662921542664407/1478246977937608805/Thumb_Dog.png?ex=69a7b448&is=69a662c8&hm=ca54568ff797c4ed018c9e5b9844a3ea56b4450c410d8798bf94330f3c5e5274&', 'https://cdn.discordapp.com/attachments/1405356593310203945/1474106634958803184/image.png?ex=69a7cd89&is=69a67c09&hm=094c6fd70c0d6fb61f79763abf1e28ebd29c5b91a3c1a5daffaeffa41a89bc1a&', 'https://discord.gg/RFA2Qxba', 23031, '[{"type":"Depósito","timestamp":1773175056,"type_code":"deposit","name":"Bryan Alvez","date":"10/03/2026 17:37:36","amount":32,"balanceAfter":23031},{"type":"Saque","timestamp":1773175047,"type_code":"withdrawal","name":"Bryan Alvez","date":"10/03/2026 17:37:27","amount":1,"balanceAfter":22999},{"type":"Saque","timestamp":1772594822,"type_code":"withdrawal","date":"04/03/2026 00:27:02","name":"Bryan Alvez","amount":100,"balanceAfter":23000},{"type":"Depósito","timestamp":1772582093,"type_code":"deposit","date":"03/03/2026 20:54:53","name":"Bryan Alvez","amount":9000,"balanceAfter":23100},{"type":"Depósito","timestamp":1772582088,"type_code":"deposit","date":"03/03/2026 20:54:48","name":"Bryan Alvez","amount":14100,"balanceAfter":14100},{"type":"Saque","timestamp":1772582053,"type_code":"withdrawal","date":"03/03/2026 20:54:13","name":"Bryan Alvez","amount":14110,"balanceAfter":0},{"type":"Depósito","timestamp":1772571183,"type_code":"deposit","date":"03/03/2026 17:53:03","name":"Bryan Alvez","amount":2999,"balanceAfter":14110},{"type":"Depósito","timestamp":1772571171,"type_code":"deposit","date":"03/03/2026 17:52:51","name":"Bryan Alvez","amount":10000,"balanceAfter":11111},{"type":"Depósito","timestamp":1772559951,"type_code":"deposit","date":"03/03/2026 14:45:51","name":"Bryan Alvez","amount":111,"balanceAfter":1111},{"type":"Depósito","timestamp":1772481999,"type_code":"deposit","date":"02/03/2026 17:06:39","name":"Bryan Alvez","amount":1000,"balanceAfter":1000}]', '{"Novato [FRANCA]":{"promote":false,"alerts":false,"message":false,"deposit":false,"chat":false,"demote":false,"dismiss":false,"invite":false,"withdraw":false},"Membro [FRANCA]":{"promote":false,"alerts":false,"message":false,"deposit":false,"chat":false,"demote":false,"dismiss":false,"invite":false,"withdraw":false},"Lider [FRANCA]":{"promote":true,"alerts":true,"leader":true,"message":true,"logs_view":true,"deposit":true,"chat":true,"demote":true,"dismiss":true,"invite":true,"withdraw":true},"Gerente [FRANCA]":{"promote":false,"alerts":false,"message":false,"logs_view":true,"deposit":false,"chat":false,"demote":false,"dismiss":false,"invite":false,"withdraw":false},"_roleOrder":["Lider [FRANCA]","Sub-Lider [FRANCA]","Gerente [FRANCA]","Recrutador [FRANCA]","Membro [FRANCA]","Novato [FRANCA]"],"Recrutador [FRANCA]":{"promote":false,"alerts":false,"message":false,"deposit":false,"chat":false,"demote":false,"dismiss":false,"invite":false,"withdraw":false},"Sub-Lider [FRANCA]":{"promote":false,"alerts":false,"message":false,"logs_view":true,"deposit":false,"chat":false,"demote":false,"dismiss":false,"invite":false,"withdraw":false}}', '{}', '{}', 'VIP GOLD', 5000, 1850323961),
	('Grota', '{}', NULL, NULL, '', 0, '{}', '{"Lider [GROTA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Gerente [GROTA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [GROTA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [GROTA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [GROTA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [GROTA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Inglaterra', '{}', NULL, NULL, '', 0, '{}', '{"Sub-Lider [INGLATERRA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [INGLATERRA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Gerente [INGLATERRA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [INGLATERRA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [INGLATERRA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [INGLATERRA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Jornal', '{}', NULL, NULL, '', 0, '{}', '{"Reporter [JORNAL]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Estagiario [JORNAL]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Diretor [JORNAL]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Produtor [JORNAL]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Korea', '{}', NULL, NULL, '', 0, '{}', '{"Membro [KOREA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [KOREA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [KOREA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [KOREA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [KOREA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [KOREA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Lacoste', '{}', NULL, NULL, '', 0, '{}', '{"Sub-Lider [LACOSTE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [LACOSTE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [LACOSTE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [LACOSTE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [LACOSTE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [LACOSTE]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true}}', '{}', '{}', NULL, NULL, NULL),
	('Lux', '{}', NULL, NULL, '', 0, '{}', '{"Novato [LUX]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [LUX]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [LUX]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [LUX]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [LUX]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [LUX]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Mafia', '{}', NULL, NULL, '', 0, '{}', '{"Lider [MAFIA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Novato [MAFIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [MAFIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [MAFIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [MAFIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [MAFIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Mainstreet', '{}', NULL, NULL, '', 0, '{}', '{"Lider [MAINSTREET]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Novato [MAINSTREET]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [MAINSTREET]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [MAINSTREET]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [MAINSTREET]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [MAINSTREET]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Mecanica', '{}', NULL, NULL, '', 0, '{}', '{"Recrutador [MECANICA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Mecanico [MECANICA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [MECANICA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [MECANICA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [MECANICA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [MECANICA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Medusa', '{}', NULL, NULL, '', 0, '{}', '{"Gerente [MEDUSA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [MEDUSA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [MEDUSA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [MEDUSA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [MEDUSA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Novato [MEDUSA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Mercenarios', '{}', NULL, NULL, '', 0, '{}', '{"Gerente [MERCENARIOS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [MERCENARIOS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [MERCENARIOS]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Novato [MERCENARIOS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [MERCENARIOS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [MERCENARIOS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Mexico', '{}', NULL, NULL, '', 0, '{}', '{"Recrutador [MEXICO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [MEXICO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [MEXICO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [MEXICO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [MEXICO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [MEXICO]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true}}', '{}', '{}', NULL, NULL, NULL),
	('Milicia', '{}', NULL, NULL, '', 0, '{}', '{"Membro [MILICIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [MILICIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [MILICIA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [MILICIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [MILICIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [MILICIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Motoclube', '{}', NULL, NULL, '', 0, '{}', '{"Lider [MOTOCLUBE]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [MOTOCLUBE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [MOTOCLUBE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [MOTOCLUBE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [MOTOCLUBE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [MOTOCLUBE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Pcc', '{}', NULL, NULL, '', 0, '{}', '{"Sub-Lider [PCC]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [PCC]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [PCC]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [PCC]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Recrutador [PCC]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [PCC]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Redline', '{}', NULL, NULL, '', 0, '{}', '{"Novato [REDLINE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [REDLINE]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Gerente [REDLINE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [REDLINE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Mecanico [REDLINE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [REDLINE]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Russia', '{}', NULL, NULL, '', 0, '{}', '{"Sub-Lider [RUSSIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [RUSSIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [RUSSIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [RUSSIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [RUSSIA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Membro [RUSSIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Tcp', '{}', NULL, NULL, '', 0, '{}', '{"Gerente [TCP]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [TCP]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [TCP]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [TCP]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [TCP]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [TCP]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Tdu', '{}', NULL, NULL, '', 0, '{}', '{"Recrutador [TDU]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [TDU]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [TDU]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Novato [TDU]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [TDU]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [TDU]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Tequila', '{}', NULL, NULL, '', 0, '{}', '{"Novato [TEQUILA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [TEQUILA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Sub-Lider [TEQUILA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [TEQUILA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [TEQUILA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [TEQUILA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Turquia', '{}', NULL, NULL, '', 0, '{}', '{"Sub-Lider [TURQUIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [TURQUIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [TURQUIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [TURQUIA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Novato [TURQUIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [TURQUIA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Vagos', '{}', NULL, NULL, '', 0, '{}', '{"Lider [VAGOS]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Recrutador [VAGOS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [VAGOS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [VAGOS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [VAGOS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [VAGOS]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Vanilla', '{}', NULL, NULL, '', 0, '{}', '{"Sub-Lider [VANILLA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Gerente [VANILLA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [VANILLA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [VANILLA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [VANILLA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [VANILLA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true}}', '{}', '{}', NULL, NULL, NULL),
	('Vaticano', '{}', NULL, NULL, '', 0, '{}', '{"Recrutador [VATICANO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [VATICANO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [VATICANO]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Gerente [VATICANO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [VATICANO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Novato [VATICANO]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL),
	('Yakuza', '{}', NULL, NULL, '', 0, '{}', '{"Novato [YAKUZA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Lider [YAKUZA]":{"invite":true,"demote":true,"chat":true,"message":true,"withdraw":true,"leader":true,"logs_view":true,"promote":true,"dismiss":true,"alerts":true,"deposit":true},"Gerente [YAKUZA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Sub-Lider [YAKUZA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"logs_view":true,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Membro [YAKUZA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false},"Recrutador [YAKUZA]":{"invite":false,"demote":false,"chat":false,"message":false,"withdraw":false,"promote":false,"dismiss":false,"alerts":false,"deposit":false}}', '{}', '{}', NULL, NULL, NULL);

-- Copiando estrutura para tabela revolt.revolt_orgs_logs
CREATE TABLE IF NOT EXISTS `revolt_orgs_logs` (
  `organization` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `expire_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.revolt_orgs_logs: ~54 rows (aproximadamente)
INSERT IGNORE INTO `revolt_orgs_logs` (`organization`, `user_id`, `role`, `name`, `description`, `date`, `expire_at`) VALUES
	('Franca', 4, 'Lider [FRANCA]', 'Bryan Alvez', 'Depósito - R$ 1000', '02/03/2026 17:06:39', 1775073999),
	('ORG', 4, '', '', 'Setou VIP da org (VIP GOLD) por 30 dia(s) / salário 5000', '02/03/2026 17:39:17', 1775075957),
	('Franca', 4, '', '', 'Setou VIP da org (VIP GOLD) por 30 dia(s) / salário 5000', '02/03/2026 17:53:35', 1775076815),
	('Franca', 4, '', '', 'Setou VIP da org (VIP GOLD) por 30 dia(s) / salário 5000', '02/03/2026 17:53:40', 1775076820),
	('Franca', 4, 'Lider [FRANCA]', 'Bryan Alvez', 'Depósito - R$ 111', '03/03/2026 14:45:51', 1775151951),
	('Franca', 4, '', '', 'Atualizou configurações da organização', '03/03/2026 14:48:58', 1775152138),
	('Franca', 4, '', '', 'Setou VIP da org (VIP GOLD) por 900 dia(s) / salário 5000', '03/03/2026 15:52:34', 1775155954),
	('Franca', 4, '', '', 'Setou VIP da org (VIP GOLD) por 900 dia(s) / salário 5000', '03/03/2026 15:52:41', 1775155961),
	('Franca', 4, 'Lider [FRANCA]', 'Bryan Alvez', 'Depósito - R$ 10000', '03/03/2026 17:52:51', 1775163171),
	('Franca', 4, 'Lider [FRANCA]', 'Bryan Alvez', 'Depósito - R$ 2999', '03/03/2026 17:53:03', 1775163183),
	('Franca', 4, '', '', 'Atualizou configurações da organização', '03/03/2026 18:23:18', 1775164998),
	('Franca', 4, 'Lider [FRANCA]', '#4', 'Quitou (03/03/2026 19:40:07) | tempo logado: 00:00:00 | motivo: Server shutting down: Ctrl-C pressed in server console.', '03/03/2026 19:40:07', 1775169607),
	('Franca', 4, 'Lider [FRANCA]', 'Bryan Alvez', 'Saque - R$ 14110', '03/03/2026 20:54:13', 1775174053),
	('Franca', 4, 'Lider [FRANCA]', 'Bryan Alvez', 'Depósito - R$ 14100', '03/03/2026 20:54:48', 1775174088),
	('Franca', 4, 'Lider [FRANCA]', 'Bryan Alvez', 'Depósito - R$ 9000', '03/03/2026 20:54:53', 1775174093),
	('Franca', 4, 'Lider [FRANCA]', '#4', 'Quitou (03/03/2026 21:09:49) | tempo logado: 00:00:00 | motivo: Game crashed: VCRUNTIME140.dll!memcpy_repmovs (0xb)', '03/03/2026 21:09:49', 1775174989),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '03/03/2026 21:53:07', 1775177587),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '03/03/2026 21:53:09', 1775177589),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '03/03/2026 21:54:52', 1775177692),
	('Franca', 4, 'Lider [FRANCA]', '#4', 'Desconectou (03/03/2026 23:39:41) | tempo logado: 00:00:10 | motivo: crash', '03/03/2026 23:39:41', 1775183981),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '04/03/2026 00:25:34', 1775186734),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Rebaixou o membro #4', '04/03/2026 00:26:09', 1775186769),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Rebaixou o membro #4', '04/03/2026 00:26:11', 1775186771),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Rebaixou o membro #4', '04/03/2026 00:26:13', 1775186773),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Rebaixou o membro #4', '04/03/2026 00:26:14', 1775186774),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Rebaixou o membro #4', '04/03/2026 00:26:30', 1775186790),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '04/03/2026 00:26:38', 1775186798),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '04/03/2026 00:26:52', 1775186812),
	('Franca', 4, 'Novato [FRANCA]', 'Bryan Alvez', 'Saque - R$ 100', '04/03/2026 00:27:02', 1775186822),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Promoveu o membro #4', '04/03/2026 00:27:25', 1775186845),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Promoveu o membro #4', '04/03/2026 00:27:26', 1775186846),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Promoveu o membro #4', '04/03/2026 00:27:27', 1775186847),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Promoveu o membro #4', '04/03/2026 00:27:28', 1775186848),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Promoveu o membro #4', '04/03/2026 00:27:29', 1775186849),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Promoveu o membro #4', '04/03/2026 00:27:32', 1775186852),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Rebaixou o membro #4', '04/03/2026 00:27:34', 1775186854),
	('Franca', 4, 'Lider', 'Quick Rei Delas', 'Promoveu o membro #4', '04/03/2026 00:27:36', 1775186856),
	('Franca', 4, 'Lider [FRANCA]', '#4', 'Desconectou (05/03/2026 14:34:03) | tempo logado: 38:08:12 | motivo: Exiting', '05/03/2026 14:34:03', 1775324043),
	('Franca', 4, 'Lider [FRANCA]', '#4', 'Desconectou (05/03/2026 19:27:03) | tempo logado: 00:00:00 | motivo: Couldn\'t load resource hud: Couldn\'t load resource hud from reso...', '05/03/2026 19:27:03', 1775341623),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '05/03/2026 21:41:52', 1775349712),
	('Franca', 4, 'Lider [FRANCA]', '#4', 'Desconectou (06/03/2026 09:11:11) | tempo logado: 00:00:00 | motivo: Exiting', '06/03/2026 09:11:11', 1775391071),
	('Franca', 4, 'Lider [FRANCA]', '#4', 'Desconectou (06/03/2026 22:44:32) | tempo logado: 09:00:02 | motivo: Exiting', '06/03/2026 22:44:32', 1775439872),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '08/03/2026 23:41:32', 1775616092),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '08/03/2026 23:53:33', 1775616813),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '08/03/2026 23:55:07', 1775616907),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '10/03/2026 16:08:03', 1775761683),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '10/03/2026 16:08:34', 1775761714),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '10/03/2026 16:29:02', 1775762942),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '10/03/2026 16:30:25', 1775763025),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '10/03/2026 17:37:13', 1775767033),
	('Franca', 4, '', '', 'Atualizou hierarquia de cargos (ordem do painel)', '10/03/2026 17:37:17', 1775767037),
	('Franca', 4, 'Lider [FRANCA]', 'Bryan Alvez', 'Saque - R$ 1', '10/03/2026 17:37:27', 1775767047),
	('Franca', 4, 'Lider [FRANCA]', 'Bryan Alvez', 'Depósito - R$ 32', '10/03/2026 17:37:36', 1775767056),
	('Franca', 4, 'Lider [FRANCA]', '#4', 'Desconectou (10/03/2026 17:55:21) | tempo logado: 00:18:13 | motivo: Server shutting down: SIGHUP received', '10/03/2026 17:55:21', 1775768121);

-- Copiando estrutura para tabela revolt.revolt_orgs_members
CREATE TABLE IF NOT EXISTS `revolt_orgs_members` (
  `user_id` int(11) NOT NULL,
  `org` varchar(50) NOT NULL,
  `group` varchar(80) DEFAULT NULL,
  `tier` int(11) DEFAULT 10,
  `joindate` int(11) DEFAULT 0,
  `lastlogin` int(11) DEFAULT 0,
  `timeplayed` int(11) DEFAULT 0,
  `lastlogout` int(11) DEFAULT 0,
  PRIMARY KEY (`user_id`),
  KEY `idx_org` (`org`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.revolt_orgs_members: ~1 rows (aproximadamente)
INSERT IGNORE INTO `revolt_orgs_members` (`user_id`, `org`, `group`, `tier`, `joindate`, `lastlogin`, `timeplayed`, `lastlogout`) VALUES
	(4, 'Franca', 'Lider [FRANCA]', 1, 1772594561, 1773175028, 170787, 1773176121);

-- Copiando estrutura para tabela revolt.revolt_orgs_player_infos
CREATE TABLE IF NOT EXISTS `revolt_orgs_player_infos` (
  `user_id` int(11) NOT NULL,
  `organization` varchar(50) DEFAULT NULL,
  `joindate` int(11) DEFAULT 0,
  `lastlogin` int(11) DEFAULT 0,
  `timeplayed` int(11) DEFAULT 0,
  `lastlogout` int(11) DEFAULT 0,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.revolt_orgs_player_infos: ~1 rows (aproximadamente)
INSERT IGNORE INTO `revolt_orgs_player_infos` (`user_id`, `organization`, `joindate`, `lastlogin`, `timeplayed`, `lastlogout`) VALUES
	(4, 'Franca', 1772594561, 1773175028, 170787, 1773176121);

-- Copiando estrutura para tabela revolt.smartphone_bank_invoices
CREATE TABLE IF NOT EXISTS `smartphone_bank_invoices` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `payee_id` int(11) NOT NULL,
  `payer_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL DEFAULT '',
  `value` int(11) NOT NULL,
  `paid` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_bank_invoices: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_blocks
CREATE TABLE IF NOT EXISTS `smartphone_blocks` (
  `user_id` int(11) NOT NULL,
  `phone` varchar(32) NOT NULL,
  PRIMARY KEY (`user_id`,`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_blocks: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_calls
CREATE TABLE IF NOT EXISTS `smartphone_calls` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `initiator` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 0,
  `status` varchar(255) NOT NULL,
  `video` tinyint(4) NOT NULL DEFAULT 0,
  `anonymous` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `initiator_index` (`initiator`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_calls: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_casino
CREATE TABLE IF NOT EXISTS `smartphone_casino` (
  `user_id` int(11) NOT NULL,
  `balance` bigint(20) NOT NULL DEFAULT 0,
  `double` bigint(20) NOT NULL DEFAULT 0,
  `crash` bigint(20) NOT NULL DEFAULT 0,
  `mine` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_casino: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_contacts
CREATE TABLE IF NOT EXISTS `smartphone_contacts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_index` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_contacts: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_gallery
CREATE TABLE IF NOT EXISTS `smartphone_gallery` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `folder` varchar(255) NOT NULL DEFAULT '/',
  `url` varchar(255) NOT NULL,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_gallery: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_ifood_orders
CREATE TABLE IF NOT EXISTS `smartphone_ifood_orders` (
  `id` varchar(10) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `worker_id` int(11) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  `fee` int(11) DEFAULT NULL,
  `rate` tinyint(4) DEFAULT 0,
  `created_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_ifood_orders: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_instagram
CREATE TABLE IF NOT EXISTS `smartphone_instagram` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `bio` varchar(255) NOT NULL,
  `avatarURL` varchar(255) DEFAULT NULL,
  `verified` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_instagram: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_instagram_followers
CREATE TABLE IF NOT EXISTS `smartphone_instagram_followers` (
  `follower_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`follower_id`,`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_instagram_followers: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_instagram_likes
CREATE TABLE IF NOT EXISTS `smartphone_instagram_likes` (
  `post_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`post_id`,`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_instagram_likes: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_instagram_notifications
CREATE TABLE IF NOT EXISTS `smartphone_instagram_notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  `content` varchar(512) NOT NULL,
  `saw` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id_index` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_instagram_notifications: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_instagram_posts
CREATE TABLE IF NOT EXISTS `smartphone_instagram_posts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` bigint(20) NOT NULL,
  `post_id` bigint(20) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id_index` (`profile_id`),
  KEY `post_id_index` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_instagram_posts: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_olx
CREATE TABLE IF NOT EXISTS `smartphone_olx` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `description` varchar(1024) NOT NULL,
  `images` varchar(1024) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_olx: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_paypal_transactions
CREATE TABLE IF NOT EXISTS `smartphone_paypal_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `target` bigint(20) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'payment',
  `description` varchar(255) DEFAULT NULL,
  `value` bigint(20) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_paypal_transactions: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_tinder
CREATE TABLE IF NOT EXISTS `smartphone_tinder` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `bio` varchar(1024) NOT NULL,
  `age` tinyint(4) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `show_gender` tinyint(4) NOT NULL,
  `tags` varchar(255) NOT NULL,
  `show_tags` tinyint(4) NOT NULL,
  `target` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`),
  KEY `gender_index` (`gender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_tinder: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_tinder_messages
CREATE TABLE IF NOT EXISTS `smartphone_tinder_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` int(11) NOT NULL,
  `target` int(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `liked` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_tinder_messages: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_tinder_rating
CREATE TABLE IF NOT EXISTS `smartphone_tinder_rating` (
  `profile_id` int(11) NOT NULL,
  `rated_id` int(11) NOT NULL,
  `rating` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`profile_id`,`rated_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_tinder_rating: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_tor_messages
CREATE TABLE IF NOT EXISTS `smartphone_tor_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel` varchar(24) NOT NULL DEFAULT 'geral',
  `sender` varchar(50) NOT NULL,
  `image` varchar(512) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `channel_index` (`channel`),
  KEY `sender_index` (`sender`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_tor_messages: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_tor_payments
CREATE TABLE IF NOT EXISTS `smartphone_tor_payments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` bigint(20) NOT NULL,
  `target` bigint(20) NOT NULL,
  `amount` int(11) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_tor_payments: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_twitter_followers
CREATE TABLE IF NOT EXISTS `smartphone_twitter_followers` (
  `follower_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`follower_id`,`profile_id`),
  KEY `profile_id_index` (`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_twitter_followers: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_twitter_likes
CREATE TABLE IF NOT EXISTS `smartphone_twitter_likes` (
  `tweet_id` bigint(20) NOT NULL,
  `profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`tweet_id`,`profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_twitter_likes: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_twitter_profiles
CREATE TABLE IF NOT EXISTS `smartphone_twitter_profiles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `avatarURL` varchar(255) NOT NULL,
  `bannerURL` varchar(255) NOT NULL,
  `bio` varchar(255) DEFAULT NULL,
  `verified` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_twitter_profiles: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_twitter_tweets
CREATE TABLE IF NOT EXISTS `smartphone_twitter_tweets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `tweet_id` bigint(20) DEFAULT NULL,
  `content` varchar(280) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `profile_id_index` (`profile_id`),
  KEY `tweet_id_index` (`tweet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_twitter_tweets: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_uber_trips
CREATE TABLE IF NOT EXISTS `smartphone_uber_trips` (
  `id` varchar(10) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  `from` varchar(255) DEFAULT NULL,
  `to` varchar(255) DEFAULT NULL,
  `user_rate` tinyint(4) DEFAULT 0,
  `driver_rate` tinyint(4) DEFAULT 0,
  `created_at` int(11) DEFAULT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_uber_trips: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_weazel
CREATE TABLE IF NOT EXISTS `smartphone_weazel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `author` varchar(255) NOT NULL,
  `tag` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(4096) NOT NULL,
  `imageURL` varchar(255) DEFAULT NULL,
  `videoURL` varchar(255) DEFAULT NULL,
  `views` int(11) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_weazel: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_whatsapp
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp` (
  `owner` varchar(32) NOT NULL,
  `avatarURL` varchar(255) DEFAULT NULL,
  `read_receipts` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_whatsapp: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_whatsapp_channels
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_channels` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `target_index` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_whatsapp_channels: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_whatsapp_groups
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `avatarURL` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `members` varchar(1200) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_whatsapp_groups: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.smartphone_whatsapp_messages
CREATE TABLE IF NOT EXISTS `smartphone_whatsapp_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `channel_id` bigint(20) unsigned NOT NULL,
  `sender` varchar(50) NOT NULL,
  `image` varchar(512) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `deleted_by` varchar(255) DEFAULT NULL,
  `readed` tinyint(4) NOT NULL DEFAULT 0,
  `saw_at` bigint(20) NOT NULL DEFAULT 0,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_index` (`sender`),
  KEY `channel_id_index` (`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.smartphone_whatsapp_messages: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.taxs
CREATE TABLE IF NOT EXISTS `taxs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Name` varchar(50) NOT NULL,
  `Date` varchar(50) NOT NULL,
  `Hour` varchar(50) NOT NULL,
  `Value` int(11) NOT NULL,
  `Message` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.taxs: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.transactions
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `Type` varchar(50) NOT NULL,
  `Date` varchar(50) NOT NULL,
  `Value` int(11) NOT NULL,
  `Balance` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.transactions: ~43 rows (aproximadamente)
INSERT IGNORE INTO `transactions` (`id`, `Passport`, `Type`, `Date`, `Value`, `Balance`) VALUES
	(1, 4, 'entry', '18/02/2026', 5000, 0),
	(2, 4, 'entry', '18/02/2026', 10000, 5000),
	(3, 4, 'entry', '18/02/2026', 10000, 15000),
	(4, 4, 'entry', '18/02/2026', 10000, 25000),
	(5, 4, 'entry', '18/02/2026', 10000, 35000),
	(6, 4, 'entry', '18/02/2026', 10000, 45000),
	(7, 4, 'entry', '18/02/2026', 10000, 55000),
	(8, 4, 'entry', '18/02/2026', 10000, 65000),
	(9, 4, 'entry', '18/02/2026', 10000, 75000),
	(10, 4, 'entry', '18/02/2026', 10000, 85000),
	(11, 4, 'entry', '18/02/2026', 10000, 95000),
	(12, 4, 'entry', '18/02/2026', 10000, 105000),
	(13, 4, 'entry', '18/02/2026', 10000, 115000),
	(14, 4, 'entry', '18/02/2026', 10000, 125000),
	(15, 4, 'entry', '18/02/2026', 10000, 135000),
	(16, 4, 'entry', '18/02/2026', 10000, 145000),
	(17, 4, 'entry', '18/02/2026', 10000, 155000),
	(18, 4, 'entry', '18/02/2026', 10000, 165000),
	(19, 4, 'entry', '18/02/2026', 10000, 175000),
	(20, 4, 'entry', '18/02/2026', 10000, 185000),
	(21, 4, 'exit', '18/02/2026', 1000, 195000),
	(22, 4, 'exit', '18/02/2026', 1, 194000),
	(23, 4, 'entry', '18/02/2026', 10000, 193999),
	(24, 4, 'entry', '18/02/2026', 10000, 203999),
	(25, 4, 'entry', '18/02/2026', 10000, 213999),
	(26, 4, 'entry', '18/02/2026', 10000, 223999),
	(27, 4, 'entry', '18/02/2026', 10000, 233999),
	(28, 4, 'withdraw', '28/02/2026', 100, 92829),
	(29, 4, 'withdraw', '28/02/2026', 1, 92828),
	(30, 4, 'withdraw', '28/02/2026', 100, 92728),
	(31, 4, 'withdraw', '28/02/2026', 1, 92727),
	(32, 4, 'withdraw', '01/03/2026', 15000, 77727),
	(33, 4, 'deposit', '01/03/2026', 2000, 79727),
	(34, 4, 'withdraw', '02/03/2026', 1000, 78727),
	(35, 4, 'withdraw', '03/03/2026', 111, 78616),
	(36, 4, 'withdraw', '03/03/2026', 10000, 68616),
	(37, 4, 'withdraw', '03/03/2026', 2999, 65617),
	(38, 4, 'deposit', '03/03/2026', 14110, 79727),
	(39, 4, 'withdraw', '03/03/2026', 14100, 65627),
	(40, 4, 'withdraw', '03/03/2026', 9000, 56627),
	(41, 4, 'deposit', '04/03/2026', 100, 56727),
	(42, 4, 'deposit', '10/03/2026', 1, 56728),
	(43, 4, 'withdraw', '10/03/2026', 32, 56696);

-- Copiando estrutura para tabela revolt.us_families_logs
CREATE TABLE IF NOT EXISTS `us_families_logs` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `family_name` tinytext DEFAULT 'Sem nome?',
  `log_type` tinytext DEFAULT 'Sem padrão?',
  `description` text DEFAULT 'Sem descrição',
  `created_at` int(20) NOT NULL,
  `delete_time` int(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.us_families_logs: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Passport` int(11) NOT NULL,
  `vehicle` varchar(100) NOT NULL,
  `tax` int(20) NOT NULL DEFAULT 0,
  `plate` varchar(10) DEFAULT NULL,
  `rental` int(20) NOT NULL DEFAULT 0,
  `arrest` int(20) NOT NULL DEFAULT 0,
  `dismantle` int(1) NOT NULL DEFAULT 0,
  `engine` int(4) NOT NULL DEFAULT 1000,
  `body` int(4) NOT NULL DEFAULT 1000,
  `health` int(4) NOT NULL DEFAULT 1000,
  `fuel` int(3) NOT NULL DEFAULT 100,
  `nitro` int(5) NOT NULL DEFAULT 0,
  `work` varchar(5) NOT NULL DEFAULT 'false',
  `doors` longtext NOT NULL,
  `windows` longtext NOT NULL,
  `tyres` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `vehicle` (`vehicle`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.vehicles: ~1 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.vrp_properties
CREATE TABLE IF NOT EXISTS `vrp_properties` (
  `property_id` int(11) NOT NULL AUTO_INCREMENT,
  `property` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `owner` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `tax` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '{}',
  `information` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`property_id`,`property`(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.vrp_properties: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.warehouse
CREATE TABLE IF NOT EXISTS `warehouse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `weight` int(10) NOT NULL DEFAULT 200,
  `password` varchar(50) NOT NULL,
  `Passport` int(10) NOT NULL DEFAULT 0,
  `tax` int(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `Passport` (`Passport`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela revolt.warehouse: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela revolt.warrants
CREATE TABLE IF NOT EXISTS `warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` text DEFAULT NULL,
  `identity` text DEFAULT NULL,
  `status` text DEFAULT NULL,
  `nidentity` text DEFAULT NULL,
  `timeStamp` text DEFAULT NULL,
  `reason` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portId` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela revolt.warrants: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
