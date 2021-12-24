

USE analysis;
DROP TABLE IF EXISTS `mobile_game_country_Refund`;
CREATE TABLE `mobile_game_country_Refund` (
  -- `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_type` varchar(50)  NOT NULL,
  `group_id` varchar(50)  NOT NULL,
  `channel` varchar(50)  NOT NULL,
  `country_code` varchar(50) NOT NULL,
  `country_zhTW` varchar(60) NOT NULL,
  `currency` varchar(3) NOT NULL,

  `money` decimal(50,4) DEFAULT NULL,
  `Refund` decimal(50,4) DEFAULT NULL,
  `money_refund` decimal(50,4) DEFAULT NULL,
  `Refund_rate` decimal(50,4) DEFAULT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`data_type`,`group_id`,`channel`,`country_code`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;




