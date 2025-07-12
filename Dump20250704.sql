CREATE DATABASE  IF NOT EXISTS `transitdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `transitdb`;
-- MySQL dump 10.13  Distrib 8.0.42, for macos15 (arm64)
--
-- Host: localhost    Database: transitdb
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Customers`
--

DROP TABLE IF EXISTS `Customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Customers` (
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `customer_password` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customers`
--

LOCK TABLES `Customers` WRITE;
/*!40000 ALTER TABLE `Customers` DISABLE KEYS */;
INSERT INTO `Customers` VALUES ('John','Smith','JSmith@gmail.com','JSmith','password123');
/*!40000 ALTER TABLE `Customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employees`
--

DROP TABLE IF EXISTS `Employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Employees` (
  `ssn` varchar(11) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `employee_password` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ssn`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employees`
--

LOCK TABLES `Employees` WRITE;
/*!40000 ALTER TABLE `Employees` DISABLE KEYS */;
/*!40000 ALTER TABLE `Employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reservations`
--

DROP TABLE IF EXISTS `Reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reservations` (
  `reservation_number` int NOT NULL,
  `customer_id` varchar(50) DEFAULT NULL,
  `origin_station_id` int DEFAULT NULL,
  `destination_station_id` int DEFAULT NULL,
  `transit_line_name` varchar(50) DEFAULT NULL,
  `departure_datetime` datetime DEFAULT NULL,
  `arrival_datetime` datetime DEFAULT NULL,
  `reservation_date` date DEFAULT NULL,
  `total_fare` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`reservation_number`),
  KEY `customer_id` (`customer_id`),
  KEY `origin_station_id` (`origin_station_id`),
  KEY `destination_station_id` (`destination_station_id`),
  KEY `transit_line_name` (`transit_line_name`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `Customers` (`username`),
  CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`origin_station_id`) REFERENCES `Stations` (`id`),
  CONSTRAINT `reservations_ibfk_3` FOREIGN KEY (`destination_station_id`) REFERENCES `Stations` (`id`),
  CONSTRAINT `reservations_ibfk_4` FOREIGN KEY (`transit_line_name`) REFERENCES `TrainSchedules` (`transit_line_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservations`
--

LOCK TABLES `Reservations` WRITE;
/*!40000 ALTER TABLE `Reservations` DISABLE KEYS */;
/*!40000 ALTER TABLE `Reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Stations`
--

DROP TABLE IF EXISTS `Stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stations` (
  `id` int NOT NULL,
  `station_name` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stations`
--

LOCK TABLES `Stations` WRITE;
/*!40000 ALTER TABLE `Stations` DISABLE KEYS */;
/*!40000 ALTER TABLE `Stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Stops_At`
--

DROP TABLE IF EXISTS `Stops_At`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stops_At` (
  `id` int NOT NULL,
  `transit_line_name` varchar(50) NOT NULL,
  `departure_datetime` datetime DEFAULT NULL,
  `arrival_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`,`transit_line_name`),
  KEY `transit_line_name` (`transit_line_name`),
  CONSTRAINT `stops_at_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Stations` (`id`),
  CONSTRAINT `stops_at_ibfk_2` FOREIGN KEY (`transit_line_name`) REFERENCES `TrainSchedules` (`transit_line_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stops_At`
--

LOCK TABLES `Stops_At` WRITE;
/*!40000 ALTER TABLE `Stops_At` DISABLE KEYS */;
/*!40000 ALTER TABLE `Stops_At` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Trains`
--

DROP TABLE IF EXISTS `Trains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Trains` (
  `id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Trains`
--

LOCK TABLES `Trains` WRITE;
/*!40000 ALTER TABLE `Trains` DISABLE KEYS */;
/*!40000 ALTER TABLE `Trains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TrainSchedules`
--

DROP TABLE IF EXISTS `TrainSchedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TrainSchedules` (
  `transit_line_name` varchar(50) NOT NULL,
  `train_id` int DEFAULT NULL,
  `origin_station_id` int DEFAULT NULL,
  `destination_station_id` int DEFAULT NULL,
  `num_stops` int DEFAULT NULL,
  `departure_datetime` datetime DEFAULT NULL,
  `arrival_datetime` datetime DEFAULT NULL,
  `travel_time` int DEFAULT NULL,
  `fixed_fare` float DEFAULT NULL,
  `fare_per_stop` float DEFAULT NULL,
  `line_type` varchar(50) DEFAULT NULL,
  `discount_type` varchar(50) DEFAULT NULL,
  `discount_percentage` float DEFAULT NULL,
  PRIMARY KEY (`transit_line_name`),
  KEY `train_id` (`train_id`),
  KEY `origin_station_id` (`origin_station_id`),
  KEY `destination_station_id` (`destination_station_id`),
  CONSTRAINT `trainschedules_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `Trains` (`id`),
  CONSTRAINT `trainschedules_ibfk_2` FOREIGN KEY (`origin_station_id`) REFERENCES `Stations` (`id`),
  CONSTRAINT `trainschedules_ibfk_3` FOREIGN KEY (`destination_station_id`) REFERENCES `Stations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TrainSchedules`
--

LOCK TABLES `TrainSchedules` WRITE;
/*!40000 ALTER TABLE `TrainSchedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `TrainSchedules` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-04 11:48:16
