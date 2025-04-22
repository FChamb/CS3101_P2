/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.5.27-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: anon_P2
-- ------------------------------------------------------
-- Server version	10.5.27-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `coach`
--

DROP TABLE IF EXISTS `coach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coach` (
  `uid` char(6) NOT NULL,
  `lid` char(1) NOT NULL CHECK (cast(`lid` as char charset binary) = ucase(`lid`)),
  PRIMARY KEY (`uid`,`lid`),
  CONSTRAINT `coach_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `train` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach`
--

LOCK TABLES `coach` WRITE;
/*!40000 ALTER TABLE `coach` DISABLE KEYS */;
INSERT INTO `coach` VALUES ('158704','A'),('158704','B'),('170394','A'),('170394','B'),('170394','C'),('170406','A'),('170406','B'),('170406','C'),('390124','A'),('390124','B'),('390124','C'),('390124','D'),('390124','E'),('390124','F'),('390124','G'),('390124','H'),('390124','J'),('390124','K'),('390124','U');
/*!40000 ALTER TABLE `coach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location` (
  `loc` varchar(30) NOT NULL,
  PRIMARY KEY (`loc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES ('Aberdour'),('Burntisland'),('Cameron Bridge'),('Cupar'),('Dalgety Bay'),('Dalmeny'),('Dalmeny D.P.L.'),('Dalmeny Jn'),('Dalmeny U.P.L.'),('Dundee'),('Dundee Central Jn'),('Earlseat Junction'),('Edinburgh'),('Edinburgh Gateway'),('Haymarket'),('Haymarket Central Jn'),('Haymarket West Jn'),('Inverkeithing'),('Inverkeithing East Jn'),('Inverkeithing South Jn'),('Inverkeithing U.P.L.'),('Kinghorn'),('Kirkcaldy'),('Ladybank'),('Leuchars'),('Leven'),('Markinch'),('North Queensferry'),('Princes St Gardens'),('South Gyle'),('Springfield'),('St. Fort Signal Ts26'),('Tay Bridge South'),('Thornton North Jn'),('Thornton South Jn');
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plan`
--

DROP TABLE IF EXISTS `plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plan` (
  `hc` char(4) NOT NULL,
  `frm` varchar(30) NOT NULL,
  `loc` varchar(30) NOT NULL,
  `ddh` int(2) unsigned zerofill DEFAULT NULL CHECK (`ddh` <= 24),
  `ddm` int(2) unsigned zerofill DEFAULT NULL CHECK (`ddm` <= 60),
  PRIMARY KEY (`hc`,`frm`),
  KEY `frm` (`frm`),
  KEY `loc` (`loc`),
  CONSTRAINT `plan_ibfk_1` FOREIGN KEY (`hc`) REFERENCES `route` (`hc`),
  CONSTRAINT `plan_ibfk_2` FOREIGN KEY (`frm`) REFERENCES `location` (`loc`),
  CONSTRAINT `plan_ibfk_3` FOREIGN KEY (`loc`) REFERENCES `location` (`loc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plan`
--

LOCK TABLES `plan` WRITE;
/*!40000 ALTER TABLE `plan` DISABLE KEYS */;
INSERT INTO `plan` VALUES ('1L27','Aberdour','Burntisland',00,04),('1L27','Burntisland','Kinghorn',00,05),('1L27','Cupar','Leuchars',00,07),('1L27','Dalgety Bay','Aberdour',00,05),('1L27','Dalmeny','North Queensferry',00,04),('1L27','Dalmeny D.P.L.','Dalmeny',00,01),('1L27','Dalmeny Jn','Dalmeny D.P.L.',00,01),('1L27','Dundee Central Jn','Dundee',NULL,NULL),('1L27','Edinburgh','Princes St Gardens',00,02),('1L27','Edinburgh Gateway','Dalmeny Jn',00,04),('1L27','Haymarket','Haymarket Central Jn',00,01),('1L27','Haymarket Central Jn','Haymarket West Jn',00,01),('1L27','Haymarket West Jn','South Gyle',00,02),('1L27','Inverkeithing','Inverkeithing East Jn',00,01),('1L27','Inverkeithing East Jn','Dalgety Bay',00,02),('1L27','Inverkeithing South Jn','Inverkeithing',00,02),('1L27','Kinghorn','Kirkcaldy',00,05),('1L27','Kirkcaldy','Thornton South Jn',00,05),('1L27','Ladybank','Springfield',00,04),('1L27','Leuchars','Tay Bridge South',00,07),('1L27','Markinch','Ladybank',00,08),('1L27','North Queensferry','Inverkeithing South Jn',00,02),('1L27','Princes St Gardens','Haymarket',00,03),('1L27','South Gyle','Edinburgh Gateway',00,02),('1L27','Springfield','Cupar',00,04),('1L27','Tay Bridge South','Dundee Central Jn',00,06),('1L27','Thornton North Jn','Markinch',00,04),('1L27','Thornton South Jn','Thornton North Jn',00,02),('1L32','Aberdour','Dalgety Bay',00,03),('1L32','Burntisland','Aberdour',00,04),('1L32','Cupar','Springfield',00,03),('1L32','Dalgety Bay','Inverkeithing East Jn',00,01),('1L32','Dalmeny','Dalmeny U.P.L.',00,01),('1L32','Dalmeny Jn','Edinburgh Gateway',00,04),('1L32','Dalmeny U.P.L.','Dalmeny Jn',00,01),('1L32','Dundee','Dundee Central Jn',00,01),('1L32','Dundee Central Jn','Tay Bridge South',00,05),('1L32','Edinburgh Gateway','South Gyle',00,02),('1L32','Haymarket','Princes St Gardens',00,02),('1L32','Haymarket Central Jn','Haymarket',00,02),('1L32','Haymarket West Jn','Haymarket Central Jn',00,01),('1L32','Inverkeithing','Inverkeithing South Jn',00,01),('1L32','Inverkeithing East Jn','Inverkeithing U.P.L.',00,01),('1L32','Inverkeithing South Jn','North Queensferry',00,03),('1L32','Inverkeithing U.P.L.','Inverkeithing',00,01),('1L32','Kinghorn','Burntisland',00,03),('1L32','Kirkcaldy','Kinghorn',00,04),('1L32','Ladybank','Markinch',00,08),('1L32','Leuchars','Cupar',00,08),('1L32','Markinch','Thornton North Jn',00,03),('1L32','North Queensferry','Dalmeny',00,03),('1L32','Princes St Gardens','Edinburgh',NULL,NULL),('1L32','South Gyle','Haymarket West Jn',00,03),('1L32','Springfield','Ladybank',00,04),('1L32','St. Fort Signal Ts26','Leuchars',00,04),('1L32','Tay Bridge South','St. Fort Signal Ts26',00,03),('1L32','Thornton North Jn','Thornton South Jn',00,01),('1L32','Thornton South Jn','Kirkcaldy',00,06),('2K69','Aberdour','Burntisland',00,04),('2K69','Burntisland','Kinghorn',00,05),('2K69','Cameron Bridge','Leven',NULL,NULL),('2K69','Dalgety Bay','Aberdour',00,05),('2K69','Dalmeny','North Queensferry',00,04),('2K69','Dalmeny D.P.L.','Dalmeny',00,01),('2K69','Dalmeny Jn','Dalmeny D.P.L.',00,01),('2K69','Earlseat Junction','Cameron Bridge',00,06),('2K69','Edinburgh','Princes St Gardens',00,02),('2K69','Edinburgh Gateway','Dalmeny Jn',00,04),('2K69','Haymarket','Haymarket Central Jn',00,01),('2K69','Haymarket Central Jn','Haymarket West Jn',00,01),('2K69','Haymarket West Jn','South Gyle',00,02),('2K69','Inverkeithing','Inverkeithing East Jn',00,01),('2K69','Inverkeithing East Jn','Dalgety Bay',00,02),('2K69','Inverkeithing South Jn','Inverkeithing',00,02),('2K69','Kinghorn','Kirkcaldy',00,05),('2K69','Kirkcaldy','Thornton South Jn',00,05),('2K69','North Queensferry','Inverkeithing South Jn',00,02),('2K69','Princes St Gardens','Haymarket',00,03),('2K69','South Gyle','Edinburgh Gateway',00,02),('2K69','Thornton North Jn','Earlseat Junction',00,01),('2K69','Thornton South Jn','Thornton North Jn',00,02);
/*!40000 ALTER TABLE `plan` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`anon`@`%`*/ /*!50003 TRIGGER trg_finite_departure_differentials
BEFORE INSERT ON plan
FOR EACH ROW
BEGIN
  DECLARE next_loc_exists INT;

  SELECT COUNT(*) INTO next_loc_exists
  FROM plan
  WHERE frm = NEW.loc AND hc = NEW.hc;

  IF next_loc_exists > 0 AND (NEW.ddh = 99 OR NEW.ddm = 99) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Non-terminal locations must have finite departure differentials.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `route`
--

DROP TABLE IF EXISTS `route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `route` (
  `hc` char(4) NOT NULL CHECK (`hc` regexp '[0-9][A-Z][0-99]'),
  `orig` char(30) NOT NULL,
  PRIMARY KEY (`hc`,`orig`),
  KEY `orig` (`orig`),
  CONSTRAINT `route_ibfk_1` FOREIGN KEY (`orig`) REFERENCES `location` (`loc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route`
--

LOCK TABLES `route` WRITE;
/*!40000 ALTER TABLE `route` DISABLE KEYS */;
INSERT INTO `route` VALUES ('1L27','Edinburgh'),('1L32','Dundee'),('2K69','Edinburgh');
/*!40000 ALTER TABLE `route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `scheduleEDB`
--

DROP TABLE IF EXISTS `scheduleEDB`;
/*!50001 DROP VIEW IF EXISTS `scheduleEDB`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `scheduleEDB` AS SELECT
 1 AS `hc`,
  1 AS `dep`,
  1 AS `pl`,
  1 AS `dest`,
  1 AS `len`,
  1 AS `toc` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `hc` char(4) NOT NULL,
  `dh` int(2) unsigned zerofill NOT NULL CHECK (`dh` <= 24),
  `dm` int(2) unsigned zerofill NOT NULL CHECK (`dm` <= 60),
  `pl` int(10) unsigned NOT NULL,
  `uid` char(6) NOT NULL,
  `toc` char(2) NOT NULL CHECK (cast(`toc` as char charset binary) = ucase(`toc`) and (`toc` = 'VT' or `toc` = 'CS' or `toc` = 'XC' or `toc` = 'SR' or `toc` = 'GR' or `toc` = 'GW')),
  PRIMARY KEY (`hc`,`dh`,`dm`),
  UNIQUE KEY `unique_train_schedule` (`uid`,`dh`,`dm`),
  CONSTRAINT `service_ibfk_1` FOREIGN KEY (`hc`) REFERENCES `route` (`hc`),
  CONSTRAINT `service_ibfk_2` FOREIGN KEY (`uid`) REFERENCES `train` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES ('1L27',09,01,19,'170394','SR'),('1L27',18,59,20,'158704','SR'),('1L32',20,44,3,'158704','SR'),('2K69',15,03,16,'170406','SR');
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `serviceEDBDEE`
--

DROP TABLE IF EXISTS `serviceEDBDEE`;
/*!50001 DROP VIEW IF EXISTS `serviceEDBDEE`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `serviceEDBDEE` AS SELECT
 1 AS `loc`,
  1 AS `stn`,
  1 AS `pl`,
  1 AS `arr`,
  1 AS `dep` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `station` (
  `loc` varchar(30) NOT NULL,
  `code` char(3) NOT NULL CHECK (cast(`code` as char charset binary) = ucase(`code`)),
  PRIMARY KEY (`loc`),
  UNIQUE KEY `code` (`code`),
  CONSTRAINT `station_ibfk_1` FOREIGN KEY (`loc`) REFERENCES `location` (`loc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES ('Aberdour','AUR'),('Burntisland','BTS'),('Cameron Bridge','CBX'),('Cupar','CUP'),('Dalgety Bay','DAG'),('Dalmeny','DAM'),('Dundee','DEE'),('Edinburgh','EDB'),('Edinburgh Gateway','EGY'),('Haymarket','HYM'),('Inverkeithing','INK'),('Kirkcaldy','KDY'),('Kinghorn','KGH'),('Ladybank','LDY'),('Leuchars','LEU'),('Leven','LEV'),('Markinch','MNC'),('North Queensferry','NQU'),('South Gyle','SGL'),('Springfield','SPF');
/*!40000 ALTER TABLE `station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stop`
--

DROP TABLE IF EXISTS `stop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stop` (
  `hc` char(4) NOT NULL,
  `frm` varchar(30) NOT NULL,
  `loc` varchar(30) NOT NULL,
  `adh` int(2) unsigned zerofill NOT NULL CHECK (`adh` <= 24),
  `adm` int(2) unsigned zerofill NOT NULL CHECK (`adm` <= 60),
  `pl` int(10) unsigned NOT NULL,
  PRIMARY KEY (`hc`,`frm`,`loc`),
  KEY `frm` (`frm`),
  KEY `loc` (`loc`),
  CONSTRAINT `stop_ibfk_1` FOREIGN KEY (`hc`) REFERENCES `plan` (`hc`),
  CONSTRAINT `stop_ibfk_2` FOREIGN KEY (`frm`) REFERENCES `plan` (`frm`),
  CONSTRAINT `stop_ibfk_3` FOREIGN KEY (`loc`) REFERENCES `plan` (`loc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stop`
--

LOCK TABLES `stop` WRITE;
/*!40000 ALTER TABLE `stop` DISABLE KEYS */;
INSERT INTO `stop` VALUES ('1L27','Cupar','Leuchars',00,06,2),('1L27','Dundee Central Jn','Dundee',00,01,3),('1L27','Inverkeithing South Jn','Inverkeithing',00,01,2),('1L27','Kinghorn','Kirkcaldy',00,04,2),('1L27','Markinch','Ladybank',00,06,2),('1L27','Princes St Gardens','Haymarket',00,03,2),('1L27','South Gyle','Edinburgh Gateway',00,01,2),('1L27','Springfield','Cupar',00,03,2),('1L27','Thornton North Jn','Markinch',00,03,2),('1L32','Dalmeny Jn','Edinburgh Gateway',00,03,1),('1L32','Haymarket Central Jn','Haymarket',00,01,1),('1L32','Inverkeithing U.P.L.','Inverkeithing',00,01,1),('1L32','Ladybank','Markinch',00,07,1),('1L32','Leuchars','Cupar',00,07,1),('1L32','Princes St Gardens','Edinburgh',00,02,15),('1L32','Springfield','Ladybank',00,03,1),('1L32','St. Fort Signal Ts26','Leuchars',00,03,1),('1L32','Thornton South Jn','Kirkcaldy',00,05,1),('2K69','Aberdour','Burntisland',00,03,2),('2K69','Burntisland','Kinghorn',00,04,2),('2K69','Cameron Bridge','Leven',00,04,1),('2K69','Dalgety Bay','Aberdour',00,03,2),('2K69','Dalmeny','North Queensferry',00,03,2),('2K69','Dalmeny D.P.L.','Dalmeny',00,01,2),('2K69','Earlseat Junction','Cameron Bridge',00,05,2),('2K69','Inverkeithing East Jn','Dalgety Bay',00,02,2),('2K69','Inverkeithing South Jn','Inverkeithing',00,01,2),('2K69','Kinghorn','Kirkcaldy',00,04,2),('2K69','Princes St Gardens','Haymarket',00,02,2),('2K69','South Gyle','Edinburgh Gateway',00,01,2);
/*!40000 ALTER TABLE `stop` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`anon`@`%`*/ /*!50003 TRIGGER trg_check_arrival_before_departure
BEFORE INSERT ON stop
FOR EACH ROW
BEGIN
  DECLARE arr_time INT;
  DECLARE dep_time INT;

  SET arr_time = NEW.adh * 100 + NEW.adm;
  SET dep_time = NEW.adh * 100 + NEW.adm;

  IF NEW.adh IS NOT NULL AND NEW.adm IS NOT NULL THEN
    SET arr_time = NEW.adh * 100 + NEW.adm;
  END IF;

  IF arr_time > (NEW.adh * 100 + NEW.adm) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Arrival time cannot be after departure time.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `train`
--

DROP TABLE IF EXISTS `train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `train` (
  `uid` char(6) NOT NULL CHECK (`uid` regexp '[0-9]{6}'),
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train`
--

LOCK TABLES `train` WRITE;
/*!40000 ALTER TABLE `train` DISABLE KEYS */;
INSERT INTO `train` VALUES ('158704'),('170394'),('170406'),('390124');
/*!40000 ALTER TABLE `train` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `trainLEV`
--

DROP TABLE IF EXISTS `trainLEV`;
/*!50001 DROP VIEW IF EXISTS `trainLEV`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `trainLEV` AS SELECT
 1 AS `hc`,
  1 AS `orig`,
  1 AS `dep` */;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'anon_P2'
--
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_add_loc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`anon`@`%` PROCEDURE `proc_add_loc`(
  IN in_hc CHAR(4),
  IN in_loc VARCHAR(255),
  IN in_prev VARCHAR(255),
  IN in_ddh INT,
  IN in_ddm INT,
  IN in_adh INT,
  IN in_adm INT,
  IN in_pl INT
)
BEGIN
  DECLARE is_stop BOOLEAN;

  IF NOT EXISTS (SELECT 1 FROM location WHERE loc = in_loc) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Location does not exist.';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM route WHERE hc = in_hc) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Route does not exist.';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM plan WHERE hc = in_hc AND loc = in_prev) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Previous location not found on route.';
  END IF;

  IF (in_ddh = 99 OR in_ddm = 99) THEN
    IF EXISTS (SELECT 1 FROM plan WHERE hc = in_hc AND frm = in_loc) THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot append terminal location mid-route.';
    END IF;
  ELSE
    IF in_ddh NOT BETWEEN 0 AND 23 OR in_ddm NOT BETWEEN 0 AND 59 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Invalid departure differential.';
    END IF;
  END IF;

  INSERT INTO plan(hc, frm, loc, ddh, ddm)
  VALUES (in_hc, in_prev, in_loc, in_ddh, in_ddm);

  SET is_stop = in_adh IS NOT NULL AND in_adm IS NOT NULL AND in_pl IS NOT NULL;

  IF is_stop THEN
    INSERT INTO stop(hc, frm, loc, adh, adm, pl)
    VALUES (in_hc, in_prev, in_loc, in_adh, in_adm, in_pl);
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_new_service` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`anon`@`%` PROCEDURE `proc_new_service`(
  IN in_orig CHAR(3),
  IN in_pl INT,
  IN in_dh INT,
  IN in_dm INT,
  IN in_uid INT,
  IN in_toc CHAR(2)
)
BEGIN
  DECLARE new_hc CHAR(4);
  DECLARE suffix INT DEFAULT 1;
  DECLARE code CHAR(4);
  DECLARE exists_check INT DEFAULT 1;

  IF NOT EXISTS (SELECT 1 FROM station WHERE code = in_orig) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Invalid origin station.';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM train WHERE uid = in_uid) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Train does not exist.';
  END IF;

  WHILE exists_check = 1 DO
    SET code = CONCAT('1A', LPAD(suffix, 2, '0'));
    SELECT COUNT(*) INTO exists_check FROM route WHERE hc = code;
    SET suffix = suffix + 1;
  END WHILE;

  SET new_hc = code;

  INSERT INTO route(hc, orig) VALUES (new_hc, in_orig);
  INSERT INTO service(hc, dh, dm, pl, uid, toc) VALUES (new_hc, in_dh, in_dm, in_pl, in_uid, in_toc);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `scheduleEDB`
--

/*!50001 DROP VIEW IF EXISTS `scheduleEDB`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`anon`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `scheduleEDB` AS select `s`.`hc` AS `hc`,lpad(`s`.`dh`,2,'0') * 100 + lpad(`s`.`dm`,2,'0') AS `dep`,`s`.`pl` AS `pl`,(select `p2`.`loc` from `plan` `p2` where `p2`.`hc` = `s`.`hc` and (`p2`.`ddh` = 99 or `p2`.`ddm` = 99) limit 1) AS `dest`,count(`c`.`lid`) AS `len`,`s`.`toc` AS `toc` from (((`service` `s` join `train` `t` on(`s`.`uid` = `t`.`uid`)) join `coach` `c` on(`t`.`uid` = `c`.`uid`)) join `route` `r` on(`s`.`hc` = `r`.`hc`)) where `r`.`orig` = 'EDB' group by `s`.`hc`,`s`.`dh`,`s`.`dm`,`s`.`pl`,`s`.`toc` order by lpad(`s`.`dh`,2,'0') * 100 + lpad(`s`.`dm`,2,'0') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `serviceEDBDEE`
--

/*!50001 DROP VIEW IF EXISTS `serviceEDBDEE`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`anon`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `serviceEDBDEE` AS select `p`.`loc` AS `loc`,`s`.`code` AS `stn`,`st`.`pl` AS `pl`,`st`.`adh` * 100 + `st`.`adm` AS `arr`,case when `p`.`ddh` = 99 or `p`.`ddm` = 99 then NULL else `p`.`ddh` * 100 + `p`.`ddm` end AS `dep` from (((`service` `sv` join `plan` `p` on(`sv`.`hc` = `p`.`hc`)) left join `stop` `st` on(`p`.`hc` = `st`.`hc` and `p`.`loc` = `st`.`loc`)) left join `station` `s` on(`p`.`loc` = `s`.`loc`)) where `sv`.`hc` = '1L27' and `sv`.`dh` = 18 and `sv`.`dm` = 59 order by `p`.`frm` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `trainLEV`
--

/*!50001 DROP VIEW IF EXISTS `trainLEV`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`anon`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `trainLEV` AS select `s`.`hc` AS `hc`,`r`.`orig` AS `orig`,lpad(`s`.`dh`,2,'0') * 100 + lpad(`s`.`dm`,2,'0') AS `dep` from (`service` `s` join `route` `r` on(`s`.`hc` = `r`.`hc`)) where `s`.`uid` = 170406 order by lpad(`s`.`dh`,2,'0') * 100 + lpad(`s`.`dm`,2,'0') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-22 21:54:58
