-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u3
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 20, 2018 at 05:36 PM
-- Server version: 5.5.60-0+deb8u1
-- PHP Version: 5.6.36-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `demo`
--
CREATE DATABASE IF NOT EXISTS `demo` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `demo`;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
`id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `created_at`) VALUES
(1, 'example_user1', 'REDACTED', '2018-06-06 22:27:13'),
(2, 'example_user2', 'REDACTED', '2018-06-06 22:27:24'),
(3, 'example_user3', 'REDACTED', '2018-06-06 22:27:44'),
(6, 'example_user4', 'REDACTED', '2018-06-27 16:44:28');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;

--
-- Database: `minersdb`
--
CREATE DATABASE IF NOT EXISTS `minersdb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `minersdb`;

-- --------------------------------------------------------

--
-- Table structure for table `miners`
--

CREATE TABLE IF NOT EXISTS `miners` (
`id` int(11) NOT NULL,
  `minerIp` varchar(15) NOT NULL,
  `macAddress` varchar(17) NOT NULL,
  `minerType` varchar(30) NOT NULL,
  `plocation` varchar(7) NOT NULL,
  `hashrate` varchar(8) NOT NULL,
  `maxTemp` varchar(8) NOT NULL,
  `farmName` varchar(30) NOT NULL,
  `numCards` varchar(8) NOT NULL,
  `uptime` varchar(6) NOT NULL,
  `poolUser` varchar(30) NOT NULL,
  `comments` varchar(500) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9794 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `miners`
--

INSERT INTO `miners` (`id`, `minerIp`, `macAddress`, `minerType`, `plocation`, `hashrate`, `maxTemp`, `farmName`, `numCards`, `uptime`, `poolUser`, `comments`) VALUES
(4459, '10.2.0.1', '02:a4:eb:79:1f:16', 'AntMiner', '1-1-1-1', '13645.', '83', 'Example-Farm', '', '', 'REDACTED', '"Example comment"'),
(4460, '10.2.0.2', '04:5c:8f:66:4a:e4', 'AntMiner', '1-1-1-2', '13601.', '84', 'Example-Farm', '', '', 'REDACTED', '"Example comment"'),
(4461, '10.2.0.4', '00:7f:04:4e:d7:d0', 'AntMiner S9', '1-1-1-3', '9249.2', '84', 'Example-Farm', '', '', 'REDACTED', '"Example comment"'); 