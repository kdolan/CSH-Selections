-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 06, 2015 at 08:26 AM
-- Server version: 5.6.19-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `selections`
--
CREATE DATABASE IF NOT EXISTS `selections` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `selections`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`kdolan`@`%` PROCEDURE `spGet_applicantAverage`(IN p_applicantID varchar(25))
SELECT * FROM SCORE
#Selects an decimal that is the applicants average score accross all criteria$$

CREATE DEFINER=`kdolan`@`%` PROCEDURE `spGet_applicantCriteriaAverage`(IN `p_applicantID` VARCHAR(25), IN `p_criteriaId` INT)
SELECT * FROM  `score` 
#Selects an decimal that is the applicants average score for the specified criteria$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGet_applicantGroups`()
    NO SQL
SELECT  `group` 
FROM  `applicant` 
GROUP BY  `group` 
ORDER BY  `group`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGet_applicantInGroup`(IN `groupId` INT)
    NO SQL
SELECT  `applicant_id` 
FROM  `applicant` 
WHERE  `group` =groupId$$

CREATE DEFINER=`kdolan`@`%` PROCEDURE `spGet_criteria`()
SELECT  `id` ,  `criteria_name` ,  `criteria_description` ,  `min_score` ,  `max_score` ,  `weight` ,  `disabled` 
FROM  `selections`.`criteria` 
WHERE disabled!=1$$

CREATE DEFINER=`kdolan`@`%` PROCEDURE `spGet_overallCriteriaAverage`(IN p_criteriaId INT)
SELECT * FROM SCORE
#Selects an decimal that is the overall average score for the specified criteria$$

CREATE DEFINER=`selections`@`%` PROCEDURE `spInsert_applicant`(IN `p_applicant_id` VARCHAR(25), IN `p_application_html` VARCHAR(5000))
INSERT INTO applicant
         (
			   applicant_id,
               application_html
         )
    VALUES 
         ( 
           p_applicant_id,
           p_application_html
         )$$

CREATE DEFINER=`selections`@`%` PROCEDURE `spInsert_criteria`(IN `p_criteria_name` VARCHAR(100), IN `p_criteria_description` VARCHAR(250), IN `p_min_score` DECIMAL(10,4), IN `p_max_score` DECIMAL(10,4), IN `p_weight` DECIMAL(10,4))
INSERT INTO criteria
         (
			   criteria_name,
               criteria_description,
               min_score,
               max_score,
               weight
         )
    VALUES 
         ( 
           p_criteria_name,
           p_criteria_description,
           p_min_score,
           p_max_score,
           p_weight
         )$$

CREATE DEFINER=`selections`@`%` PROCEDURE `spInsert_score`(IN `p_criteriaId` INT, IN `p_reviewerId` INT, IN `p_applicantId` INT)
INSERT INTO score
         (
			   applicant,
               reviewer,
               score
         )
    VALUES 
         ( 
           p_criteriaId,
           p_reviewerId,
           p_applicantId
         )$$

CREATE DEFINER=`selections`@`%` PROCEDURE `spInsert_user`(IN `p_username` VARCHAR(25), IN `p_password` VARCHAR(32))
INSERT INTO user
         (
			   username,
               password_md5
         )
    VALUES 
         ( 
           p_username,
           p_password                    
         )$$

CREATE DEFINER=`selections`@`%` PROCEDURE `spSession_create`(IN `session_key` VARCHAR(32), IN `username` VARCHAR(25), IN `password_md5` VARCHAR(32))
BEGIN
	DECLARE result int DEFAULT -404;
    IF EXISTS (SELECT 1 FROM `selections`.`user` WHERE
			`user`.`username` =username AND 
			`user`.`password_md5`=password_md5 AND
            `user`.`enabled`= 1   
        ) then
        
		INSERT INTO  `selections`.`sessions` (
        `username`,
		`session_key` ,
		`last_active`
		)
		VALUES (
        username,
		session_key, 
		CURRENT_TIMESTAMP
		);
        IF EXISTS (SELECT 1 FROM `selections`.`user` WHERE
			`user`.`username` =username AND 
            `user`.`admin`=1) then
            SET result = 1; #Valid. Admin
		ELSE
			SET result = 0; #Valid. Not-admin
		END IF;
	ELSE
		SET result = -1; #Invalid username/password
	END IF;
    SELECT result;
END$$

CREATE DEFINER=`selections`@`%` PROCEDURE `spSession_validate`(IN `session_key` VARCHAR(32))
BEGIN
	DECLARE result int DEFAULT -404;            
	DECLARE username varchar(25);
            
	#Check that the session exists and has not expired
	IF EXISTS (SELECT 1 FROM `selections`.`sessions` WHERE  
			`sessions`.`session_key` =session_key AND
            `last_active` >= DATE_ADD(NOW(),INTERVAL -2 HOUR)
            ) THEN 
			#Update session
            UPDATE  `selections`.`sessions`
			SET  `last_active` =  CURRENT_TIMESTAMP
			WHERE  `sessions`.`session_key` =session_key;
			
			SELECT sessions.username INTO username
			FROM  sessions
			WHERE  sessions.session_key = session_key;
            #SELECT username;		
			
			IF EXISTS (SELECT 1 FROM `selections`.`user` WHERE
				`user`.`username` =username AND 
				`user`.`admin`=1) then
				SET result = 1; #Valid. Admin
			ELSE
				SET result = 0; #Valid. Not-admin
			END IF;

			IF EXISTS (SELECT 1 FROM `selections`.`user` WHERE
				`user`.`enabled` =0) then
				SET result=-1;
			END IF;
		ELSE
			SET result=-1;
		END IF;
	SELECT result;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `applicant`
--

CREATE TABLE IF NOT EXISTS `applicant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applicant_id` varchar(25) NOT NULL,
  `group` int(11) DEFAULT NULL,
  `application_html` varchar(5000) DEFAULT NULL,
  `gender` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `applicant_id` (`applicant_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Table structure for table `criteria`
--

CREATE TABLE IF NOT EXISTS `criteria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `criteria_name` varchar(100) NOT NULL,
  `criteria_description` varchar(250) NOT NULL,
  `min_score` decimal(10,4) NOT NULL,
  `max_score` decimal(10,4) NOT NULL,
  `weight` decimal(10,4) NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `critera_name` (`criteria_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `score`
--

CREATE TABLE IF NOT EXISTS `score` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `criteria_id` int(11) DEFAULT NULL,
  `applicant` varchar(25) NOT NULL,
  `session_key` varchar(32) NOT NULL,
  `score` decimal(10,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applicant` (`applicant`),
  KEY `reviewer` (`session_key`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(25) NOT NULL,
  `session_name` varchar(25) NOT NULL,
  `session_key` varchar(32) NOT NULL,
  `last_active` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_key` (`session_key`),
  KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=34 ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(25) NOT NULL,
  `password_md5` varchar(32) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `admin` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `score`
--
ALTER TABLE `score`
  ADD CONSTRAINT `score_ibfk_1` FOREIGN KEY (`applicant`) REFERENCES `applicant` (`applicant_id`),
  ADD CONSTRAINT `score_ibfk_2` FOREIGN KEY (`session_key`) REFERENCES `sessions` (`session_key`);

--
-- Constraints for table `sessions`
--
ALTER TABLE `sessions`
  ADD CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`);
