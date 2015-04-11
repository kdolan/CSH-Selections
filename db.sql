-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 11, 2015 at 04:24 PM
-- Server version: 5.6.19-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `selections`
--

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
SELECT  `app_group` 
FROM  `applicant` 
WHERE `app_group`!=0
GROUP BY  `app_group` 
ORDER BY  `app_group`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGet_applicantInGroup`(IN `groupId` INT)
    NO SQL
SELECT  `applicant_id` 
FROM  `applicant` 
WHERE  `app_group` =groupId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spGet_applicants`()
    NO SQL
SELECT applicant_id
FROM  `applicant`$$

CREATE DEFINER=`kdolan`@`%` PROCEDURE `spGet_criteria`()
SELECT  `id` ,  `criteria_name` ,  `criteria_description` ,  `min_score` ,  `max_score` ,  `weight` ,  `disabled` 
FROM  `selections`.`criteria` 
WHERE disabled!=1$$

CREATE DEFINER=`kdolan`@`%` PROCEDURE `spGet_overallCriteriaAverage`(IN p_criteriaId INT)
SELECT * FROM SCORE
#Selects an decimal that is the overall average score for the specified criteria$$

CREATE DEFINER=`selections`@`%` PROCEDURE `spInsert_applicant`(IN `p_applicant_id` VARCHAR(25), IN `p_group` INT(11), IN `p_gender` BOOLEAN)
INSERT INTO applicant
         (
			   applicant_id,
               applicant.app_group,
               gender
         )
    VALUES 
         ( 
           p_applicant_id,
           p_group,
           p_gender
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

CREATE DEFINER=`selections`@`%` PROCEDURE `spInsert_score`(IN `p_criteriaId` INT, IN `p_applicant` VARCHAR(25), IN `p_sessionkey` VARCHAR(32), IN `p_score` DECIMAL(10,4))
INSERT INTO  `selections`.`score` (
`criteria_id` ,
`applicant` ,
`session_key` ,
`score`
)
VALUES (
p_criteriaId,  p_applicant,  p_sessionkey,  p_score
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

CREATE DEFINER=`selections`@`%` PROCEDURE `spSession_create`(IN `session_key` VARCHAR(32), IN `username` VARCHAR(25), IN `password_md5` VARCHAR(32), IN `session_name` VARCHAR(25), IN `ip_address` VARCHAR(25))
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
		`last_active`,
        `session_name`,
        `ip_address`
		)
		VALUES (
        username,
		session_key, 
		CURRENT_TIMESTAMP,
        session_name,
       	ip_address
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `spUpdate_applicant`(IN `p_applicantId` VARCHAR(25), IN `p_group` INT(11))
    NO SQL
UPDATE `selections`.`applicant` SET `app_group` = p_group
WHERE `applicant`.`applicant_id` = p_applicantId$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `applicant`
--

CREATE TABLE IF NOT EXISTS `applicant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applicant_id` varchar(25) NOT NULL,
  `app_group` int(11) DEFAULT NULL,
  `gender` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `applicant_id` (`applicant_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=67 ;

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

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
  KEY `reviewer` (`session_key`),
  KEY `criteria_id` (`criteria_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=46 ;

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
  ADD CONSTRAINT `score_ibfk_3` FOREIGN KEY (`criteria_id`) REFERENCES `criteria` (`id`),
  ADD CONSTRAINT `score_ibfk_1` FOREIGN KEY (`applicant`) REFERENCES `applicant` (`applicant_id`),
  ADD CONSTRAINT `score_ibfk_2` FOREIGN KEY (`session_key`) REFERENCES `sessions` (`session_key`);

--
-- Constraints for table `sessions`
--
ALTER TABLE `sessions`
  ADD CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`);
