CREATE TABLE IF NOT EXISTS `prison` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `police` varchar(255) DEFAULT '0',
  `nuser_id` int(11) NOT NULL DEFAULT '0',
  `services` int(11) NOT NULL DEFAULT '0',
  `fines` int(20) NOT NULL DEFAULT '0',
  `text` longtext,
  `date` text,
  `cops` longtext NOT NULL,
  `association` longtext NOT NULL,
  `residual` text,
  `url` longtext,
  PRIMARY KEY (`id`),
  KEY `idx_prison_nuser_id` (`nuser_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `port` (
  `portId` int(11) NOT NULL AUTO_INCREMENT,
  `identity` longtext,
  `user_id` text,
  `portType` longtext,
  `serial` longtext,
  `nidentity` longtext,
  `exam` longtext,
  `date` text,
  PRIMARY KEY (`portId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `victim_id` text,
  `police_name` text,
  `solved` tinyint(1) NOT NULL DEFAULT 0,
  `victim_name` text,
  `created_at` text,
  `victim_report` longtext,
  `updated_at` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` text,
  `identity` text,
  `status` text,
  `nidentity` text,
  `timeStamp` text,
  `reason` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
