# === Start ===  
# 主程式 mobile_game_country_Refund.R
# 維護者: Vincent Chang
# 更新日期: 2021-10-05
# === End ===

project_name <- 'mobile_game_country_Refund'


# 載入套件 ==================================================
library(DT)
library(shiny)
library(magrittr)
# library(openxlsx)
library(dplyr)
library(RMySQL)
library(dplyr)

options(scipen = 20)
options(warn = FALSE)


# 存log檔 ==================================================
library(futile.logger)   # log file
library(futile.options)  # log file
# 專案路徑
logpath <- "/home/poisson/log紀錄檔/mg_fb_tag_analysis/mobile_game_country_Refund.log"
# logpath <- "C:/Users/pc072/Desktop/fb_Tag_analysis/log紀錄檔/mobile_game_fb_tag_analysis.log"

# log檔路徑
if (file.exists(logpath) == FALSE){
  file.create(logpath)}
# 啟動log
flog.logger(appender = appender.file(logpath), name = project_name)


tryCatch({
  execute_time <- Sys.time()
  execute_start_time <- Sys.time()
  
  # 1.Loading Data
  source("/home/poisson/login_DB.r")
  
  
  # NAtoNULL 函數
  NAtoNULL <- function(R_data){
    outputs <- lapply(1:length(R_data), function(col_value){ 
      if (is.na(R_data[col_value])){
        trans_value <- "NULL"
      } else {
        trans_value <- paste0("'", R_data[col_value],"'")
      }
    }) %>%
      call("paste0", ., collapse = ", ") %>% 
      eval %>%
      paste0("(", .,")")
    return(outputs)
  }
  
  
  # 設定日期 ==================================================
  # 終端機參數
  args <- commandArgs(trailingOnly = TRUE)
  
  # 程式執行 hash time
  # exe_datetime <- as.character(Sys.time() %>% format(.,  "%Y%m%d%H%M%S"))
  execute_time <- Sys.time()
  
  # 執行日期
  if (NROW(args) > 0) {
    start_date <- ifelse(args[1]>args[2], args[2], args[1]) %>% as.Date() # 日期若前大後小，只做小的那天
    end_date <- ifelse(args[1]>args[2], args[1], args[2]) %>% as.Date() # 日期若前大後小，只做大的那天
  } else {
    start_date <- "2019-05-31"
    end_date <- Sys.Date()
    # end_date <- "2021-08-31"
    
  }
  
  start_datetime_value <- start_date %>% sprintf('%s  00:00:00 GMT', .) %>% as.POSIXct %>% as.numeric %>% `*`(1000)
  end_datetime_value <- end_date %>% sprintf('%s  23:59:59.999 GMT', .) %>% as.POSIXct %>% as.numeric %>% `*`(1000)
  
  
  
  
  # mobile_game_purchase
  mobile_game_purchase_SQL <- sprintf( "SELECT P.*, g.new_group_id AS  group_id
                                       FROM analysis.mobile_game_purchase P
                                       -- 取得group_id(營運角度)
                                       LEFT JOIN ( SELECT DISTINCT ggsid.game_code, server_id, new_group_id FROM (SELECT group_id, server_group_name, new_group_id FROM mobile_game_groupid_setting WHERE new_group_id IS NOT NULL) gid
                                       LEFT JOIN (SELECT DISTINCT group_id, gsid.game_code, server_group_name, server_id FROM mobile_game_server gsid LEFT JOIN mobile_game g ON gsid.game_code = g.game_code) ggsid
                                       ON gid.group_id = ggsid.group_id AND gid.server_group_name = ggsid.server_group_name) g
                                       ON P.gamecode = g.game_code AND P.sid = g.server_id
                                       WHERE 1=1
                                       -- AND P.money > 0
                                       AND P.status = 'PAID'
                                       AND P.time BETWEEN '%s' AND '%s'
                                       -- AND from_unixtime(P.time/1000) BETWEEN '2019-05-31 00:00:00' AND '2021-09-29 23:59:59'
                                       -- 排除測試帳號：
                                       AND uid NOT IN(SELECT DISTINCT uid FROM analysis.mobile_test_member)
                                       ;",start_datetime_value,end_datetime_value)
  mobile_game_purchase <- dbGetQuery(connect_DB, mobile_game_purchase_SQL)
  
  
  # 一、欄位取得 ==================================================
  
  
  # 1.遊戲幣別
  mobile_game_setting <- dbGetQuery(connect_DB, "
                                    -- mobile_game_setting
                                    SELECT group_id , 'USD' AS currency
                                    FROM analysis.mobile_game_setting
                                    WHERE 1=1
                                    AND gt_rev_currency = 'USD'
                                    AND is_marketing = '1'")
  # 取得幣別資訊
  mobile_game_purchase %<>% dplyr::left_join(mobile_game_setting , by = c('group_id' = 'group_id'))
  
  
  # 2.SDK首次安裝國家、平台
  mobile_game_create_role <- dbGetQuery(connect_DB, "SELECT group_id , user_id , channel , country_code , min(`time`) AS Min_time
                                        FROM analysis.mobile_game_create_role
                                        WHERE 1=1
                                        GROUP BY group_id , user_id , channel , country_code ;")
  mobile_game_create_role %>% dplyr::arrange(group_id , user_id , channel , Min_time)
  # uid 首登最早的狀態：
  mobile_game_create_role_temp <- mobile_game_create_role %>%
                                  dplyr::arrange(user_id,Min_time) %>%
                                  dplyr::group_by(group_id,user_id) %>% dplyr::slice(1)
  mobile_game_create_role_temp %>% dplyr::group_by(channel) %>% dplyr::summarise('n'= n())
  names(mobile_game_create_role_temp)[names(mobile_game_create_role_temp)=="Min_time"] <- "install_time" # 用最早的創角時間取代，app登入時間。
  names(mobile_game_create_role_temp)[names(mobile_game_create_role_temp)=="channel"] <- "First_channel"
  
  # mobile_game_create_role_temp %>% names()
  # mobile_game_purchase %>% names()
  # 取得首次安裝國家資訊
  mobile_game_purchase %<>% dplyr::left_join(mobile_game_create_role_temp , by = c('group_id' = 'group_id' , 'uid' = 'user_id'))
  
  
  ##### ==== END ==== ####
  
  
  
  # 二、首次登入國家-退費率計算 ==================================================
  
  
  # 1、mobile_game_purchase
  mobile_game_purchase_ori <- mobile_game_purchase %>% dplyr::filter(money >0)
  mobile_game_purchase_ori %>% names()
  SDK_purchase <- mobile_game_purchase_ori %>% dplyr::group_by(group_id , First_channel , country_code , currency) %>%
                                                dplyr::summarise('money_TWD' = sum(money)
                                                               , 'money_USD' = sum(money/30)
                                                               , 'money_USD_new' = sum(money_usd/100) )
  SDK_purchase %<>% dplyr::mutate('money' = ifelse(is.na(currency), money_TWD , money_USD_new)
                                 ,'currency' = ifelse(is.na(currency), 'TWD'  , currency) )


  # 2、mobile_game_purchase (扣退單)

  # 排除2019-05-31 有退費的訂單
  refund_remove <- dbGetQuery(connect_DB, "SELECT A.oid FROM analysis.mobile_game_purchase A LEFT JOIN (SELECT P.oid , P.time AS `First_PAID_Time` FROM analysis.mobile_game_purchase P) R ON A.original_oid = R.oid WHERE 1=1 AND from_unixtime(R.First_PAID_Time/1000) < '2019-05-31 00:00:00'")
  refund_remove$remove <- 'X'
  mobile_game_purchase %<>% dplyr::left_join(refund_remove , by = c('oid' = 'oid'))
  mobile_game_purchase$remove <- ifelse(is.na(mobile_game_purchase$remove) , 'V', mobile_game_purchase$remove)
  mobile_game_purchase_refund <- mobile_game_purchase %>% dplyr::filter(remove == 'V')

  # 計算國家儲值：
  SDK_purchase_refund <- mobile_game_purchase_refund %>%  dplyr::group_by(group_id , First_channel , country_code , currency) %>%
                                                          dplyr::summarise('money_TWD' = sum(money)
                                                                           , 'money_USD' = sum(money/30)
                                                                           , 'money_USD_new' = sum(money_usd/100) )
  SDK_purchase_refund %<>% dplyr::mutate('money' = ifelse(is.na(currency), money_TWD , money_USD_new)
                                        ,'currency' = ifelse(is.na(currency), 'TWD'  , currency) )
  SDK_purchase_refund %<>% dplyr::select(c(group_id,First_channel,country_code,money))
  names(SDK_purchase_refund)[names(SDK_purchase_refund)=="money"] <- "money_refund"


  # 3.上述退單前與退單後計算：
  SDK_purchase_all <-  dplyr::left_join(SDK_purchase , SDK_purchase_refund , by = c('group_id' = 'group_id' , 'First_channel' = 'First_channel' , 'country_code' = 'country_code' ))
  SDK_purchase_all %>% names()
  SDK_purchase_all %<>% dplyr::mutate('Refund' = (money - money_refund)
                                    , 'Refund_rate' = (money - money_refund)/money )
  
  # Check
  # mobile_game_purchase %>% names()
  # Test <- mobile_game_purchase %>% dplyr::filter(group_id == 'ssr' , country_code == 'CN' , channel == 'google')
  # Test_Table <- Test %>% dplyr::group_by(money)  %>% dplyr::summarise('n'= n())
  # Test_mobile_game_purchase <- mobile_game_purchase %>% dplyr::filter(group_id == 'ssr' , country_code == 'CN' , channel == 'google' , money %in% c(-30,30) )
  
  mobile_game_country_Refund <- SDK_purchase_all %>% dplyr::select(c('group_id', 'First_channel', 'country_code','currency','money', 'Refund', 'money_refund', 'Refund_rate')) 
  names(mobile_game_country_Refund)[names(mobile_game_country_Refund)=="First_channel"] <- "channel"
  
  
  # 國家名稱
  country_name_setting <- dbGetQuery(connect_DB, "SELECT code , country_zhTW FROM analysis.country_name;")
  mobile_game_country_Refund %>% names()
  mobile_game_country_Refund %<>% dplyr::left_join(country_name_setting , by = c('country_code' = 'code') )
  
  # 註記 NULL的group_id、country_code
  mobile_game_country_Refund %<>% dplyr::mutate("group_id" = dplyr::case_when(!is.na(group_id) ~ group_id 
                                                                             , is.na(group_id) ~ "No_group_id_information")
                                              , "channel" = dplyr::case_when(!is.na(channel) ~ channel 
                                                                            , is.na(channel) ~ "No_channel_information")
                                              , "country_code" = dplyr::case_when(!is.na(country_code) ~ country_code 
                                                                              , is.na(country_code) ~ "No_country_information") ) 
  # 數據更新時間
  mobile_game_country_Refund$update_time <- as.POSIXct(end_date, format="%Y-%m-%d %H:%M:%OS")
  # 數據類型
  mobile_game_country_Refund$data_type <- "Country_data"
  
  
  
  # 設定每次匯入筆數
  parser_n <- 10000
  
  # 寫入DB mobile_game_country_Refund 
  print("Start Insert mobile_game_country_Refund")
  if (nrow(mobile_game_country_Refund) > 0){
    
    for (i in seq(1, nrow(mobile_game_country_Refund), by = parser_n)){
      
      start_ind <- i
      end_ind <- i - 1 + parser_n
      
      if (end_ind > nrow(mobile_game_country_Refund)){ 
        end_ind <- nrow(mobile_game_country_Refund)
      }
      print(i)
      print(Sys.time())
      # 將資料寫入(SQL版本)
      insert_values <- mobile_game_country_Refund[start_ind:end_ind,] %>% apply(1, NAtoNULL) %>% paste0(., collapse = ",")
      insert_SQL <- sprintf("INSERT mobile_game_country_Refund (%s) VALUES ",
                            paste0(names(mobile_game_country_Refund), collapse = ", "))
      
      # ON DUPLICATE KEY UPDATE 組字串
      DUPLICATE_KEY_UPDATE_SQL <- names(mobile_game_country_Refund) %>% paste0(" = VALUES(",.,")") %>% 
        paste0(names(mobile_game_country_Refund),.) %>%
        paste0(collapse = " , ") %>% 
        paste0(" ON DUPLICATE KEY UPDATE ",.,";") 
      insert_mobile_game_country_Refund_SQL <- paste0(insert_SQL, insert_values, DUPLICATE_KEY_UPDATE_SQL)
      dbSendQuery(connect_DB, insert_mobile_game_country_Refund_SQL)
    }
  }
  
  ##### ==== END ==== ####
  
  
  
  # 三、首次登入平台-退費率計算 ==================================================
  
  # 1、mobile_game_purchase
  mobile_game_purchase_First_channel <- mobile_game_purchase %>% dplyr::filter(money >0)
  SDK_purchase_First_channel <- mobile_game_purchase_First_channel %>% dplyr::group_by(group_id , First_channel , currency) %>%
                                                                       dplyr::summarise('money_TWD' = sum(money)
                                                                                       , 'money_USD' = sum(money/30)
                                                                                       , 'money_USD_new' = sum(money_usd/100) )
  SDK_purchase_First_channel %<>% dplyr::mutate('money' = ifelse(is.na(currency), money_TWD , money_USD_new)
                                               ,'currency' = ifelse(is.na(currency), 'TWD'  , currency) )
  
  
  # 2、mobile_game_purchase (扣退單)
  
  # 排除2019-05-31 有退費的訂單
  SDK_purchase_First_channel_refund <- mobile_game_purchase
  SDK_purchase_First_channel_refund <- SDK_purchase_First_channel_refund %>%  dplyr::group_by(group_id , First_channel , currency) %>%
                                                                              dplyr::summarise('money_TWD' = sum(money)
                                                                                             , 'money_USD' = sum(money/30)
                                                                                             , 'money_USD_new' = sum(money_usd/100) )
  SDK_purchase_First_channel_refund %<>% dplyr::mutate('money' = ifelse(is.na(currency), money_TWD , money_USD_new)
                                                      ,'currency' = ifelse(is.na(currency), 'TWD'  , currency) )
  SDK_purchase_First_channel_refund %<>% dplyr::select(c(group_id,First_channel,money))
  names(SDK_purchase_First_channel_refund)[names(SDK_purchase_First_channel_refund)=="money"] <- "money_refund"
  
  
  # 3.上述退單前與退單後計算：
  SDK_purchase_First_channel <-  dplyr::left_join(SDK_purchase_First_channel , SDK_purchase_First_channel_refund , by = c('group_id' = 'group_id' , 'First_channel' = 'First_channel' ))
  SDK_purchase_First_channel %<>% dplyr::mutate('Refund' = (money - money_refund)
                                              , 'Refund_rate' = (money - money_refund)/money )
  
  mobile_game_channel_Refund <- SDK_purchase_First_channel %>% dplyr::select(c('group_id', 'First_channel','currency','money', 'Refund', 'money_refund', 'Refund_rate')) 
  names(mobile_game_channel_Refund)[names(mobile_game_channel_Refund)=="First_channel"] <- "channel"
  
  # 註記 NULL的group_id、channel
  mobile_game_channel_Refund %<>% dplyr::mutate("group_id" = dplyr::case_when(!is.na(group_id) ~ group_id 
                                                                             , is.na(group_id) ~ "No_group_id_information")
                                               , "channel" = dplyr::case_when(!is.na(channel) ~ channel 
                                                                             , is.na(channel) ~ "No_channel_information") ) 
  mobile_game_channel_Refund$country_code <- 'Total'
    
  
  # 數據更新時間
  mobile_game_channel_Refund$update_time <- as.POSIXct(end_date, format="%Y-%m-%d %H:%M:%OS")
  # 數據類型
  mobile_game_channel_Refund$data_type <- "channel_data"
  
  
  # 寫入DB mobile_game_channel_Refund 
  print("Start Insert mobile_game_channel_Refund")
  if (nrow(mobile_game_channel_Refund) > 0){
    
    for (i in seq(1, nrow(mobile_game_channel_Refund), by = parser_n)){
      
      start_ind <- i
      end_ind <- i - 1 + parser_n
      
      if (end_ind > nrow(mobile_game_channel_Refund)){ 
        end_ind <- nrow(mobile_game_channel_Refund)
      }
      print(i)
      print(Sys.time())
      # 將資料寫入(SQL版本)
      insert_values <- mobile_game_channel_Refund[start_ind:end_ind,] %>% apply(1, NAtoNULL) %>% paste0(., collapse = ",")
      insert_SQL <- sprintf("INSERT mobile_game_country_Refund (%s) VALUES ",
                            paste0(names(mobile_game_channel_Refund), collapse = ", "))
      
      # ON DUPLICATE KEY UPDATE 組字串
      DUPLICATE_KEY_UPDATE_SQL <- names(mobile_game_channel_Refund) %>% paste0(" = VALUES(",.,")") %>% 
        paste0(names(mobile_game_channel_Refund),.) %>%
        paste0(collapse = " , ") %>% 
        paste0(" ON DUPLICATE KEY UPDATE ",.,";") 
      insert_mobile_game_channel_Refund_SQL <- paste0(insert_SQL, insert_values, DUPLICATE_KEY_UPDATE_SQL)
      dbSendQuery(connect_DB, insert_mobile_game_channel_Refund_SQL)
    }
  }
  
  
  ##### ==== END ==== ####
  
  
  
  # 四、各遊戲-總退費率計算 ==================================================
  
  # 1、mobile_game_purchase
  mobile_game_purchase_group_id <- mobile_game_purchase %>% dplyr::filter(money >0)
  mobile_game_purchase_group_id %>% names() # gamecode
  SDK_purchase_group_id <- mobile_game_purchase_group_id %>% dplyr::group_by( group_id , currency) %>%
                                                            dplyr::summarise('money_TWD' = sum(money)
                                                                             , 'money_USD' = sum(money/30)
                                                                             , 'money_USD_new' = sum(money_usd/100) )
  SDK_purchase_group_id %<>% dplyr::mutate('money' = ifelse(is.na(currency), money_TWD , money_USD_new)
                                          ,'currency' = ifelse(is.na(currency), 'TWD'  , currency) )
  
  # CP 退款資料確認：
  # mobile_game_purchase_cp_refund <- mobile_game_purchase %>% dplyr::filter(money <0 , gamecode == 'cp')
  # mobile_game_purchase_cp_refund$money_usd <- (mobile_game_purchase_cp_refund$money_usd/100)
  # (mobile_game_purchase_cp_refund$money_usd/100) %>% sum()
  # write.xlsx(mobile_game_purchase_cp_refund, "mobile_game_purchase_cp_refund.xlsx")
  
  
  # 2、mobile_game_purchase (扣退單)
  
  # 排除2019-05-31 有退費的訂單
  SDK_purchase_group_id_refund <- mobile_game_purchase
  SDK_purchase_group_id_refund <- SDK_purchase_group_id_refund %>%  dplyr::group_by(group_id  , currency) %>%
                                                                    dplyr::summarise('money_TWD' = sum(money)
                                                                                     , 'money_USD' = sum(money/30)
                                                                                     , 'money_USD_new' = sum(money_usd/100) )
  SDK_purchase_group_id_refund %<>% dplyr::mutate('money' = ifelse(is.na(currency), money_TWD , money_USD_new)
                                                 ,'currency' = ifelse(is.na(currency), 'TWD'  , currency) )
  SDK_purchase_group_id_refund %<>% dplyr::select(c(group_id,money))
  names(SDK_purchase_group_id_refund)[names(SDK_purchase_group_id_refund)=="money"] <- "money_refund"
  
  
  # 3.上述退單前與退單後計算：
  SDK_purchase_group_id <-  dplyr::left_join(SDK_purchase_group_id , SDK_purchase_group_id_refund , by = c('group_id' = 'group_id' ))
  SDK_purchase_group_id %<>% dplyr::mutate('Refund' = (money - money_refund)
                                         , 'Refund_rate' = (money - money_refund)/money )
  
  mobile_game_group_id_Refund <- SDK_purchase_group_id %>% dplyr::select(c('group_id','currency','money', 'Refund', 'money_refund', 'Refund_rate')) 
  
  # 註記 NULL的group_id、channel
  mobile_game_group_id_Refund %<>% dplyr::mutate("group_id" = dplyr::case_when(!is.na(group_id) ~ group_id 
                                                                              , is.na(group_id) ~ "No_group_id_information") ) 
  mobile_game_group_id_Refund$channel <- 'Total'
  mobile_game_group_id_Refund$country_code <- 'Total'
  
  # 數據更新時間
  mobile_game_group_id_Refund$update_time <- as.POSIXct(end_date, format="%Y-%m-%d %H:%M:%OS")
  # 數據類型
  mobile_game_group_id_Refund$data_type <- "group_data"
  
  
  # 寫入DB mobile_game_channel_Refund 
  print("Start Insert mobile_game_group_id_Refund")
  if (nrow(mobile_game_group_id_Refund) > 0){
    
    for (i in seq(1, nrow(mobile_game_group_id_Refund), by = parser_n)){
      
      start_ind <- i
      end_ind <- i - 1 + parser_n
      
      if (end_ind > nrow(mobile_game_group_id_Refund)){ 
        end_ind <- nrow(mobile_game_group_id_Refund)
      }
      print(i)
      print(Sys.time())
      # 將資料寫入(SQL版本)
      insert_values <- mobile_game_group_id_Refund[start_ind:end_ind,] %>% apply(1, NAtoNULL) %>% paste0(., collapse = ",")
      insert_SQL <- sprintf("INSERT mobile_game_country_Refund (%s) VALUES ",
                            paste0(names(mobile_game_group_id_Refund), collapse = ", "))
      
      # ON DUPLICATE KEY UPDATE 組字串
      DUPLICATE_KEY_UPDATE_SQL <- names(mobile_game_group_id_Refund) %>% paste0(" = VALUES(",.,")") %>% 
        paste0(names(mobile_game_group_id_Refund),.) %>%
        paste0(collapse = " , ") %>% 
        paste0(" ON DUPLICATE KEY UPDATE ",.,";") 
      insert_mobile_game_group_id_Refund_SQL <- paste0(insert_SQL, insert_values, DUPLICATE_KEY_UPDATE_SQL)
      dbSendQuery(connect_DB, insert_mobile_game_group_id_Refund_SQL)
    }
  }
  
  
  ##### ==== END ==== ####
  
  
  
  
  # 紀錄執行的時間：
  execute_end_time <- Sys.time()
  execute_time <- (execute_end_time - execute_start_time) %>% round(2)
  print(execute_time)


},

error = function(e) {
  mobile_game_country_Refund_log_Error <- paste("mobile_game_country_Refund.R 執行失敗，錯誤訊息：", 
                                                conditionMessage(e))
} 
)


if(!exists("mobile_game_country_Refund_log_Error")){
  
  # 紀錄log
  futile.logger::flog.info(sprintf("mobile_game_country_Refund.R 執行成功 \n StartDate:%s，EndDate:%s，設定時間為%s至%s", execute_start_time , Sys.time(), start_date, end_date) ,
                           name = project_name)
  
} else {
  
  # 紀錄log
  futile.logger::flog.error(mobile_game_country_Refund_log_Error,
                            name = project_name)
  # 寄信通知
  mailR::send.mail(from  = con_Mysql_gameDB$mail$Gmail_CM_Account,
                   to    = con_Mysql_gameDB$mail$Gmail_CM_Account,
                   subject = sprintf("mobile_game_country_Refund.R  主程式錯誤訊息，設定時間為%s至%s", execute_time , Sys.time(), start_date, end_date),
                   body = sprintf("錯誤訊息：\n 程式執行失敗\n %s\n",
                                  mobile_game_country_Refund_log_Error),
                   encoding = "utf-8",
                   smtp = list(host.name = "aspmx.l.google.com", port = 25),
                   authenticate = FALSE,
                   send = TRUE)
}





