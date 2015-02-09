-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 09, 2015 at 02:27 PM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `spInsert_user`(IN `p_username` VARCHAR(25), IN `p_password` VARCHAR(32))
BEGIN 
    INSERT INTO user
         (
			   username,
               password_md5
         )
    VALUES 
         ( 
           p_username,
           p_password                    
         ); 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `applicant`
--

CREATE TABLE IF NOT EXISTS `applicant` (
  `key` int(11) NOT NULL AUTO_INCREMENT,
  `applicant_id` varchar(25) NOT NULL,
  `application_placeholder` int(11) DEFAULT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `applicant_id` (`applicant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `score`
--

CREATE TABLE IF NOT EXISTS `score` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `applicant` varchar(25) NOT NULL,
  `reviewer` varchar(25) NOT NULL,
  `score_1` decimal(10,0) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `applicant` (`applicant`),
  KEY `reviewer` (`reviewer`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(25) NOT NULL,
  `password_md5` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `score`
--
ALTER TABLE `score`
  ADD CONSTRAINT `fk_username` FOREIGN KEY (`reviewer`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `fk_applicant` FOREIGN KEY (`applicant`) REFERENCES `applicant` (`applicant_id`);
