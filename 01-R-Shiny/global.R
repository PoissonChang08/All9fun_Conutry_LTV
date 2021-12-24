
# === Start ===
# 主程式 國家成效-出價決策評估 (global)
# 維護者: VIncent Chang
# 更新日期: 2021-04-09
# === End ===


# VIncent Chang





#### ====== 1.Loading packages ====== ####

library(dplyr)
library(rstudioapi)
library(openxlsx)
library(shinydashboard)
library(shiny)
library(dashboardthemes)
library(shinycssloaders)


#### ====== END ====== ####


#### ====== 2.Loading FN ====== ####

# DT::datatable (language)
Lagguage_list <- function(){
  language = list(
                  processing="處理中...",
                  loadingRecords="載入中...",
                  lengthMenu="顯示 _MENU_ 項結果",
                  zeroRecords="沒有符合的結果",
                  info="顯示第 _START_ 至 _END_ 項結果，共 _TOTAL_ 項",
                  infoEmpty="顯示第 0 至 0 項結果，共 0 項",
                  infoFiltered="(從 _MAX_ 項結果中過濾)",
                  infoPostFix="",
                  search="搜尋:",
                  paginate=list(first="第一頁",previous="上一頁",`next`="下一頁",last="最後一頁"),
                  aria=list(sortAscending=": 升冪排列",sortDescending=": 降冪排列"))
}

# DT：DataTable (format)
DT_All_fn <- function(data){

  # 資料欄位數
  data_nrow <- ncol(data)-1
  print(data_nrow)

  # data input DT (datatable)
  data %<>% DT::datatable(    rownames = FALSE
                            , extensions = c('Buttons','RowGroup','Scroller')
                            , escape = FALSE
                            , filter = list(position = 'top' , plain = TRUE)
                            , selection = 'multiple'
                            # , style = 'bootstrap'
                            , class = 'cell-border stripe'
                            , options = list(
                              # lengthMenu=list(c(5,15,20),c('5','15','20'))
                              # , pageLength = 1000
                              dom = 'Blfrtip'
                              # , fixedColumns = list(leftColumns = 3 , heightMatch = 2 )  # fix column , rightColumns = 2
                              , buttons = list(
                                # 篩選欄位
                                list(extend = "colvis" , columns = c(0:data_nrow) ,
                                     text = "篩選欄位"),
                                # 檔案下載
                                list(extend = 'excel',charset = 'Big5',text = '檔案下載') ) # datatable 自動下載excel參數。
                              # 語言顯示
                              , language = Lagguage_list()
                              , initComplete = JS(
                                                "function(settings, json) {",
                                                "$(this.api().table().header()).css({'background-color': '#F0F0F0', 'color': '#003366'})
                                                // 1.改指定顏色
                                                var obj = $(this.api().table().header());
                                                for(var i = 0; i <=5; i++) {
                                                // change color here
                                                console.log(i);
                                                var thObj = $(obj).find('tr th').eq(i);
                                                $(thObj).css({'background-color': '#95CACA', 'color': '#003366'});
                                                }
                                                // 2.改指定顏色
                                                var obj = $(this.api().table().header());
                                                for(var i = 6; i <=100; i++) {
                                                // change color here
                                                console.log(i);
                                                var thObj = $(obj).find('tr th').eq(i);
                                                $(thObj).css({'background-color': '#CDCD9A', 'color': '#003060'});
                                                }
                                                ;",
                                                "}")
                              , columnDefs=list(# 欄位名稱置中
                                list(className='dt-center',targets= c(0:data_nrow) )
                              , list(targets = c(6:data_nrow), searchable = FALSE) # 設定不可Filter欄位(各遊戲)
                                # , list(targets=c(6),width="1%")
                                # , list(targets=c(0:1),width="80px")
                                # , list(targets=c(5:6),width="140px")
                                # , list(targets = c(2:4), searchable = FALSE)
                                # , list(visible = FALSE, targets =  c(5:8))
                              )
                              , rowGroup = list(dataSrc = 2) # 分組(根據手機系統)
                              # , scrollX = TRUE # 放在Shiny的時候，必須開啟TRUE，X軸才能拖拉。
                              # , deferRender = TRUE
                              # , scrollY = 650
                              # , scroller = TRUE
                              # , scrollCollapse = TRUE
                              , paging=FALSE
                              # , fixedColumns = TRUE
                              # , fixedHeader = F
                              # Sorting
                              , order = list(list(2, 'desc')) # 排序(根據手機系統)
                            )
                            )
  return(data)
  }
