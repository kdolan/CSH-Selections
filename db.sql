-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 20, 2015 at 02:20 PM
-- Server version: 5.6.19-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.5

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

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `applicant`
--

CREATE TABLE IF NOT EXISTS `applicant` (
  `key` int(11) NOT NULL AUTO_INCREMENT,
  `applicant_id` varchar(25) NOT NULL,
  `group` int(11) DEFAULT NULL,
  `application_html` varchar(5000) DEFAULT NULL,
  `gender` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `applicant_id` (`applicant_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `score`
--

CREATE TABLE IF NOT EXISTS `score` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `criteria_id` int(11) DEFAULT NULL,
  `applicant` int(11) NOT NULL,
  `reviewer` int(11) NOT NULL,
  `score` decimal(10,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applicant` (`applicant`),
  KEY `reviewer` (`reviewer`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(25) NOT NULL,
  `password_md5` varchar(32) NOT NULL,
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
  ADD CONSTRAINT `fk_applicant` FOREIGN KEY (`applicant`) REFERENCES `applicant` (`key`),
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`reviewer`) REFERENCES `user` (`id`);
