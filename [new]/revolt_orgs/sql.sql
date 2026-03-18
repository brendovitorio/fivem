-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           11.1.0-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
USE revolt;
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

-- Exportação de dados foi desmarcado.

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
  `vip_expires_at` int(11) DEFAULT NULL,
  `vip_salary` int(11) DEFAULT 0,
  PRIMARY KEY (`organization`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportação de dados foi desmarcado.

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

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela revolt.revolt_orgs_player_infos
CREATE TABLE IF NOT EXISTS `revolt_orgs_player_infos` (
  `user_id` int(11) NOT NULL,
  `organization` varchar(50) DEFAULT NULL,
  `joindate` int(11) DEFAULT 0,
  `lastlogin` int(11) DEFAULT 0,
  `lastlogout` int(11) DEFAULT 0,
  `timeplayed` int(11) DEFAULT 0,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabela persistente de membros (necessária para listar membros offline/online no painel)
CREATE TABLE IF NOT EXISTS `revolt_orgs_members` (
  `user_id` int(11) NOT NULL,
  `org` varchar(50) NOT NULL,
  `group` varchar(80) DEFAULT NULL,
  `tier` int(11) DEFAULT 10,
  `joindate` int(11) DEFAULT 0,
  `lastlogin` int(11) DEFAULT 0,
  `lastlogout` int(11) DEFAULT 0,
  `timeplayed` int(11) DEFAULT 0,
  PRIMARY KEY (`user_id`),
  KEY `idx_org` (`org`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportação de dados foi desmarcado.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
