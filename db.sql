CREATE DATABASE  IF NOT EXISTS `gym_app` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `gym_app`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: gym_app
-- ------------------------------------------------------
-- Server version	8.4.3
SELECT * 
FROM gym_user;

DELETE FROM gym_user 
WHERE UserID IN ('GMUK0007', 'GMUK0008', 'GMUK0009', 'GMUK0010', 'GMUK0011');

SELECT UserID 
FROM gym_user 
ORDER BY CAST(SUBSTRING(UserID, 5) AS UNSIGNED) DESC 
LIMIT 1;

SELECT * FROM gym_user WHERE Email = 'ShineShetty@email.com';

SELECT * 
FROM address;

SELECT * FROM gym_user ORDER BY UserID DESC LIMIT 1;

SELECT * 
FROM class_schedule;

SELECT * 
FROM fitness_class;
--
ALTER TABLE fitness_class
ADD COLUMN image_url VARCHAR(255);

UPDATE fitness_class
SET image_url = '/images/yoga.webp'
WHERE class_name = 'Yoga';

UPDATE fitness_class
SET image_url = '/images/strength_training.webp'
WHERE class_name = 'Strength Training';

UPDATE fitness_class
SET image_url = '/images/pilates.webp'
WHERE class_name = 'Pilates';

UPDATE fitness_class
SET image_url = '/images/weight_lifting.jpeg'
WHERE class_name = 'Weight Lifting';

UPDATE fitness_class
SET image_url = '/images/aerobics.webp'
WHERE class_name = 'Aerobics';

UPDATE fitness_class
SET image_url = '/images/kick_boxing.webp'
WHERE class_name = 'Kickboxing';
--
UPDATE fitness_class SET image_url = '/static/images/yoga.webp' WHERE class_name = 'Yoga';
UPDATE fitness_class SET image_url = '/static/images/strength_training.webp' WHERE class_name = 'Strength Training';
UPDATE fitness_class SET image_url = '/static/images/pilates.webp' WHERE class_name = 'Pilates';
UPDATE fitness_class SET image_url = '/static/images/weight_lifting.jpeg' WHERE class_name = 'Weight Lifting';
UPDATE fitness_class SET image_url = '/static/images/aerobics.webp' WHERE class_name = 'Aerobics';
UPDATE fitness_class SET image_url = '/static/images/kick_boxing.webp' WHERE class_name = 'Kickboxing';

--

UPDATE fitness_class SET image_url = 'yoga.webp' WHERE class_name = 'Yoga';
UPDATE fitness_class SET image_url = 'strength_training.webp' WHERE class_name = 'Strength Training';
UPDATE fitness_class SET image_url = 'pilates.webp' WHERE class_name = 'Pilates';
UPDATE fitness_class SET image_url = 'weight_lifting.jpeg' WHERE class_name = 'Weight Lifting';
UPDATE fitness_class SET image_url = 'aerobics.webp' WHERE class_name = 'Aerobics';
UPDATE fitness_class SET image_url = 'kick_boxing.webp' WHERE class_name = 'Kickboxing';


SELECT * 
FROM membership_subscription;



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

SELECT CONSTRAINT_NAME 
FROM information_schema.KEY_COLUMN_USAGE 
WHERE TABLE_NAME = 'gym_user' AND COLUMN_NAME = 'AddressID';

ALTER TABLE gym_user DROP FOREIGN KEY gym_user_ibfk_1;

ALTER TABLE address MODIFY COLUMN AddressID INT NOT NULL AUTO_INCREMENT;

ALTER TABLE gym_user
ADD CONSTRAINT gym_user_ibfk_1
FOREIGN KEY (AddressID) REFERENCES address(AddressID)
ON DELETE CASCADE ON UPDATE CASCADE;




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
 
UPDATE admin
SET Password = 'pbkdf2:sha256:150000$abc123$123abc456def789'
WHERE Email = 'sarah.williams@gym.com';

SELECT * FROM admin WHERE Email = 'sarah.williams@gym.com';

UPDATE admin
SET Password = 'scrypt:32768:8:1$dKpPHAYzyHVwMm6B$d6d0cab11374621f7afb69969ae5dd5b01e81a2e217b200f0c8e2a903b047ac94ace60761f6e737ea369fca829cfa740a7b63f417984efaf22430139128defc1'
WHERE Email = 'sarah.williams@gym.com';


