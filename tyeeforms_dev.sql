/*
 Navicat Premium Data Transfer

 Source Server         : MySQL (localhost)
 Source Server Type    : MySQL
 Source Server Version : 50521
 Source Host           : localhost
 Source Database       : tyeeforms_dev

 Target Server Type    : MySQL
 Target Server Version : 50521
 File Encoding         : utf-8

 Date: 03/28/2012 14:13:38 PM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `subscriber`
-- ----------------------------
DROP TABLE IF EXISTS `subscriber`;
CREATE TABLE `subscriber` (
  `trnId` int(11) NOT NULL,
  `trnDate` datetime NOT NULL,
  `trnAmount` float NOT NULL,
  `trnEmailAddress` varchar(255) NOT NULL,
  `trnPhoneNumber` varchar(255) NOT NULL,
  `authCode` varchar(255) NOT NULL,
  `messageText` varchar(2056) NOT NULL,
  `name_first` varchar(255) NOT NULL,
  `name_last` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment` int(1) DEFAULT NULL,
  `whatcounts` int(1) DEFAULT NULL,
  `whatcounts_msg` text,
  `whatcounts_sub_id` int(11) DEFAULT NULL,
  `newspref_accountgov` int(1) DEFAULT NULL,
  `newspref_arts_comm` int(1) DEFAULT NULL,
  `newspref_crime_just` int(1) DEFAULT NULL,
  `newspref_economy` int(1) DEFAULT NULL,
  `newspref_education` int(1) DEFAULT NULL,
  `newspref_energy` int(1) DEFAULT NULL,
  `newspref_enviro` int(1) DEFAULT NULL,
  `newspref_health` int(1) DEFAULT NULL,
  `newspref_housing` int(1) DEFAULT NULL,
  `newspref_poverty` int(1) DEFAULT NULL,
  `newspref_rights_just` int(1) DEFAULT NULL,
  `pref_fiction` int(11) DEFAULT NULL,
  `pref_future_enews` int(1) DEFAULT NULL,
  `pref_enews_daily` int(1) DEFAULT NULL,
  `pref_enews_weekly` int(1) DEFAULT NULL,
  `pref_sponsor_enews` int(1) DEFAULT NULL,
  `builder_is_anonymous` int(1) DEFAULT NULL,
  PRIMARY KEY (`trnId`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

