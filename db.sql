CREATE DATABASE  IF NOT EXISTS `gym_app` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `gym_app`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: gym_app
-- ------------------------------------------------------
-- Server version	8.4.3

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
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `AddressID` int NOT NULL,
  `Flat` varchar(20) DEFAULT NULL,
  `Street` varchar(255) NOT NULL,
  `City` varchar(100) NOT NULL,
  `StateRegion` varchar(100) NOT NULL,
  `PostalCode` varchar(20) NOT NULL,
  `Country` varchar(100) NOT NULL,
  PRIMARY KEY (`AddressID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (101,'3A','Oak Street','Isleworth','London','TW7 5LA','UK'),(102,'1','Maple Road','Richmond','London','TW9 1QA','UK'),(103,'12','Birch Avenue','Twickenham','London','TW1 3DH','UK'),(104,'25','Cedar Drive','Hounslow','London','TW4 6DB','UK'),(105,'1','Elm Close','Isleworth','London','TW7 7LB','UK'),(106,'2','Walnut Lane','Brentford','London','TW8 8JA','UK');
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `AdminID` int NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `PhoneNumber` varchar(15) NOT NULL,
  `Password` varchar(255) NOT NULL,
  PRIMARY KEY (`AdminID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'Sarah','Williams','sarah.williams@gym.com','07720 334455','hashed/encrypted'),(2,'Emily','Johnson','emily.johnson@gym.com','07715 445566','hashed/encrypted'),(3,'Chloe','Thomas','chloe.thomas@gym.com','07800 667788','hashed/encrypted');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gym_user`
--

DROP TABLE IF EXISTS `gym_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gym_user` (
  `UserID` varchar(10) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `PhoneNumber` varchar(15) NOT NULL,
  `AddressID` int NOT NULL,
  `MembershipID` int DEFAULT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `AddressID` (`AddressID`),
  KEY `MembershipID` (`MembershipID`),
  CONSTRAINT `gym_user_ibfk_1` FOREIGN KEY (`AddressID`) REFERENCES `address` (`AddressID`),
  CONSTRAINT `gym_user_ibfk_2` FOREIGN KEY (`MembershipID`) REFERENCES `membership` (`MembershipID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gym_user`
--

LOCK TABLES `gym_user` WRITE;
/*!40000 ALTER TABLE `gym_user` DISABLE KEYS */;
INSERT INTO `gym_user` VALUES ('GMUK1001','Emma','Johnson','1990-05-14','emma.johnson@gmail.com','emma123','07712 345678',101,201),('GMUK1002','Olivia','Brown','1985-08-22','olivia.brown@yahoo.com','olivia123','07703 998822',102,NULL),('GMUK1003','Sophia','Wilson','1992-11-18','sophia.wilson@outlook.com','sophia123','07720 445566',103,202),('GMUK1004','Isabella','Smith','1988-01-30','isabella.smith@gmail.com','bella123','07709 112233',104,NULL),('GMUK1005','Ava','Taylor','1995-07-10','ava.taylor@gmail.com','ava123','07800 113344',105,206),('GMUK1006','Lily','Walker','1993-04-22','lilly.walker@gmail.com','lily123','07715 334422',106,NULL);
/*!40000 ALTER TABLE `gym_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `membership`
--

DROP TABLE IF EXISTS `membership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `membership` (
  `MembershipID` int NOT NULL,
  `MembershipType` varchar(100) NOT NULL,
  `Description` text NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  `DurationMonths` float NOT NULL,
  PRIMARY KEY (`MembershipID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membership`
--

LOCK TABLES `membership` WRITE;
/*!40000 ALTER TABLE `membership` DISABLE KEYS */;
INSERT INTO `membership` VALUES (201,'Monthly','Access to gym and 1 class per week',29.99,1),(202,'Quarterly','Full access + unlimited classes',79.99,3),(206,'Annual','Full access + unlimited classes + personal trainer sessions',249.99,12);
/*!40000 ALTER TABLE `membership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `membership_subscription`
--

DROP TABLE IF EXISTS `membership_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `membership_subscription` (
  `SubscriptionID` int NOT NULL AUTO_INCREMENT,
  `UserID` varchar(10) NOT NULL,
  `MembershipID` int NOT NULL,
  `JoinDate` date NOT NULL,
  `ExpiryDate` date NOT NULL,
  PRIMARY KEY (`SubscriptionID`),
  KEY `UserID` (`UserID`),
  KEY `MembershipID` (`MembershipID`),
  CONSTRAINT `membership_subscription_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `gym_user` (`UserID`),
  CONSTRAINT `membership_subscription_ibfk_2` FOREIGN KEY (`MembershipID`) REFERENCES `membership` (`MembershipID`),
  CONSTRAINT `membership_subscription_chk_1` CHECK ((`ExpiryDate` > `JoinDate`))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membership_subscription`
--

LOCK TABLES `membership_subscription` WRITE;
/*!40000 ALTER TABLE `membership_subscription` DISABLE KEYS */;
INSERT INTO `membership_subscription` VALUES (1,'GMUK1001',201,'2025-04-01','2025-05-01'),(2,'GMUK1003',202,'2025-03-15','2025-06-15'),(3,'GMUK1005',206,'2025-01-01','2026-01-01');
/*!40000 ALTER TABLE `membership_subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainer`
--

DROP TABLE IF EXISTS `trainer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trainer` (
  `TrainerID` int NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `PhoneNumber` varchar(15) NOT NULL,
  `Specialization` varchar(100) NOT NULL,
  `ExperienceYears` int NOT NULL,
  PRIMARY KEY (`TrainerID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainer`
--

LOCK TABLES `trainer` WRITE;
/*!40000 ALTER TABLE `trainer` DISABLE KEYS */;
INSERT INTO `trainer` VALUES (1,'Lucy','Taylor','lucy.taylor@gmail.com','07701 900007','Yoga',5),(2,'Mia','Clarke','mia.clarke@email.com','07701 445577','Strength Training',7),(3,'Isabella','White','isabella.white@gmail.com','07701 446677','Pilates',4),(4,'Ava','Collins','ava.collins@gmail.com','07701 445588','Weight Lifting',6),(5,'Olivia','Martin','olivia.martin@gmail.com','07701 557798','Aerobics',3),(6,'Sophia','Lee','sophia.lee@hotmail.com','07701 556633','Kickboxing',8);
/*!40000 ALTER TABLE `trainer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'gym_app'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-16 20:59:40
