# -*- coding: utf-8 -*-

"""
Created on Wed Mar 24 16:34:47 
=================================================    
主程式 mobile_game_LTV_Ratio.py
維護者: Vincent Chang
更新日期: 2021-05-07
=================================================   
@author: Vincent Chang
"""


# In[1.資料庫連線、套件載入、函數載入]

# import os
# os.chdir('/home/poisson/Program_Schedule/Python_Project')
# print(os.getcwd())


# Loading package & function 
from Connect_DB import get_mysql_data , config
from mobile_game_LTV_Ratio_fn import Appsflyer_LTV_FN , Appsflyer_LTV_Ratio_TW , Appsflyer_LTV_Ratio_US
import pandas as pd
import numpy as np
import datetime
import sys
import logging
import pymysql

# 方法2：忽略信号
# from signal import signal, SIGPIPE, SIG_DFL, SIG_IGN
# signal(SIGPIPE, SIG_IGN)



# In[2.資料處理]

try:
    
    # 一、Data define =================
    # 執行程式時間：  
    # from datetime import datetime
    execute_time = str(datetime.datetime.now())
        
    # 1.declare game name：
    # Game_list = ["ssrtw","ssr", "mt","sl",'jiangdan', "jiangdanen","jj"]
    Game_list_sql = """
                    SELECT A.marketing_group_id , A.marketing_group_name , A.server_group_name ,  COUNT(1) AS C
                    FROM(
                        SELECT  A.*
                              , B.status , B.is_multi_lang_marketing ,B.is_multi_lang
                              , CASE WHEN B.is_multi_lang_marketing = '1' THEN A.new_group_id ELSE A.group_id END AS marketing_group_id
                              , CASE WHEN B.is_multi_lang_marketing = '1' THEN A.new_group_name ELSE A.group_name END AS marketing_group_name
                        FROM mobile_game_groupid_setting A
                        LEFT JOIN mobile_game_setting B
                        ON A.group_id = B.group_id ) A
                    WHERE 1=1
                    AND A.status = '1'
                    GROUP BY A.marketing_group_id , A.marketing_group_name , A.server_group_name
                    -- HAVING A.server_group_name = 'TW'
                    ;
                    """
    Game_list = get_mysql_data(sql = Game_list_sql)
    # 排除PKB
    Game_list = Game_list.query("marketing_group_name != 'Pool King Battle'")  
    
    # (1).Server Setting
    Game_list_Server_TW = Game_list[Game_list['server_group_name'] == 'TW'].filter(['marketing_group_id']).drop_duplicates()
    Game_list_Server_TW = Game_list_Server_TW['marketing_group_id'].tolist()
    Game_list_Server_Non_TW = Game_list[Game_list['server_group_name'] != 'TW'].filter(['marketing_group_id']).drop_duplicates()
    Game_list_Server_Non_TW = Game_list_Server_Non_TW['marketing_group_id'].tolist()
    
    # (2).Game Setting
    Game_list = Game_list[['marketing_group_id','marketing_group_name']].drop_duplicates()  
    Game_list = Game_list['marketing_group_id'].tolist()
    
    
    # 2.declare data date：
    arg = sys.argv
    if len(arg) == 3:
       Start_Date = arg[1]
       End_Date = arg[2]
    else:
       Start_Date = str('2019-05-31') 
       End_Date = str(datetime.date.today()) 
       
    # 3.Write Log file：
    # 專案名稱
    project_name = 'mobile_game_LTV_Ratio'
    # 專案路徑
    logpath = "C:\\Users\\pc072\\Desktop\\Poisson\\Project\\育駿公司-專案報告\\2020-10-23-各遊戲-國家LTV數據整併\\mobile_game_LTV_Ratio.log"
    # logpath = "/home/poisson/log紀錄檔/mg_fb_tag_analysis/mobile_game_LTV_Ratio.log"
    logger = logging.getLogger(project_name)
    # log檔-設定
    logging.basicConfig(filename = logpath,
                        level = logging.INFO,
                        format = '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                        datefmt = '%Y-%m-%d %H:%M:%S' 
                        )
       
    # 二、RUN SQL game data  =================
    
    # Create empty dictionary
    Appsflyer_data_list_sql = {}
    Appsflyer_data_list = {}
    Appsflyer_data_list.keys()
    
    # 1.遊戲幣別：
    Game_currency_SQL = """ 
                      SELECT id , group_id AS new_group_id_setting
                      FROM analysis.mobile_game_setting
                      WHERE 1=1
                      AND gt_rev_currency = 'USD'
                      AND is_marketing = '1';
                      """
    Game_currency = get_mysql_data(sql = Game_currency_SQL)
    
    # 2.每月匯率-對照表：
    exchange_rate_SQL = """ 
                      SELECT LEFT(month,7) AS month, exchange_rate FROM analysis.exchange_rate WHERE currency = 'USD';
                      """
    exchange_rate = get_mysql_data(sql = exchange_rate_SQL)
    
    
    # 3.行銷遊戲-對照表：
    Marketing_game_name_sql = """
                            SELECT A.marketing_group_id , A.marketing_group_name , COUNT(1) AS C
                            FROM(
                                SELECT  A.*
                                      , B.status , B.is_multi_lang_marketing ,B.is_multi_lang
                                      , CASE WHEN B.is_multi_lang_marketing = '1' THEN A.new_group_id ELSE A.group_id END AS marketing_group_id
                                      , CASE WHEN B.is_multi_lang_marketing = '1' THEN A.new_group_name ELSE A.group_name END AS marketing_group_name
                                FROM mobile_game_groupid_setting A
                                LEFT JOIN mobile_game_setting B
                                ON A.group_id = B.group_id ) A
                            WHERE 1=1
                            -- AND A.status = '1'
                            GROUP BY A.marketing_group_id , A.marketing_group_name;
                            """
    Marketing_game_name = get_mysql_data(sql = Marketing_game_name_sql)
    # filter col
    Marketing_game_name = Marketing_game_name.filter(['marketing_group_id','marketing_group_name'])
    
    
    for i in range(len(Game_list)):
        import time
        time_start = time.time() #開始計時
        print("第",i,"個遊戲：")
        print(Game_list[i])
        # 3.Appsflyer：
        Appsflyer_data_list_sql[Game_list[i]] = """ 
                                                  SELECT * , LEFT(M.install_date,7) AS month
                                                  FROM analysis.mobile_game_af_marketing_cohort_2 M
                                                  LEFT JOIN analysis.country_name C
                                                  ON M.country_code = C.code
                                                  WHERE 1=1
                                                  AND install_date BETWEEN '%s' AND '%s'
                                                  AND group_id = '%s';
                                                  """%(Start_Date,End_Date,Game_list[i])
        
        Appsflyer_data_list[Game_list[i]] = get_mysql_data(sql = Appsflyer_data_list_sql[Game_list[i]])
        # 取得遊戲名稱：
        Appsflyer_data_list[Game_list[i]] = pd.merge(Appsflyer_data_list[Game_list[i]] , Marketing_game_name, left_on='group_id', right_on='marketing_group_id', how='left')
        # Join匯率資料：
        Appsflyer_data_list[Game_list[i]] = pd.merge(Appsflyer_data_list[Game_list[i]] , exchange_rate, on='month', how='left')
        # 遊戲原幣別：
        Appsflyer_data_list[Game_list[i]] = pd.merge(Appsflyer_data_list[Game_list[i]] , Game_currency, left_on='group_id', right_on='new_group_id_setting', how='left', indicator = True)
        Appsflyer_data_list[Game_list[i]]['new_group_id_USD'] = np.where(pd.notnull(Appsflyer_data_list[Game_list[i]]['id_y']),  'V' , 'X')
        # Appsflyer_data_list[Game_list[i]] = pd.assign('new_group_id_USD' = np.where([Appsflyer_data_list[Game_list[i]]['id_y'] is None] , 'V' , 'X')  )
        
        
        Appsflyer_data_list[Game_list[i]]['revenue'] = Appsflyer_data_list[Game_list[i]]['revenue'].astype(float)
        Appsflyer_data_list[Game_list[i]]['exchange_rate'] = Appsflyer_data_list[Game_list[i]]['exchange_rate'].astype(float)
    
        if np.unique(Appsflyer_data_list[Game_list[i]]['new_group_id_USD']) == 'V':
           Appsflyer_data_list[Game_list[i]]['revenue_USD'] = Appsflyer_data_list[Game_list[i]]['revenue']
           Appsflyer_data_list[Game_list[i]]['revenue_TWD'] = Appsflyer_data_list[Game_list[i]]['revenue']*Appsflyer_data_list[Game_list[i]]['exchange_rate']
    
        elif np.unique(Appsflyer_data_list[Game_list[i]]['new_group_id_USD']) == 'X':
             Appsflyer_data_list[Game_list[i]]['revenue_USD'] = Appsflyer_data_list[Game_list[i]]['revenue']/Appsflyer_data_list[Game_list[i]]['exchange_rate']
             Appsflyer_data_list[Game_list[i]]['revenue_TWD'] = Appsflyer_data_list[Game_list[i]]['revenue']
        else:
            print('====')
            
        time_end = time.time()    #結束計時
        time_c= time_end - time_start   #執行所花時間
        print('time cost', time_c, 's')
    
    # for i in range(len(Game_list)):
    #     globals()[Game_list[i]] = Appsflyer_data_list[Game_list[i]]
        
    
    # del Appsflyer_data_list ,  Appsflyer_data_list_sql , Game_currency , Game_currency_SQL
    # import gc
    # gc.collect()
    # 2021-07-19-更新程式
    # 把字典裡面的df進行cbind fill
    Game_data_device_third_TW = pd.DataFrame()
    for i in range(len(Game_list_Server_TW)):
        Game_data_device_third_TW = pd.concat( [Game_data_device_third_TW , Appsflyer_LTV_FN(df = Appsflyer_data_list[Game_list_Server_TW[i]][Appsflyer_data_list[Game_list_Server_TW[i]]['media_source'].isin(['facebook ads','googleadwords_int','organic'])] , group_by = ['group_id','marketing_group_name','channel','media_source','country_code','country_zhTW']).pipe(Appsflyer_LTV_Ratio_TW) ])
        print(Game_data_device_third_TW)
        
    Game_data_device_third = pd.DataFrame()
    for i in range(len(Game_list_Server_Non_TW)):
        Game_data_device_third = pd.concat( [Game_data_device_third , Appsflyer_LTV_FN(df = Appsflyer_data_list[Game_list_Server_Non_TW[i]][Appsflyer_data_list[Game_list_Server_Non_TW[i]]['media_source'].isin(['facebook ads','googleadwords_int','organic'])] , group_by = ['group_id','marketing_group_name','channel','media_source','country_code','country_zhTW']) ])
        print(Game_data_device_third)
    # union data 
    Game_data_device_third = pd.concat( [Game_data_device_third_TW , Game_data_device_third] , ignore_index=False).sort_values(by = ['group_id','channel','media_source','AF_Install'], ascending=False)
    # Game_data_device_third['update_time'] = pd.to_datetime(End_Date).to_pydatetime()  
    Game_data_device_third['update_time'] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # from datetime import datetime
    # day = datetime.strptime(End_Date, '%Y-%m-%d')
    # print(type(day))
    # print(day)
    # Game_data_device_third['update_time'] = pd.to_datetime(Game_data_device_third['update_time'], format='%Y-%m-%d %H:%M:%S')
    # Game_data_device_third['update_time'] = pd.to_datetime(Game_data_device_third['update_time'], errors='coerce')
    type(Game_data_device_third['update_time'])
    
   
   # 測試是否有無限大的欄位：   
   # Game_data_device_third.columns
   # np.isfinite(Game_data_device_third['LTV_180'])
   # T = Game_data_device_third[(np.isfinite(Game_data_device_third['LTV_180']))]
   
   # import numpy as np
   # Game_data_device_third['LTV_60'].value_counts()
   # Game_data_device_third.info()
   # np.isinf(Game_data_device_third['LTV_60'])
   
   # T = Game_data_device_third[np.isinf(Game_data_device_third['LTV_60'])] # 阿曼 -> LTV顯示inf (沒有安裝、有儲值)
   # 處理inf的數據
   Game_data_device_third.replace([np.inf, -np.inf], np.nan, inplace=True)

   

   
    # In[3.資料計算]
    
    # turn off code analysis feature in Spyder (pathperference / Completion and linting / Limiting / Enable basic linting )
    # Game_data_device_third = pd.concat( [Appsflyer_LTV_FN(df = ssrtw[ssrtw['media_source'].isin(['facebook ads','googleadwords_int','organic'])] , group_by = ['group_id','marketing_group_name','channel','media_source','country_code','country_zhTW']).pipe(Appsflyer_LTV_Ratio_TW)
    #                                    , Appsflyer_LTV_FN(df = ssr[ssr['media_source'].isin(['facebook ads','googleadwords_int','organic'])] , group_by = ['group_id','marketing_group_name','channel','media_source','country_code','country_zhTW']).pipe(Appsflyer_LTV_Ratio_US)
    #                                    , Appsflyer_LTV_FN(df = mt[mt['media_source'].isin(['facebook ads','googleadwords_int','organic'])] , group_by = ['group_id','marketing_group_name','channel','media_source','country_code','country_zhTW']).pipe(Appsflyer_LTV_Ratio_TW)
    #                                    , Appsflyer_LTV_FN(df = sl[sl['media_source'].isin(['facebook ads','googleadwords_int','organic'])] , group_by = ['group_id','marketing_group_name','channel','media_source','country_code','country_zhTW']).pipe(Appsflyer_LTV_Ratio_TW)
    #                                    , Appsflyer_LTV_FN(df = jiangdan[jiangdan['media_source'].isin(['facebook ads','googleadwords_int','organic'])] , group_by = ['group_id','marketing_group_name','channel','media_source','country_code','country_zhTW']).pipe(Appsflyer_LTV_Ratio_TW)
    #                                    , Appsflyer_LTV_FN(df = jiangdanen[jiangdanen['media_source'].isin(['facebook ads','googleadwords_int','organic'])] , group_by = ['group_id','marketing_group_name','channel','media_source','country_code','country_zhTW']).pipe(Appsflyer_LTV_Ratio_US)
    #                                    , Appsflyer_LTV_FN(df = jj[jj['media_source'].isin(['facebook ads','googleadwords_int','organic'])] , group_by = ['group_id','marketing_group_name','channel','media_source','country_code','country_zhTW']).pipe(Appsflyer_LTV_Ratio_TW)
    #                                    ] , ignore_index=False ).sort_values(by = ['group_id','channel','media_source','AF_Install'], ascending=False)
    
    
    # T = Game_data_device_third.query("group_id == 'jjna'")
    # In[4.df寫入db]
    
    # Connect to the database
    connection = pymysql.connect(host = config['db']['host']
                                , port = config['db']['port']
                                , user = config['db']['user']
                                , passwd = config['db']['pass']
                                , db = config['db']['name']
                                , charset = config['db']['DBMSencoding'])
    # create cursor
    cursor = connection.cursor()
    # nan to null 
    Game_data_device_third = Game_data_device_third.astype(object).where(pd.notnull(Game_data_device_third), "NULL")
    # creating column list for insertion
    cols = "`,`".join([str(i) for i in Game_data_device_third.columns.tolist()])
    # DUPLICATE_KEY_UPDATE 
    # Ps：Due to update mysql data , must using On duplicate key update all columns (like paste0 function in python ) 
    # Example：["s" + '(' + str(i) + ')' for i in range(1,11)]
    DUPLICATE_KEY_UPDATE_str = ",".join([ str(i) + ' = VALUES(' + str(i) + ')' for i in Game_data_device_third.columns.tolist() ])
    DUPLICATE_KEY_UPDATE_SQL = " ON DUPLICATE KEY UPDATE " + str(DUPLICATE_KEY_UPDATE_str)
    
    # Insert DataFrame recrds one by one.
    for i,row in Game_data_device_third.iterrows():
        sql = "INSERT INTO `mobile_game_LTV_Ratio` (`" +cols + "`) VALUES (" + "%s,"*(len(row)-1) + "%s)"
        # DUPLICATE_KEY_UPDATE_SQL = " ON DUPLICATE KEY UPDATE " + "group_id = VALUES(group_id) , channel = VALUES(channel)  , media_source = VALUES(media_source) , country_code = VALUES(country_code) , update_time = VALUES(update_time) ;"
        insert_SQL = sql + DUPLICATE_KEY_UPDATE_SQL
        cursor.execute(insert_SQL, tuple(row))
        # the connection is not autocommitted by default, so we must commit to save our changes
        connection.commit()
    
    # 程式結束時間：  
    # from datetime import datetime
    Stop_time = str(datetime.datetime.now())
    
    
    logger.info("mobile_game_LTV_Ratio.py 執行成功 \n StartDate:%s，EndDate:%s，資料時間為%s至%s"%(execute_time , Stop_time , Start_Date , End_Date ))

except Exception as e:
    logger.error("mobile_game_LTV_Ratio.py 執行失敗，錯誤訊息：", exc_info=True) 
    
    
    
    



    