/*
 Navicat MySQL Data Transfer

 Source Server         : sql11.freemysqlhosting.net_3306
 Source Server Type    : MySQL
 Source Server Version : 50562
 Source Host           : sql11.freemysqlhosting.net:3306
 Source Schema         : sql11444739

 Target Server Type    : MySQL
 Target Server Version : 50562
 File Encoding         : 65001

 Date: 16/10/2021 15:09:37
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for crimes
-- ----------------------------
DROP TABLE IF EXISTS `crimes`;
CREATE TABLE `crimes`  (
  `crimeID` int(12) NOT NULL AUTO_INCREMENT,
  `crimeIssuer` int(12) NOT NULL DEFAULT 65535,
  `crimeIssuedTo` int(12) NOT NULL DEFAULT 65535,
  `crimeDescription` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `crimeIssuerName` varchar(24) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `crimeIssuedToName` varchar(24) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`crimeID`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 92 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for kills
-- ----------------------------
DROP TABLE IF EXISTS `kills`;
CREATE TABLE `kills`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `killerID` int(11) NOT NULL DEFAULT -1,
  `killedID` int(11) NOT NULL DEFAULT -1,
  `killTS` int(32) NOT NULL DEFAULT 0,
  `killText` varchar(250) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 995 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for players
-- ----------------------------
DROP TABLE IF EXISTS `players`;
CREATE TABLE `players`  (
  `ID` int(12) NOT NULL AUTO_INCREMENT,
  `Username` varchar(24) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `Password` varchar(129) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `Level` int(6) NOT NULL DEFAULT 0,
  `AdminLevel` int(6) NOT NULL DEFAULT 0,
  `AdminName` varchar(24) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'Nobody',
  `Mapper` int(11) NOT NULL,
  `BanAppealer` int(2) NOT NULL DEFAULT 0,
  `Donator` int(2) NOT NULL DEFAULT 0,
  `Banned` int(2) NOT NULL DEFAULT 0,
  `Permabanned` int(2) NOT NULL DEFAULT 0,
  `Disabled` int(2) NOT NULL DEFAULT 0,
  `LastIP` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.0.0.0',
  `Registered` int(2) NOT NULL DEFAULT 0,
  `Tutorial` int(2) NOT NULL DEFAULT 0,
  `Sex` int(2) NOT NULL DEFAULT 0,
  `Age` int(3) NOT NULL DEFAULT 16,
  `Skin` int(3) NOT NULL DEFAULT 299,
  `PosX` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.000',
  `PosY` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.000',
  `PosZ` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.000',
  `PosR` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.000',
  `ConnectTime` int(4) NOT NULL DEFAULT 0,
  `Respect` int(9) NOT NULL DEFAULT 0,
  `PhoneNumber` int(11) NOT NULL DEFAULT 0,
  `Warnings` int(1) NOT NULL DEFAULT 0,
  `Gang` int(2) NOT NULL DEFAULT 255,
  `Faction` int(2) NOT NULL DEFAULT 0,
  `Leader` int(2) NOT NULL DEFAULT 0,
  `Rank` int(1) NOT NULL DEFAULT 0,
  `Job` int(2) NOT NULL DEFAULT 0,
  `Job2` int(2) NOT NULL DEFAULT 0,
  `UpgradePoints` int(9) NOT NULL DEFAULT 0,
  `SpawnArmor` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.0',
  `Cash` int(11) NOT NULL DEFAULT 50,
  `Bank` int(11) NOT NULL DEFAULT 50,
  `Insurance` int(2) NOT NULL DEFAULT 0,
  `Crimes` int(9) NOT NULL DEFAULT 0,
  `Arrested` int(4) NOT NULL DEFAULT 0,
  `WantedLevel` int(1) NOT NULL DEFAULT 0,
  `Health` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '75.0',
  `Armor` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.0',
  `Pot` int(9) NOT NULL DEFAULT 0,
  `Crack` int(9) NOT NULL DEFAULT 0,
  `Radio` int(1) NOT NULL DEFAULT 0,
  `RadioFreq` int(11) NOT NULL DEFAULT -1,
  `Phonebook` int(1) NOT NULL DEFAULT 0,
  `Dice` int(4) NOT NULL DEFAULT 0,
  `CDPlayer` int(4) NOT NULL DEFAULT 0,
  `Materials` int(4) NOT NULL DEFAULT 0,
  `Rope` int(4) NOT NULL DEFAULT 0,
  `Cigars` int(4) NOT NULL DEFAULT 0,
  `Sprunk` int(4) NOT NULL DEFAULT 0,
  `Spraycan` int(4) NOT NULL DEFAULT 0,
  `House` int(4) NOT NULL DEFAULT 0,
  `House2` int(4) NOT NULL DEFAULT 0,
  `Renting` int(4) NOT NULL DEFAULT 0,
  `Interior` int(11) NOT NULL DEFAULT 0,
  `VirtualWorld` int(11) NOT NULL DEFAULT 0,
  `Jailed` int(1) NOT NULL DEFAULT 0,
  `JailTime` int(11) NOT NULL DEFAULT 0,
  `Gun0` int(2) NOT NULL DEFAULT 0,
  `Gun1` int(2) NOT NULL DEFAULT 0,
  `Gun2` int(2) NOT NULL DEFAULT 0,
  `Gun3` int(2) NOT NULL DEFAULT 0,
  `Gun4` int(2) NOT NULL DEFAULT 0,
  `Gun5` int(2) NOT NULL DEFAULT 0,
  `Gun6` int(2) NOT NULL DEFAULT 0,
  `Gun7` int(2) NOT NULL DEFAULT 0,
  `Gun8` int(2) NOT NULL DEFAULT 0,
  `Gun9` int(2) NOT NULL DEFAULT 0,
  `Gun10` int(2) NOT NULL DEFAULT 0,
  `Gun11` int(2) NOT NULL DEFAULT 0,
  `Paycheck` int(11) NOT NULL DEFAULT 0,
  `PayReady` int(2) NOT NULL DEFAULT 0,
  `Hospital` int(2) NOT NULL DEFAULT 0,
  `DetSkill` int(5) NOT NULL DEFAULT 0,
  `FishSkill` int(12) NOT NULL DEFAULT 0,
  `LawSkill` int(5) NOT NULL DEFAULT 0,
  `SexSkill` int(5) NOT NULL DEFAULT 0,
  `DrugsSkill` int(5) NOT NULL DEFAULT 0,
  `SmugglerSkill` int(5) NOT NULL DEFAULT 0,
  `ArmsSkill` int(5) NOT NULL DEFAULT 0,
  `MechSkill` int(5) NOT NULL DEFAULT 0,
  `BoxSkill` int(5) NOT NULL DEFAULT 0,
  `TruckSkill` int(5) NOT NULL DEFAULT 0,
  `CarSkill` int(5) NOT NULL DEFAULT 0,
  `LawyerTime` int(4) NOT NULL DEFAULT 0,
  `LawyerFreeTime` int(4) NOT NULL DEFAULT 0,
  `DrugsTime` int(4) NOT NULL DEFAULT 0,
  `MechTime` int(4) NOT NULL DEFAULT 0,
  `SexTime` int(4) NOT NULL DEFAULT 0,
  `CarTime` int(4) NOT NULL DEFAULT 0,
  `Fishes` int(4) NOT NULL DEFAULT 0,
  `BiggestFish` int(4) NOT NULL DEFAULT 0,
  `pWEXists` int(2) NOT NULL DEFAULT 0,
  `pWX` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.0',
  `pWY` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.0',
  `pWZ` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.0',
  `pWVW` int(9) NOT NULL DEFAULT 0,
  `pWInt` int(9) NOT NULL DEFAULT 0,
  `pWValue` int(9) NOT NULL DEFAULT 0,
  `pWSeeds` int(4) NOT NULL DEFAULT 0,
  `Wins` int(9) NOT NULL DEFAULT 0,
  `Loses` int(9) NOT NULL DEFAULT 0,
  `FightingStyle` int(4) NOT NULL DEFAULT 0,
  `Screwdriver` int(4) NOT NULL DEFAULT 0,
  `Smslog` int(2) NOT NULL DEFAULT 0,
  `Wristwatch` int(2) NOT NULL DEFAULT 0,
  `Tire` int(4) NOT NULL DEFAULT 0,
  `Firstaid` int(4) NOT NULL DEFAULT 0,
  `Rccam` int(4) NOT NULL DEFAULT 0,
  `Receiver` int(4) NOT NULL DEFAULT 0,
  `GPS` int(4) NOT NULL DEFAULT 0,
  `Sweep` int(4) NOT NULL DEFAULT 0,
  `SweepLeft` int(4) NOT NULL DEFAULT 0,
  `Bugged` int(4) NOT NULL DEFAULT 0,
  `OnDuty` int(2) NOT NULL DEFAULT 0,
  `CarLic` int(2) NOT NULL DEFAULT 0,
  `FlyLic` int(2) NOT NULL DEFAULT 0,
  `BoatLic` int(2) NOT NULL DEFAULT 0,
  `FishLic` int(2) NOT NULL DEFAULT 0,
  `GunLic` int(2) NOT NULL DEFAULT 0,
  `Division` int(4) NOT NULL DEFAULT 0,
  `TicketTime` int(4) NOT NULL DEFAULT 0,
  `HeadValue` int(11) NOT NULL DEFAULT 0,
  `ContractBy` varchar(24) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ContractDetail` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `Bombs` int(4) NOT NULL DEFAULT 0,
  `CHits` int(11) NOT NULL DEFAULT 0,
  `FHits` int(11) NOT NULL DEFAULT 0,
  `PrisonedBy` varchar(24) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'Nobody',
  `PrisonReason` varchar(24) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'None',
  `AcceptReport` int(11) NOT NULL DEFAULT 0,
  `TrashReport` int(11) NOT NULL DEFAULT 0,
  `Accent` int(4) NOT NULL DEFAULT 0,
  `NewMuted` int(4) NOT NULL DEFAULT 0,
  `NewMutedTotal` int(4) NOT NULL DEFAULT 0,
  `AdMuted` int(4) NOT NULL DEFAULT 0,
  `AdMutedTotal` int(4) NOT NULL DEFAULT 0,
  `ReportMuted` int(2) NOT NULL DEFAULT 0,
  `ReportMutedTotal` int(4) NOT NULL DEFAULT 0,
  `ReportMutedTime` int(9) NOT NULL DEFAULT 0,
  `Speedo` int(2) NOT NULL DEFAULT 0,
  `GCMuted` int(4) NOT NULL DEFAULT 0,
  `GCMutedTime` int(9) NOT NULL DEFAULT 0,
  `CallsAccepted` int(11) NOT NULL DEFAULT 0,
  `PatientsDelivered` int(11) NOT NULL DEFAULT 0,
  `TriageTime` int(9) NOT NULL DEFAULT 9,
  `Married` int(2) NOT NULL DEFAULT 0,
  `MarriedTo` varchar(24) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ReferredBy` varchar(24) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `RefTokens` int(9) NOT NULL DEFAULT 0,
  `RefTokensOffline` int(9) NOT NULL DEFAULT 0,
  `Helper` int(2) NOT NULL DEFAULT 0,
  `GangMod` int(2) NOT NULL DEFAULT 0,
  `LiveBanned` int(2) NOT NULL DEFAULT 0,
  `Flag` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `Blindfold` int(4) NOT NULL DEFAULT 0,
  `Gas` int(4) NOT NULL DEFAULT 0,
  `Gate1` int(4) NOT NULL DEFAULT 0,
  `Gate2` int(4) NOT NULL DEFAULT 0,
  `Gate3` int(4) NOT NULL DEFAULT 0,
  `Emlak` int(2) NOT NULL DEFAULT 0,
  `Biz` int(4) NOT NULL DEFAULT 0,
  `VBiz` int(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 537 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for playervehicles
-- ----------------------------
DROP TABLE IF EXISTS `playervehicles`;
CREATE TABLE `playervehicles`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Owner` int(12) NOT NULL DEFAULT 0,
  `PosX` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.0',
  `PosY` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.0',
  `PosZ` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.0',
  `PosAngle` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0.0',
  `ModelID` int(11) NOT NULL DEFAULT 0,
  `LockType` int(2) NOT NULL DEFAULT 0,
  `Locked` int(2) NOT NULL DEFAULT 0,
  `PaintJob` int(4) NOT NULL DEFAULT -1,
  `Color1` int(4) NOT NULL DEFAULT -1,
  `Color2` int(4) NOT NULL DEFAULT -1,
  `Price` int(11) NOT NULL DEFAULT 0,
  `Ticket` int(11) NOT NULL DEFAULT 0,
  `Weapon0` int(4) NOT NULL DEFAULT 0,
  `Weapon1` int(4) NOT NULL DEFAULT 0,
  `Weapon2` int(4) NOT NULL DEFAULT 0,
  `WepUpgrade` int(4) NOT NULL DEFAULT 0,
  `Fuel` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `Impound` int(4) NOT NULL DEFAULT 0,
  `Spawned` int(4) NOT NULL DEFAULT 0,
  `Disabled` int(4) NOT NULL DEFAULT 0,
  `NumPlate` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `Mod0` int(4) NOT NULL DEFAULT 0,
  `Mod1` int(4) NOT NULL DEFAULT 0,
  `Mod2` int(4) NOT NULL DEFAULT 0,
  `Mod3` int(4) NOT NULL DEFAULT 0,
  `Mod4` int(4) NOT NULL DEFAULT 0,
  `Mod5` int(4) NOT NULL DEFAULT 0,
  `Mod6` int(4) NOT NULL DEFAULT 0,
  `Mod7` int(4) NOT NULL DEFAULT 0,
  `Mod8` int(4) NOT NULL DEFAULT 0,
  `Mod9` int(4) NOT NULL DEFAULT 0,
  `Mod10` int(4) NOT NULL DEFAULT 0,
  `Mod11` int(4) NOT NULL DEFAULT 0,
  `Mod12` int(4) NOT NULL DEFAULT 0,
  `Mod13` int(4) NOT NULL DEFAULT 0,
  `Mod14` int(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 446 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Table structure for punishments
-- ----------------------------
DROP TABLE IF EXISTS `punishments`;
CREATE TABLE `punishments`  (
  `punID` int(12) NOT NULL AUTO_INCREMENT,
  `punIssuedTo` int(12) NOT NULL DEFAULT 65535,
  `punIssuer` int(12) NOT NULL DEFAULT 65535,
  `punText` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `punType` int(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`punID`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for toys
-- ----------------------------
DROP TABLE IF EXISTS `toys`;
CREATE TABLE `toys`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Owner` int(6) NOT NULL DEFAULT 0,
  `ModelID` int(11) NOT NULL DEFAULT 0,
  `Bone` int(4) NOT NULL DEFAULT 0,
  `PosX` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `PosY` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `PosZ` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `RotX` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `RotY` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `RotZ` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ScaX` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ScaY` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ScaZ` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 328 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
