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
  `AddressID` int NOT NULL AUTO_INCREMENT,
  `Flat` varchar(20) DEFAULT NULL,
  `Street` varchar(255) NOT NULL,
  `City` varchar(100) NOT NULL,
  `StateRegion` varchar(100) NOT NULL,
  `PostalCode` varchar(20) NOT NULL,
  `Country` varchar(100) NOT NULL,
  PRIMARY KEY (`AddressID`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (101,'3A','Oak Street','Isleworth','London','TW7 5LA','UK'),(102,'1','Maple Road','Richmond','London','TW9 1QA','UK'),(103,'12','Birch Avenue','Twickenham','London','TW1 3DH','UK'),(104,'25','Cedar Drive','Hounslow','London','TW4 6DB','UK'),(105,'1','Elm Close','Isleworth','London','TW7 7LB','UK'),(106,'2','Walnut Lane','Brentford','London','TW8 8JA','UK'),(107,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(108,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(109,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(110,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(111,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(112,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(113,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(114,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(115,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(116,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(117,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(118,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(119,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(120,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(121,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(122,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(123,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(124,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(125,NULL,'Maple Road','Richmond','London','TW9 1QA','UK'),(126,NULL,'Maple Road','Richmond','London','TW9 1QA','UK'),(127,NULL,'Stagsway','Isleworth','London','TW7 5PG','UK'),(128,NULL,'Elm Close','Isleworth','London','TW7 7LB','UK'),(129,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(130,NULL,'Maple Road','Richmond','London','TW7 5PG','UK'),(131,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(132,NULL,'Maple Road','Richmond','London','TW9 1QA','UK'),(133,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(134,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(135,NULL,'Stagsway','Isleworth','London','TW7 5PG','UK'),(136,NULL,'Stagsway','Isleworth','London','TW7 5PG','UK'),(137,NULL,'Stagsway','Isleworth','London','TW7 5PG','UK'),(138,NULL,'Oak Street','Isleworth','London','TW7 5LA','UK'),(139,NULL,'Stagsway','Isleworth','London','TW7 5PG','UK'),(140,NULL,'Stagsway','Isleworth','London','TW7 5PG','UK'),(141,NULL,'Stagsway','Isleworth','London','TW7 5PG','UK'),(142,NULL,'Stagsway','Isleworth','London','TW7 5PG','UK'),(143,NULL,'Stagsway','Isleworth','London','TW7 5PG','UK');
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
INSERT INTO `admin` VALUES (1,'Sarah','Williams','sarah.williams@gym.com','07720 334455','scrypt:32768:8:1$dKpPHAYzyHVwMm6B$d6d0cab11374621f7afb69969ae5dd5b01e81a2e217b200f0c8e2a903b047ac94ace60761f6e737ea369fca829cfa740a7b63f417984efaf22430139128defc1'),(2,'Emily','Johnson','emily.johnson@gym.com','07715 445566','hashed/encrypted'),(3,'Chloe','Thomas','chloe.thomas@gym.com','07800 667788','hashed/encrypted'),(4,'Admin','GirlCoded','admin@girlcoded.com','07700 567890','scrypt:32768:8:1$zL6LZOmjkR1PoHk8$3e7ffac9158a1fcd6ccbd4e2673e59e6ca864e40558c1fb63a01bf7943055b03489fa671e9ad1dc44642fc8bb6fc3b0d42867788a7c763165fd06897883881fc');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class_schedule`
--

DROP TABLE IF EXISTS `class_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_schedule` (
  `ScheduleID` int NOT NULL,
  `class_id` int DEFAULT NULL,
  `ScheduleDate` date DEFAULT NULL,
  `StartTime` time DEFAULT NULL,
  `EndTime` time DEFAULT NULL,
  `Location` varchar(50) DEFAULT NULL,
  `AvailableSeats` int DEFAULT NULL,
  `DayOfWeek` varchar(10) DEFAULT NULL,
  `TrainerID` int NOT NULL,
  PRIMARY KEY (`ScheduleID`),
  UNIQUE KEY `unique_schedule` (`ScheduleDate`,`StartTime`,`EndTime`,`Location`,`class_id`,`TrainerID`),
  KEY `class_id` (`class_id`),
  KEY `fk_class_schedule_trainer` (`TrainerID`),
  CONSTRAINT `class_schedule_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `fitness_class` (`class_id`),
  CONSTRAINT `fk_class_schedule_trainer` FOREIGN KEY (`TrainerID`) REFERENCES `trainer` (`TrainerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_schedule`
--

LOCK TABLES `class_schedule` WRITE;
/*!40000 ALTER TABLE `class_schedule` DISABLE KEYS */;
INSERT INTO `class_schedule` VALUES (1201,1,'2025-04-28','09:00:00','10:00:00','Studio A',24,'Monday',1),(1202,1,'2025-04-28','18:00:00','19:00:00','Studio A',24,'Monday',1),(1203,1,'2025-04-30','09:00:00','10:00:00','Studio A',24,'Wednesday',1),(1204,1,'2025-04-30','18:00:00','19:00:00','Studio A',25,'Wednesday',1),(1205,1,'2025-05-02','09:00:00','10:00:00','Studio A',25,'Friday',1),(1206,1,'2025-05-02','18:00:00','19:00:00','Studio A',25,'Friday',1),(1207,1,'2025-05-04','09:00:00','10:00:00','Studio A',24,'Sunday',1),(1208,1,'2025-05-04','18:00:00','19:00:00','Studio A',25,'Sunday',1),(1301,2,'2025-04-29','12:00:00','13:00:00','Studio B',19,'Tuesday',2),(1302,2,'2025-05-01','12:00:00','13:00:00','Studio B',19,'Thursday',2),(1303,2,'2025-05-03','12:00:00','13:00:00','Studio B',20,'Saturday',2),(1304,2,'2025-04-29','18:00:00','19:00:00','Studio B',20,'Tuesday',2),(1305,2,'2025-05-01','18:00:00','19:00:00','Studio B',20,'Thursday',2),(1306,2,'2025-05-03','18:00:00','19:00:00','Studio B',20,'Saturday',2),(1401,3,'2025-04-28','11:00:00','12:00:00','Studio C',18,'Monday',3),(1402,3,'2025-04-30','11:00:00','12:00:00','Studio C',18,'Wednesday',3),(1403,3,'2025-05-03','11:00:00','12:00:00','Studio C',18,'Saturday',3),(1404,3,'2025-04-28','17:00:00','18:00:00','Studio C',18,'Monday',3),(1405,3,'2025-04-30','17:00:00','18:00:00','Studio C',18,'Wednesday',3),(1406,3,'2025-05-03','17:00:00','18:00:00','Studio C',18,'Saturday',3),(1501,4,'2025-04-29','13:00:00','14:00:00','Studio D',15,'Tuesday',4),(1502,4,'2025-05-01','13:00:00','14:00:00','Studio D',15,'Thursday',4),(1503,4,'2025-04-29','18:00:00','19:00:00','Studio D',14,'Tuesday',4),(1504,4,'2025-05-01','18:00:00','19:00:00','Studio D',15,'Thursday',4),(1601,5,'2025-04-28','08:00:00','09:00:00','Studio E',30,'Monday',5),(1602,5,'2025-04-29','08:00:00','09:00:00','Studio E',30,'Tuesday',5),(1603,5,'2025-04-30','08:00:00','09:00:00','Studio E',30,'Wednesday',5),(1604,5,'2025-05-01','08:00:00','09:00:00','Studio E',30,'Thursday',5),(1605,5,'2025-05-02','08:00:00','09:00:00','Studio E',30,'Friday',5),(1606,5,'2025-04-28','17:30:00','18:30:00','Studio E',30,'Monday',5),(1607,5,'2025-04-29','17:30:00','18:30:00','Studio E',30,'Tuesday',5),(1608,5,'2025-04-30','17:30:00','18:30:00','Studio E',30,'Wednesday',5),(1609,5,'2025-05-01','17:30:00','18:30:00','Studio E',30,'Thursday',5),(1610,5,'2025-05-02','17:30:00','18:30:00','Studio E',30,'Friday',5),(1701,6,'2025-04-30','10:30:00','11:30:00','Studio F',16,'Wednesday',6),(1702,6,'2025-05-02','10:30:00','11:30:00','Studio F',16,'Friday',6),(1703,6,'2025-05-04','10:30:00','11:30:00','Studio F',16,'Sunday',6),(1704,6,'2025-04-30','18:30:00','19:30:00','Studio F',16,'Wednesday',6),(1705,6,'2025-05-02','18:30:00','19:30:00','Studio F',16,'Friday',6),(1706,6,'2025-05-04','18:30:00','19:30:00','Studio F',16,'Sunday',6);
/*!40000 ALTER TABLE `class_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classbooking`
--

DROP TABLE IF EXISTS `classbooking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classbooking` (
  `BookingID` int NOT NULL AUTO_INCREMENT,
  `UserID` varchar(10) DEFAULT NULL,
  `ScheduleID` int DEFAULT NULL,
  `BookingDate` datetime DEFAULT NULL,
  `BookingStatus` enum('Booked','Cancelled','Attended') DEFAULT NULL,
  PRIMARY KEY (`BookingID`),
  KEY `UserID` (`UserID`),
  KEY `ScheduleID` (`ScheduleID`),
  CONSTRAINT `classbooking_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `gym_user` (`UserID`),
  CONSTRAINT `classbooking_ibfk_2` FOREIGN KEY (`ScheduleID`) REFERENCES `class_schedule` (`ScheduleID`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classbooking`
--

LOCK TABLES `classbooking` WRITE;
/*!40000 ALTER TABLE `classbooking` DISABLE KEYS */;
INSERT INTO `classbooking` VALUES (1,'GMUK1001',101,'2025-04-20 08:00:00','Booked'),(2,'GMUK1002',102,'2025-04-20 09:30:00','Booked'),(3,'GMUK1003',105,'2025-04-21 10:00:00','Cancelled'),(4,'GMUK1004',106,'2025-04-21 11:00:00','Booked'),(5,'GMUK1009',102,'2025-04-24 12:38:30','Booked'),(6,'GMUK1009',102,'2025-04-24 12:38:38','Booked'),(7,'GMUK1009',102,'2025-04-24 12:38:43','Booked'),(8,'GMUK1009',120,'2025-04-24 12:46:31','Booked'),(9,'GMUK1009',102,'2025-04-24 13:07:39','Booked'),(11,'GMUK1010',115,'2025-04-24 14:02:48','Booked'),(13,'GMUK1010',122,'2025-04-24 22:21:28','Booked'),(14,'GMUK1010',144,'2025-04-25 13:14:26','Booked'),(15,'GMUK1010',103,'2025-04-25 16:52:33','Booked'),(17,'GMUK1010',306,'2025-04-26 01:57:14','Booked'),(18,'GMUK1010',1401,'2025-04-26 02:01:07','Booked'),(20,'GMUK1010',1202,'2025-04-26 02:26:13','Booked'),(24,'GMUK1010',1201,'2025-04-26 12:34:47','Booked'),(26,'GMUK1010',406,'2025-04-26 17:15:23','Booked'),(34,'GMUK1012',201,'2025-04-26 23:38:37','Booked'),(36,'GMUK1012',606,'2025-04-27 01:57:44','Booked'),(37,'GMUK1012',609,'2025-04-27 02:01:38','Booked'),(42,'GMUK1015',609,'2025-04-28 22:52:42','Booked'),(53,'GMUK1016',301,'2025-04-29 14:43:03','Booked'),(81,'GMUK1013',305,'2025-04-30 12:07:27','Booked'),(82,'GMUK1013',405,'2025-04-30 12:08:12','Booked'),(83,'GMUK1013',1203,'2025-04-30 12:59:56','Booked'),(84,'GMUK1013',1302,'2025-04-30 13:01:52','Booked'),(86,'GMUK1013',1301,'2025-04-30 13:05:41','Booked'),(87,'GMUK1013',1207,'2025-04-30 13:06:48','Booked');
/*!40000 ALTER TABLE `classbooking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_us`
--

DROP TABLE IF EXISTS `contact_us`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_us` (
  `ContactID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Message` text NOT NULL,
  `SubmissionDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ContactID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_us`
--

LOCK TABLES `contact_us` WRITE;
/*!40000 ALTER TABLE `contact_us` DISABLE KEYS */;
INSERT INTO `contact_us` VALUES (1,'Chaitra Boregowda','chaitra123@gmail.com','Hello form chaitra!!','2025-04-26 23:09:24'),(2,'Chaitra Boregowda','chaitra123@gmail.com','Hello form chaitra!!','2025-04-26 23:11:31'),(3,'Chaitra Boregowda','chaitra123@gmail.com','Hello form chaitra!!','2025-04-26 23:12:23'),(4,'Renee','Renee@email.com','Hello from renee !!','2025-04-27 17:10:38');
/*!40000 ALTER TABLE `contact_us` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `day_pass`
--

DROP TABLE IF EXISTS `day_pass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `day_pass` (
  `PassID` int NOT NULL AUTO_INCREMENT,
  `UserID` varchar(20) NOT NULL,
  `PurchaseDate` date NOT NULL,
  `PassStatus` enum('Active','Expired') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`PassID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `day_pass_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `gym_user` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `day_pass`
--

LOCK TABLES `day_pass` WRITE;
/*!40000 ALTER TABLE `day_pass` DISABLE KEYS */;
INSERT INTO `day_pass` VALUES (1,'GMUK1010','2025-04-26','Active'),(2,'GMUK1012','2025-04-26','Active'),(3,'GMUK1012','2025-04-27','Active'),(4,'GMUK1013','2025-04-27','Active'),(5,'GMUK1015','2025-04-28','Active'),(6,'GMUK1016','2025-04-29','Active');
/*!40000 ALTER TABLE `day_pass` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fitness_class`
--

DROP TABLE IF EXISTS `fitness_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fitness_class` (
  `class_id` int NOT NULL AUTO_INCREMENT,
  `class_name` varchar(50) NOT NULL,
  `description` text,
  `Price` decimal(6,2) DEFAULT NULL,
  `MaxParticipants` int DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`class_id`),
  UNIQUE KEY `class_name` (`class_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_class`
--

LOCK TABLES `fitness_class` WRITE;
/*!40000 ALTER TABLE `fitness_class` DISABLE KEYS */;
INSERT INTO `fitness_class` VALUES (1,'Yoga','A peaceful yoga session to start your day. Relax and stretch your body with guided meditation and poses.',10.00,25,'yoga.webp'),(2,'Strength Training','Build strength and endurance through full-body training with weights and resistance exercises.',12.00,20,'strength_training_new.jpeg'),(3,'Pilates','Improve flexibility and core strength with Pilates exercises that focus on posture and balance.',11.00,18,'pilate_new.jpeg'),(4,'Weight Lifting','Introductory class focused on learning weight lifting techniques and proper form for strength training.',13.00,15,'weight_lifting_new.jpeg'),(5,'Aerobics','High-energy aerobic workout to improve cardiovascular health and stamina with a mix of dance moves and music.',8.00,30,'aerobics_new.jpeg'),(6,'Kickboxing','Fast-paced kickboxing workout that combines punches, kicks, and cardio exercises to build strength and endurance.',10.50,16,'kick_boxing_new.png');
/*!40000 ALTER TABLE `fitness_class` ENABLE KEYS */;
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
  `LastLogin` datetime DEFAULT NULL,
  `RegisteredDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `AddressID` (`AddressID`),
  KEY `MembershipID` (`MembershipID`),
  CONSTRAINT `gym_user_ibfk_1` FOREIGN KEY (`AddressID`) REFERENCES `address` (`AddressID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `gym_user_ibfk_2` FOREIGN KEY (`MembershipID`) REFERENCES `membership` (`MembershipID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gym_user`
--

LOCK TABLES `gym_user` WRITE;
/*!40000 ALTER TABLE `gym_user` DISABLE KEYS */;
INSERT INTO `gym_user` VALUES ('GMUK1001','Emma','Johnson','1990-05-14','emma.johnson@gmail.com','emma123','07712 345678',101,201,NULL,'2025-04-28 10:30:12'),('GMUK1002','Olivia','Brown','1985-08-22','olivia.brown@yahoo.com','olivia123','07703 998822',102,NULL,NULL,'2025-04-28 10:30:12'),('GMUK1003','Sophia','Wilson','1992-11-18','sophia.wilson@outlook.com','sophia123','07720 445566',103,202,NULL,'2025-04-28 10:30:12'),('GMUK1004','Isabella','Smith','1988-01-30','isabella.smith@gmail.com','bella123','07709 112233',104,NULL,NULL,'2025-04-28 10:30:12'),('GMUK1005','Ava','Taylor','1995-07-10','ava.taylor@gmail.com','ava123','07800 113344',105,206,NULL,'2025-04-28 10:30:12'),('GMUK1006','Lily','Walker','1993-04-22','lilly.walker@gmail.com','lily123','07715 334422',106,NULL,NULL,'2025-04-28 10:30:12'),('GMUK1007','Anushka','Shetty','2000-07-22','anushkashetty@email.com','scrypt:32768:8:1$RCRzBSgMSc5RJCe7$26ddf2ca25041a39aa2051d88449e6d27f1b03de6a8a4ca7236a8a83f6be9cfbf25bf4d7cc63e3a1cd84966aec13949b8faad5ebb0fdba5536218838728c88d0','1234567891',131,NULL,NULL,'2025-04-28 10:30:12'),('GMUK1008','Lisa','Simpson','1997-03-20','lisa@email.com','scrypt:32768:8:1$Gq5C5iuxH1FaCSMb$b1e121b80b5c50788e0e02e426f3f93bcb04b10f6dd09c541eb986d0b56784b4d4a8883bf60e8762effd17014362f60330d8c920cd12bf75c7a1d149b27b6b95','1234567899',132,NULL,NULL,'2025-04-28 10:30:12'),('GMUK1009','Chaitra','Boregowda','1992-11-06','chaitra123@gmail.com','scrypt:32768:8:1$VVgFYu0Z25eoUv0R$ebb3ea307b3ba0f49b2e415380518984a7ef7f9d8b599e480ff235bd2764d8798264fde2f66623290813b1cbdfeba78e5563a5a9ae4e0a9041811b17a3e2c216','1234567892',133,NULL,'2025-04-24 13:15:54','2025-04-28 10:30:12'),('GMUK1010','Victoria','v','1990-11-18','victoria@gmail.com','scrypt:32768:8:1$e7vkQTZWPmX6Fo6s$06a5512763e07c4e503c7d46eb8f9670998100b3a731b844b7a20bbe71acfdbe7bf3debde47ba8c7895058021e5827575c601cf1930a6559350e760dbc8afec0','1234567899',134,NULL,'2025-04-26 22:27:56','2025-04-28 10:30:12'),('GMUK1011','Priyanka','chopra','2005-01-26','priya@gmail.com','scrypt:32768:8:1$kYGaOuRmSWclwPjh$cfdebcdef2a619e47ec74d5c8ba9dc05d23e182a3b1e5a113a4223d3c26330b9f554fced116456816a541cda559af2b8038a46b66c6e46f57018ef707bceca4a','1234567888',135,NULL,'2025-04-26 23:06:28','2025-04-28 10:30:12'),('GMUK1012','vidya','Shetty','2007-01-03','vidya@gmail.com','scrypt:32768:8:1$IOEKMwysndyRpziX$ce87e18a2f1d55f8d1771031f55f0d598d1c4b160614810f37b9facc75af054f42b36d34ca435e107dacf3c5d66143311c977fa5eec33cd8e8e138da45a1bb6d','1234567893',136,NULL,'2025-04-27 02:13:26','2025-04-28 10:30:12'),('GMUK1013','salma','s','2012-01-27','salma@gmail.com','scrypt:32768:8:1$C2qnRShN3Q9zDY6j$d48697b64b0fbb30ee4316d59335ac419970d740951937c212b624387cf55299f588664cb540a9e78885dd9a40b35623aa64ff976850b9b7c83b9583b7e36b45','1234567893',137,NULL,'2025-04-30 13:06:51','2025-04-28 10:30:12'),('GMUK1014','Deepa','Gowda','2006-02-14','deepa@email.com','scrypt:32768:8:1$4K90T9Iuw3vhuelu$4889c9ef1b479dd8236754f1bd04e5f0428338037cab5da3dda88deb6ac021761a483ccac25a0f2551a4d39930f1586564547db5e4c3615f752548c802a3d266','1234567898',138,NULL,NULL,'2025-04-28 10:30:12'),('GMUK1015','Jhaap','k','2003-07-18','jhaap@gmail.com','scrypt:32768:8:1$KcwodoVKq4okmmG1$3513791b3493720a9f9743a0928cd64253e7179164c29588212ccbaf8a814ed70a94ddbfeae4233e4b771817ebe93db0be7d68efebd025bd2f202d61d903b792','1234567899',142,NULL,'2025-04-29 00:12:58','2025-04-28 00:00:00'),('GMUK1016','Hitha','shree','2005-04-29','hita@gmail.com','scrypt:32768:8:1$TuFA2nEr8pDzELOK$d1a1e7b3628caae9a10baebf36b863cf1996407a18b0f621a43e1dd2a4cf1864ef8c11d83126b42457114b5d71530d51748746b2c15904927338077f03617c35','1234567899',143,202,'2025-04-29 18:08:32','2025-04-29 00:00:00');
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
  `Benefits` text,
  PRIMARY KEY (`MembershipID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membership`
--

LOCK TABLES `membership` WRITE;
/*!40000 ALTER TABLE `membership` DISABLE KEYS */;
INSERT INTO `membership` VALUES (201,'Basic','Limited access to gym facilities during off-peak hours and one group class per month',25.00,1,'Access to gym facilities during off-peak hours and one group class per month'),(202,'Gold','Full access to gym facilities, unlimited group classes, and nutrition workshops',80.00,3,'Unlimited access to gym facilities, unlimited group classes, and nutrition workshops'),(206,'Platinum','Full access to gym facilities, unlimited group classes, personal trainer sessions, exclusive nutrition and wellness programs, and priority customer support',120.00,6,'Unlimited access to gym facilities, unlimited classes, personal trainer sessions, nutrition and wellness programs, and priority customer support');
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
  UNIQUE KEY `unique_user_membership` (`UserID`,`MembershipID`),
  KEY `UserID` (`UserID`),
  KEY `MembershipID` (`MembershipID`),
  CONSTRAINT `membership_subscription_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `gym_user` (`UserID`),
  CONSTRAINT `membership_subscription_ibfk_2` FOREIGN KEY (`MembershipID`) REFERENCES `membership` (`MembershipID`),
  CONSTRAINT `membership_subscription_chk_1` CHECK ((`ExpiryDate` > `JoinDate`))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membership_subscription`
--

LOCK TABLES `membership_subscription` WRITE;
/*!40000 ALTER TABLE `membership_subscription` DISABLE KEYS */;
INSERT INTO `membership_subscription` VALUES (1,'GMUK1001',201,'2025-04-01','2025-05-01'),(2,'GMUK1003',202,'2025-03-15','2025-06-15'),(3,'GMUK1005',206,'2025-01-01','2026-01-01'),(4,'GMUK1011',202,'2025-04-26','2025-07-25'),(5,'GMUK1013',201,'2025-04-27','2025-05-27'),(6,'GMUK1015',201,'2025-04-28','2025-05-28'),(7,'GMUK1015',202,'2025-04-28','2025-07-27'),(10,'GMUK1016',202,'2025-04-29','2025-07-28');
/*!40000 ALTER TABLE `membership_subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `PaymentID` int NOT NULL AUTO_INCREMENT,
  `BookingID` int DEFAULT NULL,
  `PaymentDate` datetime DEFAULT NULL,
  `Amount` decimal(6,2) DEFAULT NULL,
  `Status` enum('Paid','Pending','Failed') DEFAULT NULL,
  `PaymentType` varchar(50) NOT NULL,
  `UserID` varchar(20) NOT NULL,
  `ScheduleID` int DEFAULT NULL,
  PRIMARY KEY (`PaymentID`),
  KEY `BookingID` (`BookingID`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`BookingID`) REFERENCES `classbooking` (`BookingID`)
) ENGINE=InnoDB AUTO_INCREMENT=551 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (501,1,'2025-04-20 08:05:00',12.00,'Paid','','',NULL),(502,2,'2025-04-20 09:35:00',12.00,'Pending','','',NULL),(503,3,'2025-04-21 10:05:00',13.50,'Failed','','',NULL),(504,4,'2025-04-21 11:10:00',14.00,'Paid','','',NULL),(505,NULL,'2025-04-26 17:16:58',12.00,'Paid','PayPerClass','GMUK1010',NULL),(506,NULL,'2025-04-26 17:39:27',12.00,'Paid','PayPerClass','GMUK1010',NULL),(507,NULL,'2025-04-26 23:38:38',12.00,'Paid','PayPerClass','GMUK1012',NULL),(508,NULL,'2025-04-26 23:39:31',20.00,'Paid','DayPass','GMUK1012',NULL),(509,NULL,'2025-04-27 02:01:39',8.00,'Paid','PayPerClass','GMUK1012',609),(510,NULL,'2025-04-27 02:02:36',20.00,'Paid','DayPass','GMUK1012',NULL),(511,NULL,'2025-04-27 18:34:09',10.00,'Paid','PayPerClass','GMUK1013',202),(512,NULL,'2025-04-27 18:34:57',20.00,'Paid','DayPass','GMUK1013',NULL),(513,NULL,'2025-04-28 18:51:15',12.00,'Paid','PayPerClass','GMUK1015',1304),(514,NULL,'2025-04-28 19:02:46',20.00,'Paid','DayPass','GMUK1015',NULL),(515,NULL,'2025-04-29 14:10:13',10.00,'Paid','PayPerClass','GMUK1016',202),(516,NULL,'2025-04-29 14:10:40',20.00,'Paid','DayPass','GMUK1016',NULL),(517,NULL,'2025-04-29 18:04:57',80.00,'Paid','Membership Purchase','GMUK1016',NULL),(518,NULL,'2025-04-29 21:42:49',12.00,'Paid','PayPerClass','GMUK1013',302),(519,NULL,'2025-04-29 21:43:40',12.00,'Paid','PayPerClass','GMUK1013',301),(520,NULL,'2025-04-29 21:45:28',10.00,'Paid','PayPerClass','GMUK1013',201),(521,NULL,'2025-04-29 21:45:48',10.00,'Paid','PayPerClass','GMUK1013',203),(522,NULL,'2025-04-29 21:46:32',10.00,'Paid','PayPerClass','GMUK1013',206),(523,NULL,'2025-04-29 21:47:28',10.00,'Paid','PayPerClass','GMUK1013',208),(524,NULL,'2025-04-29 22:01:00',10.00,'Paid','PayPerClass','GMUK1013',204),(525,NULL,'2025-04-29 22:50:58',10.00,'Paid','PayPerClass','GMUK1013',202),(526,NULL,'2025-04-29 22:56:25',12.00,'Paid','PayPerClass','GMUK1013',302),(527,NULL,'2025-04-29 23:21:04',10.00,'Paid','PayPerClass','GMUK1013',204),(528,NULL,'2025-04-29 23:25:03',10.00,'Paid','PayPerClass','GMUK1013',201),(529,NULL,'2025-04-29 23:28:35',10.00,'Paid','PayPerClass','GMUK1013',203),(530,NULL,'2025-04-29 23:35:11',12.00,'Paid','PayPerClass','GMUK1013',301),(531,NULL,'2025-04-29 23:40:59',10.00,'Paid','PayPerClass','GMUK1013',202),(532,NULL,'2025-04-29 23:41:41',10.00,'Paid','PayPerClass','GMUK1013',204),(533,NULL,'2025-04-29 23:50:09',10.00,'Paid','PayPerClass','GMUK1013',203),(534,NULL,'2025-04-30 00:05:56',10.00,'Paid','PayPerClass','GMUK1013',205),(535,NULL,'2025-04-30 09:44:36',12.00,'Paid','PayPerClass','GMUK1013',302),(536,NULL,'2025-04-30 09:48:27',10.00,'Paid','PayPerClass','GMUK1013',202),(537,NULL,'2025-04-30 10:18:36',10.00,'Paid','PayPerClass','GMUK1013',201),(538,NULL,'2025-04-30 10:27:46',10.00,'Paid','PayPerClass','GMUK1013',204),(539,NULL,'2025-04-30 10:31:51',10.00,'Paid','PayPerClass','GMUK1013',203),(540,NULL,'2025-04-30 10:39:36',10.00,'Paid','PayPerClass','GMUK1013',202),(541,NULL,'2025-04-30 10:45:45',10.00,'Paid','PayPerClass','GMUK1013',201),(542,NULL,'2025-04-30 10:56:53',10.00,'Paid','PayPerClass','GMUK1013',203),(543,NULL,'2025-04-30 11:02:26',10.00,'Paid','PayPerClass','GMUK1013',201),(544,NULL,'2025-04-30 12:07:28',12.00,'Paid','PayPerClass','GMUK1013',305),(545,NULL,'2025-04-30 12:08:13',11.00,'Paid','PayPerClass','GMUK1013',405),(546,NULL,'2025-04-30 12:59:57',10.00,'Paid','PayPerClass','GMUK1013',1203),(547,NULL,'2025-04-30 13:01:52',12.00,'Paid','PayPerClass','GMUK1013',1302),(548,NULL,'2025-04-30 13:04:04',10.00,'Paid','PayPerClass','GMUK1013',1207),(549,NULL,'2025-04-30 13:05:41',12.00,'Paid','PayPerClass','GMUK1013',1301),(550,NULL,'2025-04-30 13:06:49',10.00,'Paid','PayPerClass','GMUK1013',1207);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
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

-- Dump completed on 2025-04-30 13:11:57
