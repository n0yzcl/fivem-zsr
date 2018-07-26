-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 26, 2018 at 05:44 AM
-- Server version: 10.1.28-MariaDB
-- PHP Version: 7.1.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fivem_r408`
--

-- --------------------------------------------------------

--
-- Table structure for table `crafting`
--

CREATE TABLE `crafting` (
  `identifier` varchar(150) COLLATE utf8mb4_bin NOT NULL,
  `bandages` int(11) NOT NULL DEFAULT '0',
  `cleanwater` int(11) NOT NULL DEFAULT '0',
  `cookedmeat` int(11) NOT NULL DEFAULT '0',
  `dirtywater` int(11) NOT NULL DEFAULT '0',
  `drinkitems` int(11) NOT NULL DEFAULT '0',
  `ducktape` int(11) NOT NULL DEFAULT '0',
  `emptybottles` int(11) NOT NULL DEFAULT '0',
  `enginekit` int(11) NOT NULL DEFAULT '0',
  `fooditems` int(11) NOT NULL DEFAULT '0',
  `gunpowder` int(11) NOT NULL DEFAULT '0',
  `rawmeat` int(11) NOT NULL DEFAULT '0',
  `scrapcloth` int(11) NOT NULL DEFAULT '0',
  `scrapmetal` int(11) NOT NULL DEFAULT '0',
  `woodlogs` int(11) NOT NULL DEFAULT '0',
  `woodmaterials` int(11) NOT NULL DEFAULT '0',
  `zblood` int(11) NOT NULL DEFAULT '0',
  `zcredits` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `crafting`
--
ALTER TABLE `crafting`
  ADD PRIMARY KEY (`identifier`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
