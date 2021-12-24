# -*- coding: utf-8 -*-
"""
Created on Mon May 10 17:15:39 2021

@author: pc072
"""

# In[ Loding function ]

import pandas as pd
import numpy as np

# Loading function：
                             
def Appsflyer_LTV_FN(df,group_by):
    # group_by = ['channel','country_code','media_source']
    # 新增原幣別欄位：
    # df['revenue_Original'] = np.where(df.new_group_id_USD == 'V' , df.revenue_USD , df.revenue_TWD)
    df['revenue_Original'] = df.revenue_USD
    print('USD：',df.revenue_Original.value_counts(dropna=True)) 
    from datetime import date
    df['sys_diff_date'] = ((date.today() - df['install_date']).dt.days)
    # 時間相減：https://blog.csdn.net/lyzhanghh/article/details/108848479?utm_medium=distribute.pc_relevant.none-task-blog-baidujs_baidulandingword-0&spm=1001.2101.3001.4242
    # 計算安裝數條件：
    df['AF_Install'] = np.where( (df['diff_day'] == 0)  , df['dau'] , 0)
    # 計算LTV條件：
    # df['AF_Install_1'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 1), df['dau'] , 0)
    # df['AF_Install_2'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 2), df['dau'] , 0)
    # df['AF_Install_3'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 3), df['dau'] , 0)
    # df['AF_Install_4'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 4), df['dau'] , 0)
    # df['AF_Install_5'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 5), df['dau'] , 0)
    # df['AF_Install_6'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 6), df['dau'] , 0)
    # df['AF_Install_7'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 7), df['dau'] , 0)
    # df['AF_Install_14'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 14), df['dau'] , 0)
    df['AF_Install_30'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 30), df['dau'] , 0)
    df['AF_Install_60'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 60), df['dau'] , 0)
    df['AF_Install_90'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 90), df['dau'] , 0)
    df['AF_Install_120'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 120), df['dau'] , 0)
    df['AF_Install_150'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 150), df['dau'] , 0)
    df['AF_Install_180'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 180), df['dau'] , 0)
    df['AF_Install_210'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 210), df['dau'] , 0)
    df['AF_Install_240'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 240), df['dau'] , 0)
    df['AF_Install_270'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 270), df['dau'] , 0)
    df['AF_Install_300'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 300), df['dau'] , 0)
    df['AF_Install_330'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 330), df['dau'] , 0)
    df['AF_Install_360'] = np.where( (df['diff_day'] == 0)  & (df['sys_diff_date'] >= 360), df['dau'] , 0)
    
    # df['revenue_1'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 1) & (df['sys_diff_date'] >= 1), df['revenue_Original'] , 0)
    # df['revenue_2'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 2) & (df['sys_diff_date'] >= 2), df['revenue_Original'] , 0)
    # df['revenue_3'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 3) & (df['sys_diff_date'] >= 3), df['revenue_Original'] , 0)
    # df['revenue_4'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 4) & (df['sys_diff_date'] >= 4), df['revenue_Original'] , 0)
    # df['revenue_5'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 5) & (df['sys_diff_date'] >= 5), df['revenue_Original'] , 0)
    # df['revenue_6'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 6) & (df['sys_diff_date'] >= 6), df['revenue_Original'] , 0)
    # df['revenue_7'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 7) & (df['sys_diff_date'] >= 7), df['revenue_Original'] , 0)
    # df['revenue_14'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 14) & (df['sys_diff_date'] >= 14), df['revenue_Original'] , 0)
    df['revenue_30'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 30) & (df['sys_diff_date'] >= 30), df['revenue_Original'] , 0)
    df['revenue_60'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 60) & (df['sys_diff_date'] >= 60), df['revenue_Original'] , 0)
    df['revenue_90'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 90) & (df['sys_diff_date'] >= 90), df['revenue_Original'] , 0)
    df['revenue_120'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 120) & (df['sys_diff_date'] >= 120), df['revenue_Original'] , 0)
    df['revenue_150'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 150) & (df['sys_diff_date'] >= 150), df['revenue_Original'] , 0)
    df['revenue_180'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 180) & (df['sys_diff_date'] >= 180), df['revenue_Original'] , 0)
    df['revenue_210'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 210) & (df['sys_diff_date'] >= 210), df['revenue_Original'] , 0)
    df['revenue_240'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 240) & (df['sys_diff_date'] >= 240), df['revenue_Original'] , 0)
    df['revenue_270'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 270) & (df['sys_diff_date'] >= 270), df['revenue_Original'] , 0)
    df['revenue_300'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 300) & (df['sys_diff_date'] >= 300), df['revenue_Original'] , 0)
    df['revenue_330'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 330) & (df['sys_diff_date'] >= 330), df['revenue_Original'] , 0)
    df['revenue_360'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 360) & (df['sys_diff_date'] >= 360), df['revenue_Original'] , 0)
    # 2021-09-14 新增(IAA廣告營收)
    df['ad_revenue_30'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 30) & (df['sys_diff_date'] >= 30), df['ad_revenue'] , 0)
    df['ad_revenue_60'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 60) & (df['sys_diff_date'] >= 60), df['ad_revenue'] , 0)
    df['ad_revenue_90'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 90) & (df['sys_diff_date'] >= 90), df['ad_revenue'] , 0)
    df['ad_revenue_120'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 120) & (df['sys_diff_date'] >= 120), df['ad_revenue'] , 0)
    df['ad_revenue_150'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 150) & (df['sys_diff_date'] >= 150), df['ad_revenue'] , 0)
    df['ad_revenue_180'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 180) & (df['sys_diff_date'] >= 180), df['ad_revenue'] , 0)
    df['ad_revenue_210'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 210) & (df['sys_diff_date'] >= 210), df['ad_revenue'] , 0)
    df['ad_revenue_240'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 240) & (df['sys_diff_date'] >= 240), df['ad_revenue'] , 0)
    df['ad_revenue_270'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 270) & (df['sys_diff_date'] >= 270), df['ad_revenue'] , 0)
    df['ad_revenue_300'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 300) & (df['sys_diff_date'] >= 300), df['ad_revenue'] , 0)
    df['ad_revenue_330'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 330) & (df['sys_diff_date'] >= 330), df['ad_revenue'] , 0)
    df['ad_revenue_360'] = np.where( (df['diff_day'] > 0) & (df['diff_day'] <= 360) & (df['sys_diff_date'] >= 360), df['ad_revenue'] , 0)
    
    # 分組聚合 & 計算LTV (.agg fn：無法判斷條件後進行加總，必須先創加總欄位後再進行加總。)
    Data = df.groupby(group_by).agg({ 'AF_Install' :np.sum 
                                    # Installs cohort：
                                    # , 'AF_Install_1' :np.sum 
                                    # , 'AF_Install_2' :np.sum 
                                    # , 'AF_Install_3' :np.sum 
                                    # , 'AF_Install_4' :np.sum 
                                    # , 'AF_Install_5' :np.sum 
                                    # , 'AF_Install_6' :np.sum 
                                    # , 'AF_Install_7' :np.sum 
                                    # , 'AF_Install_14' :np.sum 
                                    , 'AF_Install_30' :np.sum 
                                    , 'AF_Install_60' :np.sum 
                                    , 'AF_Install_90' :np.sum 
                                    , 'AF_Install_120' :np.sum 
                                    , 'AF_Install_150' :np.sum 
                                    , 'AF_Install_180' :np.sum 
                                    , 'AF_Install_210' :np.sum 
                                    , 'AF_Install_240' :np.sum 
                                    , 'AF_Install_270' :np.sum 
                                    , 'AF_Install_300' :np.sum 
                                    , 'AF_Install_330' :np.sum 
                                    , 'AF_Install_360' :np.sum 
                                    # revenue cohort：
                                    # , 'revenue_1' :np.sum 
                                    # , 'revenue_2' :np.sum 
                                    # , 'revenue_3' :np.sum 
                                    # , 'revenue_4' :np.sum 
                                    # , 'revenue_5' :np.sum 
                                    # , 'revenue_6' :np.sum 
                                    # , 'revenue_7' :np.sum 
                                    # , 'revenue_14' :np.sum 
                                    , 'revenue_30' :np.sum 
                                    , 'revenue_60' :np.sum 
                                    , 'revenue_90' :np.sum
                                    , 'revenue_120' :np.sum 
                                    , 'revenue_150' :np.sum
                                    , 'revenue_180' :np.sum
                                    , 'revenue_210' :np.sum 
                                    , 'revenue_240' :np.sum 
                                    , 'revenue_270' :np.sum
                                    , 'revenue_300' :np.sum 
                                    , 'revenue_330' :np.sum
                                    , 'revenue_360' :np.sum
                                    # 2021-09-14 新增(IAA廣告營收)
                                    , 'ad_revenue_30' :np.sum 
                                    , 'ad_revenue_60' :np.sum 
                                    , 'ad_revenue_90' :np.sum
                                    , 'ad_revenue_120' :np.sum 
                                    , 'ad_revenue_150' :np.sum
                                    , 'ad_revenue_180' :np.sum
                                    , 'ad_revenue_210' :np.sum 
                                    , 'ad_revenue_240' :np.sum 
                                    , 'ad_revenue_270' :np.sum
                                    , 'ad_revenue_300' :np.sum 
                                    , 'ad_revenue_330' :np.sum
                                    , 'ad_revenue_360' :np.sum
                                    }).reset_index()
    # LTV
    # Data['LTV_1'] = Data['revenue_1'] / Data['AF_Install_1']
    # Data['LTV_2'] = Data['revenue_2'] / Data['AF_Install_2']
    # Data['LTV_3'] = Data['revenue_3'] / Data['AF_Install_3']
    # Data['LTV_4'] = Data['revenue_4'] / Data['AF_Install_4']
    # Data['LTV_5'] = Data['revenue_5'] / Data['AF_Install_5']
    # Data['LTV_6'] = Data['revenue_6'] / Data['AF_Install_6']
    # Data['LTV_7'] = Data['revenue_7'] / Data['AF_Install_7']
    # Data['LTV_14'] = Data['revenue_14'] / Data['AF_Install_14']
    Data['LTV_30'] = Data['revenue_30'] / Data['AF_Install_30']
    Data['LTV_60'] = Data['revenue_60'] / Data['AF_Install_60']
    Data['LTV_90'] = Data['revenue_90'] / Data['AF_Install_90']
    Data['LTV_120'] = Data['revenue_120'] / Data['AF_Install_120']
    Data['LTV_150'] = Data['revenue_150'] / Data['AF_Install_150']
    Data['LTV_180'] = Data['revenue_180'] / Data['AF_Install_180']
    Data['LTV_210'] = Data['revenue_210'] / Data['AF_Install_210']
    Data['LTV_240'] = Data['revenue_240'] / Data['AF_Install_240']
    Data['LTV_270'] = Data['revenue_270'] / Data['AF_Install_270']
    Data['LTV_300'] = Data['revenue_300'] / Data['AF_Install_300']
    Data['LTV_330'] = Data['revenue_330'] / Data['AF_Install_330']
    Data['LTV_360'] = Data['revenue_360'] / Data['AF_Install_360']
    return Data

