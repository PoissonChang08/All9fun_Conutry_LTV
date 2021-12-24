# In[ Loding packages ]
import pymysql
import pandas as pd
import yaml

# read config file
f = open('C:\\Users\\pc072\\Desktop\\Poisson\\Project\\fb_Tag_analysis\\Mysql_gameDB.yml', 'r',encoding="utf-8")
# f = open('/home/poisson/Mysql_gameDB.yml', 'r',encoding="utf-8")
config = yaml.load(f, Loader=yaml.FullLoader)


# In[DB_fn]


def get_mysql_data(sql):
    """
    提取mysql中的資料並返回成dataframe
    引數只需要sql語句

    """
    # 資料庫連線：
    conn_db = pymysql.connect(host = config['db']['host']
                            , port = config['db']['port']
                            , user = config['db']['user']
                            , passwd = config['db']['pass']
                            , db = config['db']['name']
                            , charset = config['db']['DBMSencoding'])
    
    cur = conn_db.cursor()  # 獲取操作遊標，也就是開始操作
    cur.execute(sql)  # 執行查詢語句

    result = cur.fetchall()  # 獲取查詢結果    
    columnDes = cur.description #获取连接对象的描述信息
    # print(columnDes)
    columnNames = [columnDes[i][0] for i in range(len(columnDes))]
    # print(columnNames)
    result = pd.DataFrame([list(i) for i in result],columns=columnNames)

    # result = pd.DataFrame(list(result)) # 將tulple轉為df

    # 參考網站：https://stackoverflow.com/questions/33700626/how-to-convert-tuple-of-tuples-to-pandas-dataframe-in-python
    # 參考網站：https://blog.csdn.net/kl28978113/article/details/90607361?utm_medium=distribute.pc_relevant.none-task-blog-baidujs_title-0&spm=1001.2101.3001.4242
    
#    col_result = cur.description  # 獲取查詢結果的欄位描述


#    # 1.建立一個空的list (columns)
#    columns = []
#    for i in range(len(col_result)):
#        columns.append(col_result[i][0])  
#    # 2.建立一個空的df，把list欄位帶入df
#    df = pd.DataFrame(columns=columns)
#    # 3.把Tuple數據一筆一筆塞進去 df
#    for i in range(len(result)):
#        df.loc[i] = list(result[i])  # 按行插入查詢到的資料

    conn_db.close()  # 關閉資料庫連線
    return result


