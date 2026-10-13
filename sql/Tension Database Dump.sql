-- ============================================================================
-- Tension Climbing database: master schema + data.
-- ============================================================================

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- ============================================================================
-- 1. DROP EXISTING TABLES
-- ============================================================================

DROP TABLE IF EXISTS `wood_machine`;
DROP TABLE IF EXISTS `wood_finish`;
DROP TABLE IF EXISTS `saw`;
DROP TABLE IF EXISTS `prepack`;
DROP TABLE IF EXISTS `product_order`;
DROP TABLE IF EXISTS `employee_order`;
DROP TABLE IF EXISTS `soft_product`;
DROP TABLE IF EXISTS `wood_product`;
DROP TABLE IF EXISTS `gym`;
DROP TABLE IF EXISTS `machine`;
DROP TABLE IF EXISTS `finish`;
DROP TABLE IF EXISTS `order`;
DROP TABLE IF EXISTS `wood`;
DROP TABLE IF EXISTS `product`;
DROP TABLE IF EXISTS `employee`;
DROP TABLE IF EXISTS `customer`;

-- ============================================================================
-- 2. CREATE TABLES 
-- ============================================================================

CREATE TABLE `customer` (
  `customer_ID` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(35) NOT NULL,
  `last_name` varchar(25) DEFAULT NULL,
  `type` char(1) NOT NULL CHECK (`type` = 'G' or `type` = 'C'),
  `city` varchar(25) NOT NULL,
  `state` varchar(2) NOT NULL DEFAULT 'CO',
  `street` varchar(35) NOT NULL,
  `zip` varchar(5) NOT NULL,
  PRIMARY KEY (`customer_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `employee` (
  `employee_ID` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `specialty` varchar(15) NOT NULL,
  `email` varchar(35) NOT NULL,
  `phone` varchar(12) NOT NULL,
  `city` varchar(15) NOT NULL,
  `state` char(2) NOT NULL DEFAULT 'CO',
  `street` varchar(25) NOT NULL,
  `zip` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`employee_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `product` (
  `product_ID` int(11) NOT NULL AUTO_INCREMENT,
  `qty_on_hand` int(11) NOT NULL DEFAULT 0,
  `retail_cost` decimal(7,2) NOT NULL DEFAULT 0.00,
  `name` varchar(25) NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `wood` (
  `wood_ID` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) NOT NULL,
  `batch_number` varchar(8) NOT NULL,
  `stage` char(1) NOT NULL,
  PRIMARY KEY (`wood_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `order` (
  `order_ID` int(11) NOT NULL AUTO_INCREMENT,
  `order_date` date NOT NULL,
  `tracking_number` varchar(22) NOT NULL,
  `fulfillment_date` date DEFAULT NULL,
  `customer_ID` int(11) NOT NULL,
  PRIMARY KEY (`order_ID`),
  KEY `customer_ID` (`customer_ID`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`customer_ID`) REFERENCES `customer` (`customer_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `finish` (
  `finish_ID` int(11) NOT NULL AUTO_INCREMENT,
  `EOD_amount` int(11) NOT NULL,
  `EOD_trash` int(11) NOT NULL,
  `employee_ID` int(11) NOT NULL,
  PRIMARY KEY (`finish_ID`),
  KEY `employee_ID` (`employee_ID`),
  CONSTRAINT `finish_ibfk_1` FOREIGN KEY (`employee_ID`) REFERENCES `employee` (`employee_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `machine` (
  `machine_ID` int(11) NOT NULL AUTO_INCREMENT,
  `employee_ID` int(11) NOT NULL,
  PRIMARY KEY (`machine_ID`),
  KEY `employee_ID` (`employee_ID`),
  CONSTRAINT `machine_ibfk_1` FOREIGN KEY (`employee_ID`) REFERENCES `employee` (`employee_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `gym` (
  `customer_ID` int(11) NOT NULL,
  `name` varchar(25) NOT NULL DEFAULT 'Movement',
  `bulk_discount` decimal(4,3) NOT NULL,
  PRIMARY KEY (`customer_ID`),
  CONSTRAINT `gym_ibfk_1` FOREIGN KEY (`customer_ID`) REFERENCES `customer` (`customer_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `wood_product` (
  `product_ID` int(11) NOT NULL,
  `target_market` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product_ID`),
  CONSTRAINT `wood_product_ibfk_1` FOREIGN KEY (`product_ID`) REFERENCES `product` (`product_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `soft_product` (
  `product_ID` int(11) NOT NULL,
  `buying_cost` decimal(7,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`product_ID`),
  CONSTRAINT `soft_product_ibfk_1` FOREIGN KEY (`product_ID`) REFERENCES `product` (`product_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `employee_order` (
  `order_ID` int(11) NOT NULL,
  `employee_ID` int(11) NOT NULL,
  `discount` decimal(4,3) NOT NULL,
  PRIMARY KEY (`order_ID`,`employee_ID`),
  KEY `employee_ID` (`employee_ID`),
  CONSTRAINT `employee_order_ibfk_1` FOREIGN KEY (`order_ID`) REFERENCES `order` (`order_ID`),
  CONSTRAINT `employee_order_ibfk_2` FOREIGN KEY (`employee_ID`) REFERENCES `employee` (`employee_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `product_order` (
  `product_ID` int(11) NOT NULL,
  `order_ID` int(11) NOT NULL,
  `amount_sold` int(11) DEFAULT 0,
  PRIMARY KEY (`product_ID`,`order_ID`),
  KEY `order_ID` (`order_ID`),
  CONSTRAINT `product_order_ibfk_1` FOREIGN KEY (`product_ID`) REFERENCES `product` (`product_ID`),
  CONSTRAINT `product_order_ibfk_2` FOREIGN KEY (`order_ID`) REFERENCES `order` (`order_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `prepack` (
  `product_ID` int(11) NOT NULL,
  `wood_ID` int(11) NOT NULL,
  `prepack_amount` int(11) NOT NULL,
  `date_finished` date NOT NULL,
  PRIMARY KEY (`product_ID`,`wood_ID`),
  KEY `wood_ID` (`wood_ID`),
  CONSTRAINT `prepack_ibfk_1` FOREIGN KEY (`product_ID`) REFERENCES `wood_product` (`product_ID`),
  CONSTRAINT `prepack_ibfk_2` FOREIGN KEY (`wood_ID`) REFERENCES `wood` (`wood_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `saw` (
  `saw_ID` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `size` varchar(5) NOT NULL,
  `EOD_trash` int(11) NOT NULL,
  `EOD_amount_cut` int(11) NOT NULL,
  `employee_ID` int(11) NOT NULL,
  `wood_ID` int(11) NOT NULL,
  PRIMARY KEY (`saw_ID`),
  KEY `employee_ID` (`employee_ID`),
  KEY `wood_ID` (`wood_ID`),
  CONSTRAINT `saw_ibfk_1` FOREIGN KEY (`employee_ID`) REFERENCES `employee` (`employee_ID`),
  CONSTRAINT `saw_ibfk_2` FOREIGN KEY (`wood_ID`) REFERENCES `wood` (`wood_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `wood_finish` (
  `finish_ID` int(11) NOT NULL,
  `wood_ID` int(11) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`finish_ID`,`wood_ID`),
  KEY `wood_ID` (`wood_ID`),
  CONSTRAINT `wood_finish_ibfk_1` FOREIGN KEY (`finish_ID`) REFERENCES `finish` (`finish_ID`),
  CONSTRAINT `wood_finish_ibfk_2` FOREIGN KEY (`wood_ID`) REFERENCES `wood` (`wood_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `wood_machine` (
  `machine_ID` int(11) NOT NULL,
  `wood_ID` int(11) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time DEFAULT NULL,
  `machine_condition` varchar(4) NOT NULL,
  `EOD_amount` int(11) NOT NULL,
  `EOD_trash` int(11) NOT NULL,
  PRIMARY KEY (`machine_ID`,`wood_ID`),
  KEY `wood_ID` (`wood_ID`),
  CONSTRAINT `wood_machine_ibfk_1` FOREIGN KEY (`machine_ID`) REFERENCES `machine` (`machine_ID`),
  CONSTRAINT `wood_machine_ibfk_2` FOREIGN KEY (`wood_ID`) REFERENCES `wood` (`wood_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================================
-- 3. LOAD DATA
-- ============================================================================

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Jimmy','Webb','C','Denver','CO','659 Democrat Lane','80202'),(2,'Alex ','Megos','C','Fort Collins','CO','6523 Willow Creek Ave','80521'),(3,'Daniel ','Woods','C','Boulder','CO','43 Main Street','80301'),(4,'Anabelle','Spingler','C','Colorado Springs','CO','1312 El Paso Road','80903'),(5,'Colin','Duffy','C','Boulder','CO','4563 Beyonce Way','80301'),(6,'Akiyo','Noguchi','C','Atlanta','GA','72 Catfish Road','30303'),(7,'Tomoa','Narasaki','C','San Francisco','CA','174 Hillside Ave','94102'),(8,'Mejdi','Schalck','C','Arvada','CO','1943 North 85th Place','80002'),(9,'Denver','Heinz','C','Colorado Springs','CO','4621 Briargate Parkway','80903'),(10,'Alta Boulders','','G','Chandler','AZ','7892 Lando Ave','85224'),(11,'Noah','Wheeler','C','Denver','CO','3291 Colfax Ave','80202'),(12,'Shauna','Coxsey','C','Salt Lake City','UT','6462 Adsit Road','84101'),(13,'Benn','Wheeler','C','Portland','OR','9772 Oceanside Bay Road','97201'),(14,'Spring Climbing Center','','G','Colorado Springs','CO','4642 Northpark Drive','80903'),(15,'Yannick','Flohe','C','Sacremento','CA','443 Germany Way','95814'),(16,'Erin','McNiece','C','New York City','NY','1264th Street','10001'),(17,'Chloe','Anderson','C','Arvada','CO','246 Elm Street','80003'),(18,'Henry','Martinez','C','Thornton','CO','147 Sycamore Avenue','80229'),(19,'Miles','Miller','C','Thornton','CO','258 Hickory Street','80229'),(20,'Asher','Rodriguez','C','Denver','CO','987 Birch Boulevard','80202'),(21,'Owen','Garcia','C','Thornton','CO','741 Aspen Place','80229'),(22,'Caleb','Brown','C','Arvada','CO','246 Elm Street','80003');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'Liam','Smith','M','Liam@tensionclimbing.com','202-555-0187','Arvada','CO','135 Walnut Drive','80003'),(2,'Ethan','Johnson','M','Ethan@tensionclimbing.com','303-555-0142','Arvada','CO','864 Spruce Terrace','80003'),(3,'Noah','Williams','FR','Noah@tensionclimbing.com','415-555-0198','Denver','CO','654 Cedar Court','80202'),(4,'Caleb','Brown','FR','Caleb@tensionclimbing.com','212-555-0173','Arvada','CO','246 Elm Street','80003'),(5,'Lucas','Jones','F','Lucas@tensionclimbing.com','718-555-0165','Arvada','CO','579 Chestnut Way','80003'),(6,'Owen','Garcia','F','Owen@tensionclimbing.com','305-555-0111','Thornton','CO','741 Aspen Place','80229'),(7,'Miles','Miller','S','Miles@tensionclimbing.com','510-555-0139','Thornton','CO','258 Hickory Street','80229'),(8,'Jack','Davis','M','Jack@tensionclimbing.com','617-555-0128','Denver','CO','123 Bleak Street','80202'),(9,'Asher','Rodriguez','F','Asher@tensionclimbing.com','503-555-0154','Denver','CO','987 Birch Boulevard','80202'),(10,'Henry','Martinez','M','Henry@tensionclimbing.com','702-555-0183','Thornton','CO','147 Sycamore Avenue','80229'),(11,'Logan','Hernandez','FR','Logan@tensionclimbing.com','808-555-0106','Denver','CO','789 Oak Lane','80202'),(12,'Mason','Lopez','FR','Mason@tensionclimbing.com','404-555-0192','Denver','CO','321 Pine Road','80202'),(13,'James','Gonzalez','FR','James@tensionclimbing.com','214-555-0179','Denver','CO','456 Maple Avenue','80202'),(14,'Ava','Wilson','FR','Ava@tensionclimbing.com','512-555-0147','Arvada','CO','312 Willow Circle','80003'),(15,'Chloe','Anderson','FR','Chloe@tensionclimbing.com','786-555-0133','Thornton','CO','963 Poplar Lane','80229');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,49,170.90,'Whetstone','Versatile hangboard designed to support beginner climbers train'),(2,56,170.90,'Grindstone','Hangboard for intermediate climbers looking to begin harder training'),(3,76,170.90,'Honestone','An advanced hangboard meant to push higher level climbers to their limit'),(4,32,94.80,'Flashboard','Portable hangboard for at the crag warmup or traveling'),(5,5,10048.00,'TB2 12x8','Flagship training board for those with smaller space'),(6,3,15152.00,'TB2 12x12','Flagship training board for those with larger space'),(7,14,56.70,'Block','Portable training tool for warmup, workout, rehab and much more'),(8,43,120.00,'Aux Pack','Backpack desgined to enhance the bouldering experience'),(9,58,79.00,'Aux Bucket','Heavy duty chalk bucket offering the perfect balance of simplicity, durability, and functionality'),(10,41,22.00,'Shoe spray','Natural Combination of cleaning, conditioning, and drying agents design to keep climbing shoes fresh'),(11,56,17.60,'Tension Tape','High performace tape desgined to keep you sending'),(12,32,34.99,'Skin Trimmer','A premium tool for skin maintenance'),(13,32,38.99,'Skin Clipper','A premium tool for skin and nail maintenance'),(14,5,45.00,'Roots Tee','T-shirt'),(15,0,95.00,'Roots Hoodie','Hoodie'),(16,2,45.00,'Saw Tee','T-shirt'),(17,1,45.00,'Fan Tee','T-Shirt');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `wood` WRITE;
/*!40000 ALTER TABLE `wood` DISABLE KEYS */;
INSERT INTO `wood` VALUES (1,'Hold','KFC-011','S'),(2,'Hold','CBL-102','S'),(3,'Hangboard','WST-012','D'),(4,'Hold','SHLM-023','M'),(5,'Hangboard','HST-054','M'),(6,'Hold','SHL-132','F'),(7,'Hold','BHL-034','F'),(8,'Flashboard','FLSH-005','S'),(9,'Hold','KFC-013','M'),(10,'Block','BLK-103','F'),(11,'Hold','MFB-004','S'),(12,'Hold','FB-009','S'),(13,'Hangboard','WST-013','M'),(14,'Hold','DHL-104','M'),(15,'Block','BLK-125','F'),(16,'Hold','UHL-010','M'),(17,'Hold','HGL-003','S'),(18,'Hangboard','GST-017','D'),(19,'Hold','UCM-042','M'),(20,'Hold','DEP-034','M'),(21,'Hangboard','GST-098','F'),(22,'Hold','CGP-032','M'),(23,'Hold','CGB-002','D'),(24,'Hold','DHL-093','M'),(25,'Hold','SHL-019','D'),(26,'Hold','FB-010','M'),(27,'Hold','MFB-006','S'),(28,'Hangboard','WST-098','M'),(29,'Hold','CBL-034','F'),(30,'Hold','WGL-053','M'),(31,'Flashboard','FLSH-006','F'),(32,'Block','BLK-056','D'),(33,'Hold','CGP-076','D'),(34,'Hold','KFC-034','M'),(35,'Hangboard','GST-067','M');
/*!40000 ALTER TABLE `wood` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (1,'2025-09-04','132568',NULL,1),(2,'2025-09-19','105634','2025-10-14',2),(3,'2025-10-02','792841','2025-10-25',3),(4,'2025-10-28','360519','2025-11-20',4),(5,'2025-11-11','918274','2025-11-29',2),(6,'2025-11-23','795462',NULL,10),(7,'2025-12-05','536102','2025-12-24',7),(8,'2025-12-17','684395','2026-01-04',2),(9,'2025-09-15','135795',NULL,9),(10,'2025-10-10','159736','2025-10-31',14),(11,'2025-11-07','470382','2025-12-01',11),(12,'2025-12-22','652314',NULL,12),(13,'2025-09-27','328496','2025-10-18',9),(14,'2025-10-18','754210','2025-11-12',2),(15,'2025-11-30','891063','2025-12-23',5),(16,'2025-10-15','236548','2025-10-30',17),(17,'2025-09-08','325488','2025-09-28',18),(18,'2025-05-06','245684','2025-06-02',19),(19,'2025-08-17','178962','2025-09-01',20),(20,'2025-03-02','326578','2025-03-15',21),(21,'2025-11-09','574256','2025-11-15',22);
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `finish` WRITE;
/*!40000 ALTER TABLE `finish` DISABLE KEYS */;
-- Sample data: finish sessions run by finish-specialty employees (5, 6, 9).
INSERT INTO `finish` VALUES (1,210,12,5),(2,185,9,6),(3,240,15,9),(4,160,7,5),(5,205,11,6),(6,190,8,9);
/*!40000 ALTER TABLE `finish` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `machine` WRITE;
/*!40000 ALTER TABLE `machine` DISABLE KEYS */;
INSERT INTO `machine` VALUES (1,1),(2,2),(3,8),(4,10);
/*!40000 ALTER TABLE `machine` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `gym` WRITE;
/*!40000 ALTER TABLE `gym` DISABLE KEYS */;
INSERT INTO `gym` VALUES (14,'Spring Climbing Center',0.200),(10,'Alta Boulders',0.200);
/*!40000 ALTER TABLE `gym` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `wood_product` WRITE;
/*!40000 ALTER TABLE `wood_product` DISABLE KEYS */;
INSERT INTO `wood_product` VALUES (2,'All Climbers'),(3,'Advanced Climbers'),(4,'Outdoor Climbers'),(5,'Homewall owners'),(6,'Gyms and facilties'),(7,'Outdoor Climbers'),(1,'Beginner Climbers');
/*!40000 ALTER TABLE `wood_product` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `soft_product` WRITE;
/*!40000 ALTER TABLE `soft_product` DISABLE KEYS */;
INSERT INTO `soft_product` VALUES (9,39.50),(10,11.00),(11,8.80),(12,17.50),(13,19.50),(14,22.50),(15,47.50),(16,22.50),(17,22.50);
/*!40000 ALTER TABLE `soft_product` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `employee_order` WRITE;
/*!40000 ALTER TABLE `employee_order` DISABLE KEYS */;
INSERT INTO `employee_order` VALUES (17,10,0.250),(18,7,0.250),(19,9,0.250),(20,6,0.250),(21,4,0.250),(16,15,0.250);
/*!40000 ALTER TABLE `employee_order` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `product_order` WRITE;
/*!40000 ALTER TABLE `product_order` DISABLE KEYS */;
INSERT INTO `product_order` VALUES (4,2,7),(3,3,8),(11,4,1),(3,5,8),(6,6,4),(11,7,6),(7,8,8),(4,9,2),(6,10,1),(8,11,10),(17,12,6),(2,13,10),(13,14,2),(10,15,3),(1,6,7),(2,6,6),(3,10,7),(1,10,5),(4,1,10),(1,16,2),(7,17,1),(4,18,2),(2,19,1),(10,20,2),(11,21,1);
/*!40000 ALTER TABLE `product_order` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `prepack` WRITE;
/*!40000 ALTER TABLE `prepack` DISABLE KEYS */;
INSERT INTO `prepack` VALUES (7,10,45,'2025-12-01'),(2,18,72,'2025-12-04'),(4,31,65,'2025-12-03'),(7,32,40,'2025-12-02'),(1,3,50,'2025-11-30');
/*!40000 ALTER TABLE `prepack` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `saw` WRITE;
/*!40000 ALTER TABLE `saw` DISABLE KEYS */;
-- Sample data: one saw run per batch that appears in wood_machine, dated the day before its first machine run (saw operator = employee 7).
INSERT INTO `saw` VALUES (1,'2025-11-30','2x4',8,92,7,4),(2,'2025-11-30','4x4',5,95,7,5),(3,'2025-11-30','2x6',9,114,7,9),(4,'2025-11-30','4x4',5,129,7,13),(5,'2025-12-01','2x4',10,78,7,14),(6,'2025-12-01','2x4',4,93,7,16),(7,'2025-12-01','2x6',11,147,7,19),(8,'2025-12-01','2x4',8,117,7,20),(9,'2025-12-02','2x4',10,76,7,22),(10,'2025-12-02','2x4',4,68,7,24),(11,'2025-12-02','2x4',6,110,7,26),(12,'2025-12-02','4x4',8,118,7,28),(13,'2025-12-03','2x4',10,83,7,30),(14,'2025-12-03','2x4',6,115,7,34),(15,'2025-12-03','4x4',11,128,7,35);
/*!40000 ALTER TABLE `saw` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `wood_finish` WRITE;
/*!40000 ALTER TABLE `wood_finish` DISABLE KEYS */;
-- Sample data: finish dates line up with prepack.date_finished for batches 3, 10, 18, 31, 32.
INSERT INTO `wood_finish` VALUES (1,3,'2025-11-30'),(1,23,'2025-11-30'),(2,25,'2025-11-28'),(2,33,'2025-11-29'),(3,10,'2025-12-01'),(3,32,'2025-12-02'),(4,31,'2025-12-03'),(4,6,'2025-12-03'),(5,18,'2025-12-04'),(5,7,'2025-12-04'),(6,15,'2025-12-04'),(6,21,'2025-12-04'),(6,29,'2025-12-04');
/*!40000 ALTER TABLE `wood_finish` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `wood_machine` WRITE;
/*!40000 ALTER TABLE `wood_machine` DISABLE KEYS */;
INSERT INTO `wood_machine` VALUES (1,4,'2025-12-01','07:14:22','16:42:11','Up',75,6),(1,14,'2025-12-02','07:41:29','12:33:48','Down',15,5),(1,22,'2025-12-03','06:59:37','16:46:58','Up',62,9),(1,30,'2025-12-04','07:36:01','16:16:05','Up',71,6),(2,5,'2025-12-01','06:32:41','16:08:57','Up',79,9),(2,14,'2025-12-03','16:30:24','23:21:30','Up',40,3),(2,16,'2025-12-02','07:03:55','16:27:15','Up',78,8),(2,24,'2025-12-03','06:11:58','16:12:36','Up',54,6),(2,34,'2025-12-04','06:53:49','16:38:27','Up',88,15),(3,9,'2025-12-01','07:56:08','16:55:23','Up',89,12),(3,19,'2025-12-02','06:48:02','16:51:39','Up',127,14),(3,20,'2025-12-03','17:20:19','23:45:25','Up',79,4),(3,26,'2025-12-03','07:50:16','16:59:01','Up',90,9),(3,35,'2025-12-04','07:09:20','16:30:52','Up',108,12),(4,13,'2025-12-01','06:05:13','16:19:04','Up',116,5),(4,20,'2025-12-02','07:27:44','10:04:22','Down',20,1),(4,28,'2025-12-03','06:24:33','16:23:49','Up',96,8);
/*!40000 ALTER TABLE `wood_machine` ENABLE KEYS */;
UNLOCK TABLES;

-- ============================================================================
-- 4. RESTORE SESSION SETTINGS
-- ============================================================================

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