def Appsflyer_LTV_Ratio_TW(df):
    # 計算LTV Ratio    
    M = df[df['media_source'].isin(['facebook ads','googleadwords_int','organic'])]['media_source'].drop_duplicates().values.tolist()
    data = {}
    # M = ['facebook ads','googleadwords_int','organic'] 
    # C = ['apple','google']
    # print(C , M)
    for i in range(len(M)): 
        # 資料範圍要一致，例如：google廣告只有投放IOS，就不會有Google_Andriod廣告數據，若C寫再外層，則產生空資料。
        C = df[(df['media_source'] == M[i]) & (df['channel'].isin(['apple','google']))]['channel'].drop_duplicates().values.tolist()
        for j in range(len(C)):
            print(M[i]+'_'+C[j])
            if df[(df['channel'] == C[j]) & (df['media_source'] == M[i] ) & df['country_code'].isin(['TW'])].pipe(len) == 0:
               TW_LTV = df[(df['channel'] == C[j]) & (df['media_source'] == M[i] ) ].sort_index(by='AF_Install',ascending=False).head(1)
            else:
               TW_LTV = df[(df['channel'] == C[j]) & (df['media_source'] == M[i] ) & (df['country_code'] == 'TW') ]
            # print(TW_LTV)
            data[M[i]+'_'+C[j]] = df[(df['channel'] == C[j]) & (df['media_source'] == M[i] ) ]
            data[M[i]+'_'+C[j]]['Ratio_30'] = data[M[i]+'_'+C[j]]['LTV_30'] / np.where( TW_LTV['LTV_30'].values[0] ==0 , np.nan ,TW_LTV['LTV_30'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_60'] = data[M[i]+'_'+C[j]]['LTV_60'] / np.where( TW_LTV['LTV_60'].values[0] ==0 , np.nan ,TW_LTV['LTV_60'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_90'] = data[M[i]+'_'+C[j]]['LTV_90'] / np.where( TW_LTV['LTV_90'].values[0] ==0 , np.nan ,TW_LTV['LTV_90'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_120'] = data[M[i]+'_'+C[j]]['LTV_120'] / np.where( TW_LTV['LTV_120'].values[0] ==0 , np.nan ,TW_LTV['LTV_120'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_150'] = data[M[i]+'_'+C[j]]['LTV_150'] / np.where( TW_LTV['LTV_150'].values[0] ==0 , np.nan ,TW_LTV['LTV_150'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_180'] = data[M[i]+'_'+C[j]]['LTV_180'] / np.where( TW_LTV['LTV_180'].values[0] ==0 , np.nan ,TW_LTV['LTV_180'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_210'] = data[M[i]+'_'+C[j]]['LTV_210'] / np.where( TW_LTV['LTV_210'].values[0] ==0 , np.nan ,TW_LTV['LTV_210'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_240'] = data[M[i]+'_'+C[j]]['LTV_240'] / np.where( TW_LTV['LTV_240'].values[0] ==0 , np.nan ,TW_LTV['LTV_240'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_270'] = data[M[i]+'_'+C[j]]['LTV_270'] / np.where( TW_LTV['LTV_270'].values[0] ==0 , np.nan ,TW_LTV['LTV_270'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_300'] = data[M[i]+'_'+C[j]]['LTV_300'] / np.where( TW_LTV['LTV_300'].values[0] ==0 , np.nan ,TW_LTV['LTV_300'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_330'] = data[M[i]+'_'+C[j]]['LTV_330'] / np.where( TW_LTV['LTV_330'].values[0] ==0 , np.nan ,TW_LTV['LTV_330'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_360'] = data[M[i]+'_'+C[j]]['LTV_360'] / np.where( TW_LTV['LTV_360'].values[0] ==0 , np.nan ,TW_LTV['LTV_360'].values[0] )
            # data_D = {}
            # data_D[M[i]+C[j]] = data
    # return data
    return pd.concat(data, ignore_index=False)

def Appsflyer_LTV_Ratio_US(df):
    # 計算LTV Ratio    
    M = df[df['media_source'].isin(['facebook ads','googleadwords_int','organic'])]['media_source'].drop_duplicates().values.tolist()
    data = {}
    for i in range(len(M)): 
        # 資料範圍要一致，例如：google廣告只有投放IOS，就不會有Google_Andriod廣告數據，若C寫再外層，則產生空資料。
        C = df[(df['media_source'] == M[i]) & (df['channel'].isin(['apple','google']))]['channel'].drop_duplicates().values.tolist()
        for j in range(len(C)):
            print(M[i]+'_'+C[j])
            if df[(df['channel'] == C[j]) & (df['media_source'] == M[i] ) & df['country_code'].isin(['US'])].pipe(len) == 0:
               TW_LTV = df[(df['channel'] == C[j]) & (df['media_source'] == M[i] ) ].sort_index(by='AF_Install',ascending=False).head(1)
            else:
               TW_LTV = df[(df['channel'] == C[j]) & (df['media_source'] == M[i] ) & (df['country_code'] == 'US') ]
               
            data[M[i]+'_'+C[j]] = df[(df['channel'] == C[j]) & (df['media_source'] == M[i] ) ]
            data[M[i]+'_'+C[j]]['Ratio_30'] = data[M[i]+'_'+C[j]]['LTV_30'] / np.where( TW_LTV['LTV_30'].values[0] ==0 , np.nan ,TW_LTV['LTV_30'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_60'] = data[M[i]+'_'+C[j]]['LTV_60'] / np.where( TW_LTV['LTV_60'].values[0] ==0 , np.nan ,TW_LTV['LTV_60'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_90'] = data[M[i]+'_'+C[j]]['LTV_90'] / np.where( TW_LTV['LTV_90'].values[0] ==0 , np.nan ,TW_LTV['LTV_90'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_120'] = data[M[i]+'_'+C[j]]['LTV_120'] / np.where( TW_LTV['LTV_120'].values[0] ==0 , np.nan ,TW_LTV['LTV_120'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_150'] = data[M[i]+'_'+C[j]]['LTV_150'] / np.where( TW_LTV['LTV_150'].values[0] ==0 , np.nan ,TW_LTV['LTV_150'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_180'] = data[M[i]+'_'+C[j]]['LTV_180'] / np.where( TW_LTV['LTV_180'].values[0] ==0 , np.nan ,TW_LTV['LTV_180'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_210'] = data[M[i]+'_'+C[j]]['LTV_210'] / np.where( TW_LTV['LTV_210'].values[0] ==0 , np.nan ,TW_LTV['LTV_210'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_240'] = data[M[i]+'_'+C[j]]['LTV_240'] / np.where( TW_LTV['LTV_240'].values[0] ==0 , np.nan ,TW_LTV['LTV_240'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_270'] = data[M[i]+'_'+C[j]]['LTV_270'] / np.where( TW_LTV['LTV_270'].values[0] ==0 , np.nan ,TW_LTV['LTV_270'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_300'] = data[M[i]+'_'+C[j]]['LTV_300'] / np.where( TW_LTV['LTV_300'].values[0] ==0 , np.nan ,TW_LTV['LTV_300'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_330'] = data[M[i]+'_'+C[j]]['LTV_330'] / np.where( TW_LTV['LTV_330'].values[0] ==0 , np.nan ,TW_LTV['LTV_330'].values[0] )
            data[M[i]+'_'+C[j]]['Ratio_360'] = data[M[i]+'_'+C[j]]['LTV_360'] / np.where( TW_LTV['LTV_360'].values[0] ==0 , np.nan ,TW_LTV['LTV_360'].values[0] )
    return pd.concat(data, ignore_index=False)



