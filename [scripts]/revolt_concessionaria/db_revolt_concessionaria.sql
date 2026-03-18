CREATE TABLE IF NOT EXISTS `revolt_concessionaria` (
  `vehicle` VARCHAR(100) NOT NULL,
  `estoque` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`vehicle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET @db_name = DATABASE();

SET @column_exists = (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db_name
    AND TABLE_NAME = 'vehicles'
    AND COLUMN_NAME = 'alugado'
);
SET @sql = IF(
  @column_exists = 0,
  'ALTER TABLE `vehicles` ADD COLUMN `alugado` TINYINT(1) NOT NULL DEFAULT 0',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists = (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db_name
    AND TABLE_NAME = 'vehicles'
    AND COLUMN_NAME = 'data_alugado'
);
SET @sql = IF(
  @column_exists = 0,
  'ALTER TABLE `vehicles` ADD COLUMN `data_alugado` VARCHAR(20) NULL DEFAULT NULL',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = (
  SELECT COUNT(*)
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = @db_name
    AND TABLE_NAME = 'vehicles'
    AND INDEX_NAME = 'idx_vehicles_user_vehicle'
);
SET @sql = IF(
  @index_exists = 0,
  'CREATE INDEX `idx_vehicles_user_vehicle` ON `vehicles` (`Passport`,`vehicle`)',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = (
  SELECT COUNT(*)
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = @db_name
    AND TABLE_NAME = 'revolt_concessionaria'
    AND INDEX_NAME = 'idx_revolt_concessionaria_vehicle'
);
SET @sql = IF(
  @index_exists = 0,
  'CREATE INDEX `idx_revolt_concessionaria_vehicle` ON `revolt_concessionaria` (`vehicle`)',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;