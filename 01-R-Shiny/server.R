
# === Start ===
# 主程式 國家成效-出價決策評估 (server)
# 維護者: VIncent Chang
# 更新日期: 2021-04-09
# === End ===


# VIncent Chang



# server  ==================================================

server <- function(input, output , session) {


  # 1.Loding Data
  Row_Data <- reactive({

    # Loading Data --
    setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
    # LTV_Ratio_uid_third <- openxlsx::read.xlsx("F:/02_Cm_Cube Magic INC/Poisson/Project/育駿公司-專案報告/2020-10-23-各遊戲-國家LTV數據整併/2021-04-09_LTV_Ratio_Game_data_uid_third.xlsx", sheet = 1 , startRow = 1, colNames = TRUE) %>% as.data.frame(stringsAsFactors = FALSE)
    LTV_Ratio_uid_third <- openxlsx::read.xlsx("2021-12-22_LTV_Ratio_Game_data_device_third.xlsx", sheet = 1 , startRow = 1, colNames = TRUE) %>% as.data.frame(stringsAsFactors = FALSE)

    # 1.原始數據：
    # 挑選所需欄位
    LTV_Ratio_uid_third %<>% dplyr::select(-c('X1','X2'))
    # 篩選樣本：
    LTV_Ratio_uid_third %<>% dplyr::filter(AF_Install >= input$AF_installs)

    # channel - 更換資料代碼
    LTV_Ratio_uid_third %<>% dplyr::mutate('channel' = ifelse(channel=='google','Android',ifelse(channel=='apple','IOS','Other')))

    # 更換資料格式：
    LTV_Ratio_uid_third[,'group_id'] %<>% as.factor()
    LTV_Ratio_uid_third[,'marketing_group_name'] %<>% as.factor()
    LTV_Ratio_uid_third[,'channel'] %<>% as.factor()
    LTV_Ratio_uid_third[,'country_code'] %<>% as.factor()
    LTV_Ratio_uid_third[,'country_zhTW'] %<>% as.factor()
    LTV_Ratio_uid_third[,'media_source'] %<>% as.factor()

    # 更換欄位名稱：
    names(LTV_Ratio_uid_third)[names(LTV_Ratio_uid_third)=="group_id"] <- "遊戲代碼"
    names(LTV_Ratio_uid_third)[names(LTV_Ratio_uid_third)=="marketing_group_name"] <- "遊戲名稱"
    names(LTV_Ratio_uid_third)[names(LTV_Ratio_uid_third)=="channel"] <- "系統"
    names(LTV_Ratio_uid_third)[names(LTV_Ratio_uid_third)=="country_code"] <- "國家代碼"
    names(LTV_Ratio_uid_third)[names(LTV_Ratio_uid_third)=="country_zhTW"] <- "國家名稱"
    names(LTV_Ratio_uid_third)[names(LTV_Ratio_uid_third)=="media_source"] <- "媒體渠道"

    Data_output <- list(LTV_Ratio_uid_third)
    return(Data_output)

  })
  # 2.Data format
  Data_output <- reactive({
    # 篩選條件
    if(input$Indicator == 'LTV'){
      LTV_Ratio_uid_third <- Row_Data()[[1]]
      LTV_Ratio_uid_third %<>% dplyr::filter(遊戲代碼 %in% (input$Main_Game))
      LTV_Ratio_uid_third %<>% dplyr::filter(國家代碼 %in% (input$Main_Country))
      LTV_Ratio_uid_third %<>% dplyr::filter(媒體渠道 %in% (input$Main_media_source))
      LTV_Ratio_uid_third %<>% dplyr::select(c('遊戲代碼','遊戲名稱','系統','國家代碼','國家名稱','媒體渠道','AF_Install'),contains("LTV"))
      Row <- LTV_Ratio_uid_third %>% DT_All_fn() %>%
              DT::formatRound(c('LTV_30','LTV_60','LTV_90','LTV_120','LTV_150','LTV_180'),digits = 2) %>%
              DT::formatCurrency(c('AF_Install'), currency = "", interval = 3, mark = ",", digits = 0) %>%
              DT::formatStyle(c('AF_Install'),'text-align' = 'right')

    } else if(input$Indicator == 'Ratio') {
      LTV_Ratio_uid_third <- Row_Data()[[1]]
      LTV_Ratio_uid_third %<>% dplyr::filter(遊戲代碼 %in% (input$Main_Game))
      LTV_Ratio_uid_third %<>% dplyr::filter(國家代碼 %in% (input$Main_Country))
      LTV_Ratio_uid_third %<>% dplyr::filter(媒體渠道 %in% (input$Main_media_source))
      LTV_Ratio_uid_third %<>% dplyr::select(c('遊戲代碼','遊戲名稱','系統','國家代碼','國家名稱','媒體渠道','AF_Install'),contains("Ratio_"))
      Row <- LTV_Ratio_uid_third %>% DT_All_fn() %>%
              DT::formatRound(c('Ratio_30','Ratio_60','Ratio_90','Ratio_120','Ratio_150','Ratio_180'),digits = 2) %>%
              DT::formatCurrency(c('AF_Install'), currency = "", interval = 3, mark = ",", digits = 0) %>%
              DT::formatStyle(c('AF_Install'),'text-align' = 'right') %>%
              DT::formatStyle(c('Ratio_30','Ratio_60','Ratio_90','Ratio_120','Ratio_150','Ratio_180') ,  color = DT::styleInterval(c(0.999, 1.00001) , c('#930000','#000000','#467500') ), fontWeight = 'bold' )

    } else if(input$Indicator == 'LTV_Ratio_90') {
      LTV_Ratio_uid_third <- Row_Data()[[1]]

      LTV_Ratio_uid_third %<>% dplyr::filter(遊戲代碼 %in% (input$Main_Game))
      LTV_Ratio_uid_third %<>% dplyr::filter(國家代碼 %in% (input$Main_Country))
      LTV_Ratio_uid_third %<>% dplyr::filter(媒體渠道 %in% (input$Main_media_source))
      LTV_Ratio_uid_third %<>% dplyr::select(c('遊戲代碼','遊戲名稱','系統','國家代碼','國家名稱','媒體渠道','AF_Install','AF_Install_90','Ratio_90'))
      Row <- LTV_Ratio_uid_third %>% DT_All_fn() %>%
              DT::formatRound(c('Ratio_90'),digits = 2) %>%
              DT::formatCurrency(c('AF_Install','AF_Install_90'), currency = "", interval = 3, mark = ",", digits = 0) %>%
              DT::formatStyle(c('AF_Install','AF_Install_90'),'text-align' = 'right') %>%
              DT::formatStyle(c('Ratio_90') ,  color = DT::styleInterval(c(0.999, 1.00001) , c('#930000','#000000','#467500') ), fontWeight = 'bold' )

      }
    return(Row)
  })
  spread_output <- reactive({
    LTV_Ratio_uid_third_spread <- Row_Data()[[1]]
    LTV_Ratio_uid_third_spread %<>% dplyr::filter(遊戲代碼 %in% (input$Main_Game))
    LTV_Ratio_uid_third_spread %<>% dplyr::filter(國家代碼 %in% (input$Main_Country))
    LTV_Ratio_uid_third_spread %<>% dplyr::filter(媒體渠道 %in% (input$Main_media_source))
    # 2.轉置後數據：
    S_value = paste0(input$Indicator,'_',input$Day)
    # S_value = c('Ratio_90')
    S_key = '遊戲名稱'
    LTV_Ratio_uid_third_spread %<>% dplyr::select(c('遊戲名稱','系統','國家代碼','國家名稱','媒體渠道',S_value)) %>%
                                    tidyr::spread(key = S_key , value = S_value )
    LTV_Ratio_uid_third_spread %<>% dplyr::select(-c('國家代碼'))
    LTV_Ratio_uid_third_spread %<>% DT_fn() %>%
                                    DT::formatRound(c(4:ncol(LTV_Ratio_uid_third_spread)),digits = 2) %>%
                                    DT::formatStyle(c(4:ncol(LTV_Ratio_uid_third_spread)) , color = DT::styleInterval(c(0.999, 1.00001) , c('#930000','#000000','#467500') ), fontWeight = 'bold' )
    return(LTV_Ratio_uid_third_spread)
  })

  # 3.Table_Output
  # a.Row table
  output_table <- reactive({
    # 若是『多遊戲、多國家』就呈現特殊表格：
    if(input$Data_direction == 'Game_Country'){
        table <- spread_output()
        shinyjs::show("Day") # 顯示天數選項
    } else {
      table <- Data_output()
      shinyjs::hide("Day") # 隱藏天數選項
      }
    return(table)
  })

  output$Row_table <- DT::renderDataTable({ output_table() })
  # b.spread table
  # output$spread_table <- DT::renderDataTable({ spread_output() })

  # description
  output$description <- renderUI({
    gradientBox(
                title = "Description",
                width = 6,
                icon = "fa fa-heart",
                gradientColor = "teal",
                boxToolSize = "xs",
                closable = F,
                footer =
                div(
                  # Dashboard
                  p("國別LTV Dashboard：", style="font-size:150%;color:#191970; font-weight:bold"),
                  p("★ 報表為評估各遊戲多國家之LTV，協助後續廣告決策評估。"),
                  p("★ 評估方式：根據國家的LTV，決定廣告CPI的出價水準。"),
                  p("★ Ratio意義：將膽在香港的Ratio_90：6.35，表示香港90天LTV優於台灣6.35倍。"),
                  p("★ Ratio顏色：大於1：綠色，小於1：紅色。"),
                  # 動機
                  p("動機：", style="font-size:150%;color:#191970; font-weight:bold"),
                  p("★ 當公司新的遊戲即將上線時，尚未有新遊戲的廣告數據能參考，若能彙整過去遊戲的廣告投放數據，將是不錯的參考依據。"),
                  # 資料來源
                  p("資料來源：", style="font-size:150%;color:#191970; font-weight:bold"),
                  p(img(src="FB_Icon.png", height = 25 , width= 25),"Facebook 廣告API",
                    img(src="Googel.png", height = 35 , width= 35),"Google 廣告API",
                    img(src="Appsflyer_icon.jpg", height = 55 , width= 100),"Appsflyer第三方數據"),
                  # developmer
                  p("開發者：", style="font-size:150%;color:#191970; font-weight:bold"),
                  div(p("Vincent Chang | Data Scientist @"
                    , tags$a("facebook", href = 'https://www.facebook.com/profile.php?id=100001691559184', target="_blank") ,' | '
                    , tags$a("instagram", href = 'https://www.instagram.com/developme223', target="_blank"))),
                  p("註：若有任何的建議可e-mail與我聯絡唷，謝謝！")
                    # , img(src="cmi_logo_black.png", height = 120 , width= 120)
                    , style="color:#000000; font-weight:normal"),

                  "功能介紹"
      )
  })


  # UI update_Main_condition (更新遊戲、渠道、平台 -篩選條件) ==
  observe({
    # Loading Data --
    # setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
    LTV_Ratio_uid_third <- openxlsx::read.xlsx("2021-12-22_LTV_Ratio_Game_data_device_third.xlsx", sheet = 1 , startRow = 1, colNames = TRUE) %>% as.data.frame(stringsAsFactors = FALSE)
    LTV_Ratio_uid_third %<>% dplyr::mutate('media_source_name' = ifelse(media_source=='organic','自然流量分析',ifelse(media_source=='googleadwords_int','Google 廣告',ifelse(media_source=='facebook ads','FB 廣告','-'))))
    Data <- LTV_Ratio_uid_third
    # Data %>% names()
    # Data$media_source %>% unique()

    # 1.遊戲
    marketing_group_id_update <- Data$group_id %>% unique() %>% t()
    marketing_group_name_update <- Data$marketing_group_name %>% unique() %>% t()
    # 顯示中文名稱在UI，其程式需Iuput對應的id (『list('jj' = '熱血籃球')』格式 )
    marketing_group_id_update_in <- list()
    for(i in 1:length(marketing_group_name_update) ){
      marketing_group_id_update_in[[marketing_group_name_update[i]]] <- marketing_group_id_update[i]
    }
    # 2.國家
    country_code_update <- Data$country_code %>% unique() %>% t()
    country_name_update <- Data$country_zhTW %>% unique() %>% t()
    country_code_update_in <- list()
    for(i in 1:length(country_name_update) ){
      country_code_update_in[[country_name_update[i]]] <- country_code_update[i]
    }
    # 3.渠道
    media_source_update <- Data$media_source %>% unique() %>% t()
    media_source_name_update <- Data$media_source_name %>% unique() %>% t()
    media_source_update_in <- list()
    for(i in 1:length(media_source_name_update) ){
      media_source_update_in[[media_source_name_update[i]]] <- media_source_update[i]
    }


    if(input$Data_direction == 'Country'){
        # 1.遊戲-update
        updatePickerInput(session
                          , "Main_Game"
                          , choices = marketing_group_id_update_in
                          , selected = unique(as.character(Data[,'group_id']))
        )
        # 2.國家-update
        updatePickerInput(session
                          , "Main_Country"
                          , choices = country_code_update_in
                          , selected = unique(as.character(Data[,'country_code']))[1]
        )
    } else if(input$Data_direction == 'Game'){
        # 1.遊戲-update
        updatePickerInput(session
                          , "Main_Game"
                          , choices = marketing_group_id_update_in
                          , selected = unique(as.character(Data[,'group_id']))[1]
        )
        # 2.國家-update
        updatePickerInput(session
                          , "Main_Country"
                          , choices = country_code_update_in
                          , selected = unique(as.character(Data[,'country_code']))
        )
    } else{
        # 1.遊戲-update
        updatePickerInput(session
                          , "Main_Game"
                          , choices = marketing_group_id_update_in
                          , selected = unique(as.character(Data[,'group_id']))
        )
        # 2.國家-update
        updatePickerInput(session
                          , "Main_Country"
                          , choices = country_code_update_in
                          , selected = unique(as.character(Data[,'country_code']))
        )
    }

    # 3.渠道-update
    updatePickerInput(session
                      , "Main_media_source"
                      , choices = media_source_update_in
                      , selected = unique(as.character(Data[,'media_source']))[1]
    )
  })
  # update Day according to Data_direction
  observe({
    multiple_Game_Country_Indicator = c("LTV_Ratio" = "Ratio" ,"LTV (USD)" = "LTV")
    Ori_Indicator = c("LTV_Ratio_90 " = "LTV_Ratio_90", "LTV_Ratio" = "Ratio" ,"LTV (USD)" = "LTV")

    if(input$Data_direction == 'Game_Country' ){
            updateAwesomeRadio( session ,
                                inputId = 'Indicator',
                                # label = p("數據指標：", style="color:#191970; font-size:16px; font-weight:bold ;"), # updateAwesomeRadio 無法讀HTML
                                choices = multiple_Game_Country_Indicator ,
                                selected = 'Ratio',
                                inline = TRUE,
                                status = "primary" , checkbox = T
                              )
    } else if(input$Data_direction %in% c('Country','Game') ){
            updateAwesomeRadio( session ,
                                inputId = 'Indicator',
                                # label = p("數據指標：", style="color:#191970; font-size:16px; font-weight:bold ;"),
                                choices = Ori_Indicator ,
                                selected = 'LTV_Ratio_90',
                                inline = TRUE,
                                status = "success"
                              )
    }
  })


  # actually render the dropdownMenu
  output$menu <- renderMenu({

    # dropdownMenu
    dropdownMenu(
      # type = "messages"
      badgeStatus = "success"
      # 首頁-Icon
      , icon = div(img(class = "img-circle",src='Vincent.jpg', height = "16px" , width= '16px') , style = "position: relative ; font-size:14px  ; font-weight:bold ;",'Vincent Chang')
      # 點Icon後顯示的內容：
      # 法一：
      # , headerText =  div(
      #   div(img(src='m.png' , height = 120 , width= 120 ))
      #   , p('Data Scientist', style = "position: relative ; text-align: center ; top: -0px ; font-size:16px ; font-weight:bold ;")
      #   , p("Author：Vincent Chang", style = "position: relative ; text-align: center ; top: -5px ; font-size:16px ; font-weight:bold ;")
      #   , br()
      #   , style = "position: relative ; text-align: center ; top: 0px ;background-color:#3D7878 ;color: #D0D0D0 ;")
      # 法二：
      , headerText =
                    box(
                      width= 16
                    , status = "primary"
                    , background = "navy"
                    # boxProfile
                    , boxProfile(
                                  src = "Vincent.jpg"
                                , title = p('Data Scientist', style = "position: relative ; text-align: center ; top: -0px ; font-size:16px ;color: #D0D0D0 ; font-weight:bold ;")
                                , subtitle = p("Author：Vincent Chang", style = "position: relative ; text-align: center ; top: -5px ; font-size:16px ;color: #D0D0D0 ; font-weight:bold ;")
                                )

                    )

      # , taskItem(value = 70, color = "aqua","Refactor code")
      # , notificationItem(icon = icon("users"), status = "info", "5 new members joined today")
      , messageItem(from = p("Data Team",style = "position: relative ; text-align: left ; font-size:16px ; font-weight:bold ;")
                  , icon = shiny::icon("user-tie")
                  # , icon = div(p(''))
                  , message = p("CM_Cube Magic INC",style = "position: relative ; text-align: left ; font-size:14px ; font-weight:bold ;")
                  , href = 'https://www.all9fun.com/#/')

    )

  })


  # Hide the loading message when the rest of the server function has executed
  library(shinyjs)
  shinyjs::hide(id = "loading-content", anim = TRUE, animType = 'fade' , time = 2.0 , selector = NULL )

  }


#### ------   END   ------ ####