DT_fn <- function(data){

  # 資料欄位數
  data_nrow <- ncol(data)-1
  print(data_nrow)

  # data input DT (datatable)
  data %<>% DT::datatable(  rownames = FALSE
                            , extensions = c('FixedColumns','Buttons','RowGroup','Scroller')
                            , escape = FALSE

                            , filter = list(position = 'top', plain = TRUE)
                            , selection = 'multiple'
                            # , style = 'bootstrap'
                            , class = 'cell-border stripe'
                            , options = list(
                              #   lengthMenu=list(c(5,15,20),c('5','15','20'))
                              # , pageLength = 1000
                              dom = 'Blfrtip'
                              # , fixedColumns = list(leftColumns = 3 , heightMatch = 2 )  # fix column , rightColumns = 2
                              , buttons = list(
                                # 篩選欄位
                                list(extend = "colvis" , columns = c(0:data_nrow) , # 設定可篩選的欄位。(平台、各遊戲)
                                     text = "篩選欄位"),
                                # 檔案下載
                                list(extend = 'excel',charset = 'Big5',text = '檔案下載')) # datatable 自動下載excel參數。
                              # 語言顯示
                              , language = Lagguage_list()
                              , initComplete = JS(
                                "function(settings, json) {",
                                "$(this.api().table().header()).css({'background-color': '#F0F0F0', 'color': '#003366'})
                                  // 1.改指定顏色
                                  var obj = $(this.api().table().header());
                                  for(var i = 0; i <=1; i++) {
                                  // change color here
                                  console.log(i);
                                  var thObj = $(obj).find('tr th').eq(i);
                                  $(thObj).css({'background-color': '#95CACA', 'color': '#003060'});
                                  }
                                  // 2.改指定顏色
                                  var obj = $(this.api().table().header());
                                  for(var i = 2; i <=100; i++) {
                                  // change color here
                                  console.log(i);
                                  var thObj = $(obj).find('tr th').eq(i);
                                  $(thObj).css({'background-color': '#CDCD9A', 'color': '#003060'});
                                  }
                                  ;",
                                "}")
                              , columnDefs=list(# 欄位名稱置中
                                list(className='dt-center',targets= c(0:data_nrow) )
                                , list(visible = FALSE, targets = c(0)) # 隱藏欄位(平台)
                                , list(targets = c(3:data_nrow), searchable = FALSE) # 設定不可Filter欄位(各遊戲)
                                # , list(targets=c(6),width="1%")
                                # , list(targets=c(0:1),width="80px")
                                # , list(targets=c(5:6),width="140px")
                                # , list(targets = c(2:4), searchable = FALSE)
                                # , list(visible = FALSE, targets =  c(0))
                              )
                              , rowGroup = list(dataSrc = 0)
                              # , scrollX = TRUE
                              , deferRender = TRUE
                              , scrollY = 700
                              , scroller = TRUE
                              # , scrollCollapse = TRUE
                              # , paging=FALSE
                              # , fixedColumns = TRUE
                              # , fixedHeader = F
                              # Sorting
                              , order = list(list(0, 'desc'))
                            )
  )
  return(data)
}


# pickerInput-options
pickerInput_options <- function(){
  list( `actions-box` = TRUE
        # , header = p("可收尋您想要的遊戲", style="color:#191970; font-size:16px; text-align:center; font-weight:bold;")
        , title = "不篩選"
        ,`selected-text-format` = "count > 0"
        ,`count-selected-text` = "{0} 個項目被選取 (全部：{1})"
        # ,`none-selected-text` = "不篩選"
        ,`deselect-all-text` = "全取消"
        ,`select-all-text` = "全選"
        ,`live-search`=TRUE # Search content
        # , style = "btn btn-light"
    )
}

#### ====== END ====== ####




# ---- Metadata ----
META <- list(
  # Name of the app, used in the browser/tab title
  name        = "rstudio::conf(\'tweets\')",
  # A description of the app, used in social media cards
  description = "A Shiny Dashboard, rstudio::conf #FOMO reducer, tweet explorer by @grrrck",
  # Link to the app, used in social media cards
  app_url     = "https://apps.garrickadenbuie.com/rstudioconf-2019/",
  # Link to app icon image, used in social media cards
  app_icon    = "https://garrickadenbuie.com/images/2019/rstudioconf-2019-icon.png",
  # The name of the conference or organization
  conf_org    = "rstudio::conf",
  # App title, long, shown when sidebar is open, HTML is valid
  logo_lg     = "<em>rstudio</em>::<strong>conf</strong>(2019)",
  # App title, short, shown when sidebar is collapsed, HTML is valid
  logo_mini   = "<em>rs</em><strong>c</strong>",
  # Icon for box with count of conference-related tweets
  topic_icon  = "comments",
  # Icon for box with count of "community"-related tweets
  topic_icon_full = "r-project",
  # AdminLTE skin color for the dashboard
  skin_color  = "blue-light",
  # AdminLTE theme CSS files
  theme_css   = c("ocean-next/AdminLTE.css", "ocean-next/_all-skins.css")
)



#### ====== END ====== ####