SELECT Password FROM admin WHERE Email = 'sarah.williams@gym.com';

select * from admin;

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
  PRIMARY KEY (`ScheduleID`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `class_schedule_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `fitness_class` (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

ALTER TABLE class_schedule
ADD COLUMN DayOfWeek VARCHAR(10) NULL;  -- Example values: "Monday", "Tuesday", etc.

ALTER TABLE class_schedule
MODIFY COLUMN DayOfWeek ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL DEFAULT 'Monday';

select * from class_schedule;

SELECT DISTINCT DayOfWeek FROM class_schedule;

SELECT DayOfWeek, Location, StartTime, EndTime, AvailableSeats, ScheduleID
FROM class_schedule
WHERE class_id = 1
ORDER BY FIELD(DayOfWeek, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), StartTime;

SELECT ScheduleDate, DayOfWeek, Location, StartTime, EndTime, AvailableSeats, ScheduleID
FROM class_schedule
WHERE class_id = 1
ORDER BY ScheduleDate, FIELD(DayOfWeek, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), StartTime;


UPDATE class_schedule
SET DayOfWeek = DAYNAME(ScheduleDate)
WHERE ScheduleDate IS NOT NULL;

SET SQL_SAFE_UPDATES = 0;

SET SQL_SAFE_UPDATES = 1;

INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek) VALUES
-- Yoga Classes
(155, 1, '2025-05-12', '09:00:00', '10:00:00', 'Studio A', 25, 'Monday'),
(156, 1, '2025-05-12', '18:00:00', '19:00:00', 'Studio A', 25, 'Monday'),
(157, 1, '2025-05-17', '07:30:00', '08:30:00', 'Studio A', 25, 'Saturday'),
(158, 1, '2025-05-17', '18:00:00', '19:00:00', 'Studio A', 25, 'Saturday'),

-- Strength Training Classes
(159, 2, '2025-05-14', '07:00:00', '08:00:00', 'Studio B', 20, 'Wednesday'),
(160, 2, '2025-05-14', '17:30:00', '18:30:00', 'Studio B', 20, 'Wednesday'),
(161, 2, '2025-05-18', '08:30:00', '09:30:00', 'Studio B', 20, 'Sunday'),

-- Pilates Classes
(162, 3, '2025-05-13', '08:00:00', '09:00:00', 'Studio C', 18, 'Tuesday'),
(163, 3, '2025-05-15', '12:00:00', '13:00:00', 'Studio C', 18, 'Thursday'),

-- Weight Lifting Classes
(164, 4, '2025-05-16', '11:00:00', '12:00:00', 'Studio D', 15, 'Friday'),
(165, 4, '2025-05-18', '13:00:00', '14:00:00', 'Studio D', 15, 'Sunday'),

-- Aerobics Classes
(166, 5, '2025-05-12', '08:00:00', '09:00:00', 'Studio E', 30, 'Monday'),
(167, 5, '2025-05-17', '18:00:00', '19:00:00', 'Studio E', 30, 'Saturday'),

-- Kickboxing Classes
(168, 6, '2025-05-16', '06:30:00', '07:30:00', 'Studio F', 16, 'Friday'),
(169, 6, '2025-05-18', '19:00:00', '20:00:00', 'Studio F', 16, 'Sunday');

--
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE class_schedule;
SET FOREIGN_KEY_CHECKS = 1;

select * from class_schedule;
--
-- Yoga (ClassID: 1)
INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
VALUES 
(201, 1, '2025-04-21', '09:00:00', '10:00:00', 'Studio A', 25, 'Monday'),
(202, 1, '2025-04-21', '18:00:00', '19:00:00', 'Studio A', 25, 'Monday'),
(203, 1, '2025-04-23', '09:00:00', '10:00:00', 'Studio A', 25, 'Wednesday'),
(204, 1, '2025-04-23', '18:00:00', '19:00:00', 'Studio A', 25, 'Wednesday'),
(205, 1, '2025-04-25', '09:00:00', '10:00:00', 'Studio A', 25, 'Friday'),
(206, 1, '2025-04-25', '18:00:00', '19:00:00', 'Studio A', 25, 'Friday'),
(207, 1, '2025-04-27', '09:00:00', '10:00:00', 'Studio A', 25, 'Sunday'),
(208, 1, '2025-04-27', '18:00:00', '19:00:00', 'Studio A', 25, 'Sunday');

-- Strength Training (ClassID: 2)
INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
VALUES 
(301, 2, '2025-04-22', '12:00:00', '13:00:00', 'Studio B', 20, 'Tuesday'),
(302, 2, '2025-04-24', '12:00:00', '13:00:00', 'Studio B', 20, 'Thursday'),
(303, 2, '2025-04-26', '12:00:00', '13:00:00', 'Studio B', 20, 'Saturday');

-- Strength Training Evening Batches
INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
VALUES 
(304, 2, '2025-04-22', '18:00:00', '19:00:00', 'Studio B', 20, 'Tuesday'),
(305, 2, '2025-04-24', '18:00:00', '19:00:00', 'Studio B', 20, 'Thursday'),
(306, 2, '2025-04-26', '18:00:00', '19:00:00', 'Studio B', 20, 'Saturday');

-- Pilates (ClassID: 3)
INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
VALUES 
(401, 3, '2025-04-21', '11:00:00', '12:00:00', 'Studio C', 18, 'Monday'),
(402, 3, '2025-04-23', '11:00:00', '12:00:00', 'Studio C', 18, 'Wednesday'),
(403, 3, '2025-04-26', '11:00:00', '12:00:00', 'Studio C', 18, 'Saturday');

-- Pilates Evening Batches
INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
VALUES 
(404, 3, '2025-04-21', '17:00:00', '18:00:00', 'Studio C', 18, 'Monday'),
(405, 3, '2025-04-23', '17:00:00', '18:00:00', 'Studio C', 18, 'Wednesday'),
(406, 3, '2025-04-26', '17:00:00', '18:00:00', 'Studio C', 18, 'Saturday');

-- Weight Lifting (ClassID: 4)
INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
VALUES 
(501, 4, '2025-04-22', '13:00:00', '14:00:00', 'Studio D', 15, 'Tuesday'),
(502, 4, '2025-04-24', '13:00:00', '14:00:00', 'Studio D', 15, 'Thursday');

-- Weight Lifting Evening Batches
INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
VALUES 
(503, 4, '2025-04-22', '18:00:00', '19:00:00', 'Studio D', 15, 'Tuesday'),
(504, 4, '2025-04-24', '18:00:00', '19:00:00', 'Studio D', 15, 'Thursday');

-- Aerobics (ClassID: 5)
INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
VALUES 
(601, 5, '2025-04-21', '08:00:00', '09:00:00', 'Studio E', 30, 'Monday'),
(602, 5, '2025-04-22', '08:00:00', '09:00:00', 'Studio E', 30, 'Tuesday'),
(603, 5, '2025-04-23', '08:00:00', '09:00:00', 'Studio E', 30, 'Wednesday'),
(604, 5, '2025-04-24', '08:00:00', '09:00:00', 'Studio E', 30, 'Thursday'),
(605, 5, '2025-04-25', '08:00:00', '09:00:00', 'Studio E', 30, 'Friday');

-- Aerobics Evening Batches
INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
VALUES 
(606, 5, '2025-04-21', '17:30:00', '18:30:00', 'Studio E', 30, 'Monday'),
(607, 5, '2025-04-22', '17:30:00', '18:30:00', 'Studio E', 30, 'Tuesday'),
(608, 5, '2025-04-23', '17:30:00', '18:30:00', 'Studio E', 30, 'Wednesday'),
(609, 5, '2025-04-24', '17:30:00', '18:30:00', 'Studio E', 30, 'Thursday'),
(610, 5, '2025-04-25', '17:30:00', '18:30:00', 'Studio E', 30, 'Friday');

-- Kickboxing (ClassID: 6)
INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
VALUES 
(701, 6, '2025-04-23', '10:30:00', '11:30:00', 'Studio F', 16, 'Wednesday'),
(702, 6, '2025-04-25', '10:30:00', '11:30:00', 'Studio F', 16, 'Friday'),
(703, 6, '2025-04-27', '10:30:00', '11:30:00', 'Studio F', 16, 'Sunday');

-- Kickboxing Evening Batches
INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
VALUES 
(704, 6, '2025-04-23', '18:30:00', '19:30:00', 'Studio F', 16, 'Wednesday'),
(705, 6, '2025-04-25', '18:30:00', '19:30:00', 'Studio F', 16, 'Friday'),
(706, 6, '2025-04-27', '18:30:00', '19:30:00', 'Studio F', 16, 'Sunday');

INSERT INTO class_schedule (ScheduleID, class_id, ScheduleDate, StartTime, EndTime, Location, AvailableSeats, DayOfWeek)
SELECT
    ScheduleID + 1000,  -- Adjust for unique ScheduleID
    class_id,
    DATE_ADD(ScheduleDate, INTERVAL 7 DAY) AS NextWeekDate,  -- Repeat next week
    StartTime,
    EndTime,
    Location,
    AvailableSeats,
    DayOfWeek
FROM class_schedule
WHERE ScheduleDate >= '2025-04-21' AND ScheduleDate <= '2025-04-27';  -- Limit to this week's schedules


ALTER TABLE class_schedule
ADD COLUMN TrainerID INT NOT NULL,
ADD CONSTRAINT fk_class_schedule_trainer
FOREIGN KEY (`TrainerID`) REFERENCES `trainer`(`TrainerID`);

SELECT `TrainerID` FROM `trainer`;
select * from class_schedule;

SET FOREIGN_KEY_CHECKS = 0;

UPDATE `class_schedule`
SET `TrainerID` = 1 -- Lucy Taylor (Yoga)
WHERE `ScheduleID` IN (201, 202, 203, 204, 205, 206, 207, 208, 1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208);

UPDATE `class_schedule`
SET `TrainerID` = 2 -- Mia Clarke (Strength Training)
WHERE `ScheduleID` IN (301, 302, 303, 304, 305, 306, 1301, 1302, 1303, 1304, 1305, 1306);

UPDATE `class_schedule`
SET `TrainerID` = 3 -- Isabella White (Pilates)
WHERE `ScheduleID` IN (401, 402, 403, 404, 405, 406, 1401, 1402, 1403, 1404, 1405, 1406);

UPDATE `class_schedule`
SET `TrainerID` = 4 -- Ava Collins (Weight Lifting)
WHERE `ScheduleID` IN (503, 504, 1503, 1504);

UPDATE `class_schedule`
SET `TrainerID` = 5 -- Olivia Martin (Aerobics)
WHERE `ScheduleID` IN (606, 607, 608, 609, 610, 1606, 1607, 1608, 1609, 1610);

UPDATE `class_schedule`
SET `TrainerID` = 6 -- Sophia Lee (Kickboxing)
WHERE `ScheduleID` IN (704, 705, 706, 1704, 1705, 1706);

SET FOREIGN_KEY_CHECKS = 1;

select * from trainer;

--
-- Dumping data for table `class_schedule`
--

LOCK TABLES `class_schedule` WRITE;
/*!40000 ALTER TABLE `class_schedule` DISABLE KEYS */;
INSERT INTO `class_schedule` VALUES (101,1,'2025-04-20','09:00:00','10:00:00','Studio A',20),(102,1,'2025-04-22','09:00:00','10:00:00','Studio A',20),(103,1,'2025-04-24','18:00:00','19:00:00','Studio A',20),(104,2,'2025-04-20','10:30:00','11:30:00','Studio B',15),(105,2,'2025-04-22','10:30:00','11:30:00','Studio B',15),(106,2,'2025-04-25','17:00:00','18:00:00','Studio B',15),(107,3,'2025-04-21','08:00:00','09:00:00','Studio C',12),(108,3,'2025-04-23','08:00:00','09:00:00','Studio C',12),(109,4,'2025-04-20','12:00:00','13:00:00','Studio C',10),(110,4,'2025-04-24','12:00:00','13:00:00','Studio C',10),(111,5,'2025-04-22','17:00:00','18:00:00','Studio D',18),(112,5,'2025-04-26','10:00:00','11:00:00','Studio D',18),(113,6,'2025-04-23','19:00:00','20:00:00','Studio E',16),(114,6,'2025-04-25','19:00:00','20:00:00','Studio E',16),(115,1,'2025-04-26','10:00:00','11:00:00','Studio A',20),(116,1,'2025-04-27','14:00:00','15:00:00','Studio A',20),(117,2,'2025-04-26','12:00:00','13:00:00','Studio B',15),(118,2,'2025-04-27','16:00:00','17:00:00','Studio B',15),(119,1,'2025-04-27','09:00:00','10:00:00','Studio A',20),(120,1,'2025-04-29','09:00:00','10:00:00','Studio A',20),(121,1,'2025-05-01','18:00:00','19:00:00','Studio A',20),(122,2,'2025-04-27','10:30:00','11:30:00','Studio B',15),(123,2,'2025-04-29','10:30:00','11:30:00','Studio B',15),(124,2,'2025-05-02','17:00:00','18:00:00','Studio B',15),(125,3,'2025-04-30','08:00:00','09:00:00','Studio C',12),(126,3,'2025-05-02','08:00:00','09:00:00','Studio C',12),(127,4,'2025-04-30','12:00:00','13:00:00','Studio C',10),(128,4,'2025-05-01','12:00:00','13:00:00','Studio C',10),(129,5,'2025-04-29','17:00:00','18:00:00','Studio D',18),(130,5,'2025-05-03','10:00:00','11:00:00','Studio D',18),(131,6,'2025-04-30','19:00:00','20:00:00','Studio E',16),(132,6,'2025-05-02','19:00:00','20:00:00','Studio E',16),(133,1,'2025-05-03','10:00:00','11:00:00','Studio A',20),(134,1,'2025-05-04','14:00:00','15:00:00','Studio A',20),(135,2,'2025-05-03','12:00:00','13:00:00','Studio B',15),(136,2,'2025-05-04','16:00:00','17:00:00','Studio B',15),(137,1,'2025-05-04','09:00:00','10:00:00','Studio A',20),(138,1,'2025-05-06','09:00:00','10:00:00','Studio A',20),(139,1,'2025-05-08','18:00:00','19:00:00','Studio A',20),(140,2,'2025-05-04','10:30:00','11:30:00','Studio B',15),(141,2,'2025-05-06','10:30:00','11:30:00','Studio B',15),(142,2,'2025-05-09','17:00:00','18:00:00','Studio B',15),(143,3,'2025-05-05','08:00:00','09:00:00','Studio C',12),(144,3,'2025-05-07','08:00:00','09:00:00','Studio C',12),(145,4,'2025-05-05','12:00:00','13:00:00','Studio C',10),(146,4,'2025-05-08','12:00:00','13:00:00','Studio C',10),(147,5,'2025-05-06','17:00:00','18:00:00','Studio D',18),(148,5,'2025-05-10','10:00:00','11:00:00','Studio D',18),(149,6,'2025-05-07','19:00:00','20:00:00','Studio E',16),(150,6,'2025-05-09','19:00:00','20:00:00','Studio E',16),(151,1,'2025-05-10','10:00:00','11:00:00','Studio A',20),(152,1,'2025-05-11','14:00:00','15:00:00','Studio A',20),(153,2,'2025-05-10','12:00:00','13:00:00','Studio B',15),(154,2,'2025-05-11','16:00:00','17:00:00','Studio B',15);
/*!40000 ALTER TABLE `class_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classbooking`
--

DROP TABLE IF EXISTS `classbooking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classbooking` (
  `BookingID` int NOT NULL,
  `UserID` varchar(10) DEFAULT NULL,
  `ScheduleID` int DEFAULT NULL,
  `BookingDate` datetime DEFAULT NULL,
  `BookingStatus` enum('Booked','Cancelled','Attended') DEFAULT NULL,
  PRIMARY KEY (`BookingID`),
  KEY `UserID` (`UserID`),
  KEY `ScheduleID` (`ScheduleID`),
  CONSTRAINT `classbooking_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `gym_user` (`UserID`),
  CONSTRAINT `classbooking_ibfk_2` FOREIGN KEY (`ScheduleID`) REFERENCES `class_schedule` (`ScheduleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

ALTER TABLE gym_user
ADD COLUMN LastLogin DATETIME NULL;

SELECT * FROM classbooking;
SELECT * FROM classbooking WHERE UserID = 'GMUK1009';

SELECT * FROM classbooking WHERE ScheduleID = 102 AND UserID = 'GMUK1009';

SELECT AvailableSeats FROM class_schedule WHERE ScheduleID = 102;

ALTER TABLE classbooking
MODIFY COLUMN BookingID INT NOT NULL AUTO_INCREMENT;

ALTER TABLE payment DROP FOREIGN KEY payment_ibfk_1;

ALTER TABLE payment
ADD CONSTRAINT payment_ibfk_1
FOREIGN KEY (BookingID) REFERENCES classbooking (BookingID);

--
-- Dumping data for table `classbooking`
--

LOCK TABLES `classbooking` WRITE;
/*!40000 ALTER TABLE `classbooking` DISABLE KEYS */;
INSERT INTO `classbooking` VALUES (1,'GMUK1001',101,'2025-04-20 08:00:00','Booked'),(2,'GMUK1002',102,'2025-04-20 09:30:00','Booked'),(3,'GMUK1003',105,'2025-04-21 10:00:00','Cancelled'),(4,'GMUK1004',106,'2025-04-21 11:00:00','Booked');
/*!40000 ALTER TABLE `classbooking` ENABLE KEYS */;
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
  PRIMARY KEY (`class_id`),
  UNIQUE KEY `class_name` (`class_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_class`
--

LOCK TABLES `fitness_class` WRITE;
/*!40000 ALTER TABLE `fitness_class` DISABLE KEYS */;
INSERT INTO `fitness_class` VALUES (1,'Yoga','A peaceful yoga session to start your day. Relax and stretch your body with guided meditation and poses.',10.00,25),(2,'Strength Training','Build strength and endurance through full-body training with weights and resistance exercises.',12.00,20),(3,'Pilates','Improve flexibility and core strength with Pilates exercises that focus on posture and balance.',11.00,18),(4,'Weight Lifting','Introductory class focused on learning weight lifting techniques and proper form for strength training.',13.00,15),(5,'Aerobics','High-energy aerobic workout to improve cardiovascular health and stamina with a mix of dance moves and music.',8.00,30),(6,'Kickboxing','Fast-paced kickboxing workout that combines punches, kicks, and cardio exercises to build strength and endurance.',10.50,16);
/*!40000 ALTER TABLE `fitness_class` ENABLE KEYS */;
UNLOCK TABLES;

select * from fitness_class;

UPDATE fitness_class
SET image_url = 'yoga.webp'
WHERE class_name = 'Yoga';

UPDATE fitness_class
SET image_url = 'strength_training_new.jpeg'
WHERE class_name = 'Strength Training';

UPDATE fitness_class
SET image_url = 'pilate_new.jpeg'
WHERE class_name = 'Pilates';

UPDATE fitness_class
SET image_url = 'weight_lifting_new.jpeg'
WHERE class_name = 'Weight Lifting';

UPDATE fitness_class
SET image_url = 'aerobics_new.jpeg'
WHERE class_name = 'Aerobics';

UPDATE fitness_class
SET image_url = 'kick_boxing_new.png'
WHERE class_name = 'Kickboxing';

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

select * from membership;
--
-- Dumping data for table `membership`
--

LOCK TABLES `membership` WRITE;
/*!40000 ALTER TABLE `membership` DISABLE KEYS */;
INSERT INTO `membership` VALUES (201,'Monthly','Access to gym and 1 class per week',29.99,1),(202,'Quarterly','Full access + unlimited classes',79.99,3),(206,'Annual','Full access + unlimited classes + personal trainer sessions',249.99,12);
/*!40000 ALTER TABLE `membership` ENABLE KEYS */;
UNLOCK TABLES;
--
ALTER TABLE `membership`
ADD COLUMN `Benefits` TEXT; -- Add a column to describe the benefits of each membership plan.

SET SQL_SAFE_UPDATES = 1;

DELETE FROM membership;

UPDATE membership
SET MembershipType = 'Basic',
    Description = 'Limited access to gym facilities during off-peak hours and one group class per month',
    Price = 25.00,
    DurationMonths = 1,
    Benefits = 'Access to gym facilities during off-peak hours and one group class per month'
WHERE MembershipID = 201;

UPDATE membership
SET MembershipType = 'Gold',
    Description = 'Full access to gym facilities, unlimited group classes, and nutrition workshops',
    Price = 80.00,
    DurationMonths = 3,
    Benefits = 'Unlimited access to gym facilities, unlimited group classes, and nutrition workshops'
WHERE MembershipID = 202;

UPDATE membership
SET MembershipType = 'Platinum',
    Description = 'Full access to gym facilities, unlimited group classes, personal trainer sessions, exclusive nutrition and wellness programs, and priority customer support',
    Price = 120.00,
    DurationMonths = 6,
    Benefits = 'Unlimited access to gym facilities, unlimited classes, personal trainer sessions, nutrition and wellness programs, and priority customer support'
WHERE MembershipID = 206;

SET FOREIGN_KEY_CHECKS = 1;

select * from membership;

--
CREATE TABLE `day_pass` (
  `PassID` INT NOT NULL AUTO_INCREMENT,
  `UserID` VARCHAR(20) NOT NULL, -- Match the data type of gym_user.UserID
  `PurchaseDate` DATE NOT NULL,
  `PassStatus` ENUM('Active', 'Expired') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`PassID`),
  FOREIGN KEY (`UserID`) REFERENCES `gym_user`(`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from day_pass;

select * from payment;

SELECT UserID FROM day_pass;
select * from gym_user;
SHOW COLUMNS FROM payment;

ALTER TABLE payment
ADD COLUMN PaymentType VARCHAR(50) NOT NULL;

ALTER TABLE payment
ADD COLUMN UserID VARCHAR(20) NOT NULL;

ALTER TABLE payment
MODIFY COLUMN PaymentID INT NOT NULL AUTO_INCREMENT;

SELECT * FROM day_pass
WHERE UserID = 'GMUK1010' AND PurchaseDate = CURDATE() AND PassStatus = 'Active';



ALTER TABLE day_pass
MODIFY COLUMN UserID INT UNSIGNED NOT NULL;


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

DESCRIBE membership;

SELECT ms.SubscriptionID, m.MembershipType, ms.JoinDate, ms.ExpiryDate
FROM membership_subscription ms
JOIN membership m ON ms.MembershipID = m.MembershipID
WHERE ms.UserID = 'GMUK1001' AND ms.ExpiryDate > CURDATE();

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `PaymentID` int NOT NULL,
  `BookingID` int DEFAULT NULL,
  `PaymentDate` datetime DEFAULT NULL,
  `Amount` decimal(6,2) DEFAULT NULL,
  `Status` enum('Paid','Pending','Failed') DEFAULT NULL,
  PRIMARY KEY (`PaymentID`),
  KEY `BookingID` (`BookingID`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`BookingID`) REFERENCES `classbooking` (`BookingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

select * from payment;

select * from fitness_class;

SELECT 
    cs.ScheduleDate, 
    cs.DayOfWeek, 
    cs.Location, 
    cs.StartTime, 
    cs.EndTime, 
    cs.AvailableSeats, 
    cs.ScheduleID, 
    fc.Price
FROM class_schedule cs
JOIN fitness_class fc ON cs.class_id = fc.class_id
WHERE cs.class_id = 1
ORDER BY cs.ScheduleDate, cs.StartTime;



 -- Replace with valid ScheduleID

select * from class_schedule;
SELECT fc.Price
FROM fitness_class fc
JOIN class_schedule cs ON fc.class_id = cs.class_id
WHERE cs.ScheduleID = 610;

DESCRIBE payment;

ALTER TABLE payment ADD ScheduleID INT;

SHOW COLUMNS FROM class_schedule;
SHOW COLUMNS FROM fitness_class;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (501,1,'2025-04-20 08:05:00',12.00,'Paid'),(502,2,'2025-04-20 09:35:00',12.00,'Pending'),(503,3,'2025-04-21 10:05:00',13.50,'Failed'),(504,4,'2025-04-21 11:10:00',14.00,'Paid');
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


CREATE TABLE contact_us (
    ContactID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Message TEXT NOT NULL,
    SubmissionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from contact_us;

-- Dump completed on 2025-04-21 22:10:33
