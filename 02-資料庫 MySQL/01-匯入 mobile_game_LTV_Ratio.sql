

USE analysis;
DROP TABLE IF EXISTS `mobile_game_LTV_Ratio`;
CREATE TABLE `mobile_game_LTV_Ratio` (
  -- `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` varchar(50) NOT NULL,
  `marketing_group_name` varchar(60) NOT NULL,
  `channel` varchar(50) NOT NULL,
  `media_source` varchar(60) NOT NULL,
  `country_code` varchar(50) NOT NULL,
  `country_zhTW` varchar(60) NOT NULL,

  `AF_Install` int(10) DEFAULT NULL,
  `AF_Install_30` int(10) DEFAULT NULL,
  `AF_Install_60` int(10) DEFAULT NULL,
  `AF_Install_90` int(10) DEFAULT NULL,
  `AF_Install_120` int(10) DEFAULT NULL,
  `AF_Install_150` int(10) DEFAULT NULL,
  `AF_Install_180` int(10) DEFAULT NULL,
  `AF_Install_210` int(10) DEFAULT NULL,
  `AF_Install_240` int(10) DEFAULT NULL,
  `AF_Install_270` int(10) DEFAULT NULL,
  `AF_Install_300` int(10) DEFAULT NULL,
  `AF_Install_330` int(10) DEFAULT NULL,
  `AF_Install_360` int(10) DEFAULT NULL,

  `revenue_30` decimal(30,4) DEFAULT NULL,
  `revenue_60` decimal(30,4) DEFAULT NULL,
  `revenue_90` decimal(30,4) DEFAULT NULL,
  `revenue_120` decimal(30,4) DEFAULT NULL,
  `revenue_150` decimal(30,4) DEFAULT NULL,
  `revenue_180` decimal(30,4) DEFAULT NULL,
  `revenue_210` decimal(30,4) DEFAULT NULL,
  `revenue_240` decimal(30,4) DEFAULT NULL,
  `revenue_270` decimal(30,4) DEFAULT NULL,
  `revenue_300` decimal(30,4) DEFAULT NULL,
  `revenue_330` decimal(30,4) DEFAULT NULL,
  `revenue_360` decimal(30,4) DEFAULT NULL,
 `ad_revenue_30` decimal(30,6) DEFAULT NULL,
 `ad_revenue_60` decimal(30,6) DEFAULT NULL,
 `ad_revenue_90` decimal(30,6) DEFAULT NULL,
 `ad_revenue_120` decimal(30,6) DEFAULT NULL,
 `ad_revenue_150` decimal(30,6) DEFAULT NULL,
 `ad_revenue_180` decimal(30,6) DEFAULT NULL,
 `ad_revenue_210` decimal(30,6) DEFAULT NULL,
 `ad_revenue_240` decimal(30,6) DEFAULT NULL,
 `ad_revenue_270` decimal(30,6) DEFAULT NULL,
 `ad_revenue_300` decimal(30,6) DEFAULT NULL,
 `ad_revenue_330` decimal(30,6) DEFAULT NULL,
 `ad_revenue_360` decimal(30,6) DEFAULT NULL,
  `LTV_30` decimal(30,6) DEFAULT NULL,
  `LTV_60` decimal(30,6) DEFAULT NULL,
  `LTV_90` decimal(30,6) DEFAULT NULL,
  `LTV_120` decimal(30,6) DEFAULT NULL,
  `LTV_150` decimal(30,6) DEFAULT NULL,
  `LTV_180` decimal(30,6) DEFAULT NULL,
  `LTV_210` decimal(30,6) DEFAULT NULL,
  `LTV_240` decimal(30,6) DEFAULT NULL,
  `LTV_270` decimal(30,6) DEFAULT NULL,
  `LTV_300` decimal(30,6) DEFAULT NULL,
  `LTV_330` decimal(30,6) DEFAULT NULL,
  `LTV_360` decimal(30,6) DEFAULT NULL,

  `Ratio_30` decimal(30,6) DEFAULT NULL,
  `Ratio_60` decimal(30,6) DEFAULT NULL,
  `Ratio_90` decimal(30,6) DEFAULT NULL,
  `Ratio_120` decimal(30,6) DEFAULT NULL,
  `Ratio_150` decimal(30,6) DEFAULT NULL,
  `Ratio_180` decimal(30,6) DEFAULT NULL,
  `Ratio_210` decimal(30,6) DEFAULT NULL,
  `Ratio_240` decimal(30,6) DEFAULT NULL,
  `Ratio_270` decimal(30,6) DEFAULT NULL,
  `Ratio_300` decimal(30,6) DEFAULT NULL,
  `Ratio_330` decimal(30,6) DEFAULT NULL,
  `Ratio_360` decimal(30,6) DEFAULT NULL,

  PRIMARY KEY (`group_id`,`channel`,`media_source`,`country_code`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


-- 2021-07-21 新增欄位  
USE analysis;
ALTER TABLE  `mobile_game_LTV_Ratio`
ADD update_time timestamp NOT NULL;

-- 刪除欄位
USE analysis;
ALTER TABLE `mobile_game_LTV_Ratio` 
DROP COLUMN update_time ;

-- 2021-07-29 新增欄位  
USE analysis;
ALTER TABLE  `mobile_game_LTV_Ratio`
ADD update_time timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ;


-- 2021-09-14 新增欄位  
USE analysis;
ALTER TABLE  `mobile_game_LTV_Ratio`
ADD `ad_revenue_30` decimal(30,6) DEFAULT NULL,
ADD `ad_revenue_60` decimal(30,6) DEFAULT NULL,
ADD `ad_revenue_90` decimal(30,6) DEFAULT NULL,
ADD `ad_revenue_120` decimal(30,6) DEFAULT NULL,
ADD `ad_revenue_150` decimal(30,6) DEFAULT NULL,
ADD `ad_revenue_180` decimal(30,6) DEFAULT NULL,
ADD `ad_revenue_210` decimal(30,6) DEFAULT NULL,
ADD `ad_revenue_240` decimal(30,6) DEFAULT NULL,
ADD `ad_revenue_270` decimal(30,6) DEFAULT NULL,
ADD `ad_revenue_300` decimal(30,6) DEFAULT NULL,
ADD `ad_revenue_330` decimal(30,6) DEFAULT NULL,
ADD `ad_revenue_360` decimal(30,6) DEFAULT NULL;