-- -----------------------------------------------------
-- Table structure for portfolio database
-- Author: Arun Deshan
-- Date: 2025-06-03
-- -----------------------------------------------------

-- Drop existing tables if they exist
DROP TABLE IF EXISTS `experience_tech_stack`;
DROP TABLE IF EXISTS `project_tech_stack`;
DROP TABLE IF EXISTS `experiences`;
DROP TABLE IF EXISTS `projects`;
DROP TABLE IF EXISTS `writings`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `tech_stack`;

-- -----------------------------------------------------
-- Table: writings
-- -----------------------------------------------------
CREATE TABLE `writings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `link` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`)
);

-- -----------------------------------------------------
-- Table: users
-- -----------------------------------------------------
CREATE TABLE `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `position_name` VARCHAR(255) NOT NULL,
  `about` TEXT NOT NULL,
  PRIMARY KEY (`id`)
);

-- -----------------------------------------------------
-- Table: projects
-- -----------------------------------------------------
CREATE TABLE `projects` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `github_repo_link` TEXT NOT NULL,
  `other_link` TEXT NOT NULL,
  PRIMARY KEY (`id`)
);

-- -----------------------------------------------------
-- Table: experiences
-- -----------------------------------------------------
CREATE TABLE `experiences` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(255) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE DEFAULT NULL,
  `is_current_employee` TINYINT(1) NOT NULL DEFAULT '0',
  `position` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  PRIMARY KEY (`id`)
);

-- -----------------------------------------------------
-- Table: tech_stack
-- -----------------------------------------------------
CREATE TABLE `tech_stack` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`)
);

-- -----------------------------------------------------
-- Table: project_tech_stack
-- -----------------------------------------------------
CREATE TABLE `project_tech_stack` (
  `project_id` INT UNSIGNED NOT NULL,
  `tech_stack_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`project_id`, `tech_stack_id`),
  KEY `tech_stack_id` (`tech_stack_id`),
  CONSTRAINT `project_tech_stack_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `project_tech_stack_ibfk_2` FOREIGN KEY (`tech_stack_id`) REFERENCES `tech_stack` (`id`) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table: experience_tech_stack
-- -----------------------------------------------------
CREATE TABLE `experience_tech_stack` (
  `experience_id` INT UNSIGNED NOT NULL,
  `tech_stack_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`experience_id`, `tech_stack_id`),
  KEY `tech_stack_id` (`tech_stack_id`),
  CONSTRAINT `experience_tech_stack_ibfk_1` FOREIGN KEY (`experience_id`) REFERENCES `experiences` (`id`) ON DELETE CASCADE,
  CONSTRAINT `experience_tech_stack_ibfk_2` FOREIGN KEY (`tech_stack_id`) REFERENCES `tech_stack` (`id`) ON DELETE CASCADE
);
