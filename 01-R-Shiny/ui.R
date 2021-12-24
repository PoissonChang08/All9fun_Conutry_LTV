
# === Start ===
# 主程式 國家成效-出價決策評估 (ui)
# 維護者: VIncent Chang
# 更新日期: 2021-04-09
# === End ===


# VIncent Chang


# 2020/11/04：
# 1.UI的pickerInput、multiInput、selectInput改成先寫死，再使用updatePickerInput、updateMultiInput、updateselectInput更新UI篩選條件。
#   (這樣就只要ｓｅｒｖｅｒ端載入資料即可)
# 2.篩選條件是有順序性的，例如：選擇LTV Ratio 30、60、90、120的篩選條件，此必須寫在最後面，否則資料會重新計算。
# 3.未來新增JJ籃球，多遊戲篩選。
# 4.新增Main table 篩選條件。


# shinydashboardPlus：
# 參考網站 1.：https://adminlte.io/themes/AdminLTE/pages/UI/general.html
# 參考網站 2.：https://rinterface.com/shiny/shinydashboardPlus/


# 1.Loading packages ==================================================

library(dplyr)
library(rstudioapi)
library(openxlsx)
library(shinydashboard)
library(shiny)
library(dashboardthemes)
library(shinycssloaders)
library(shinyWidgets)
library(DT)
library(magrittr)
library(shinydashboardPlus)
library(shinyjs)


#### ====== END ====== ####


# # loading
img_loading_small <- 'https://daattali.com/shiny/ddpcr/_w_2eb8ab369268f7dcff09c84f099520b620a2bc028bc4bb81/ajax-loader-bar.gif?tdsourcetag=s_pctim_aiomsg' # Loading Logo
img_loading_Page <- 'https://www.zsg.000111.com.tw/images/loading.gif'


# UI  ==================================================

# ui
ui <- tagList(
              # # Loading message
              useShinyjs(),
              div(id = "loading-content", "Loading" , img(src=img_loading_small) , div( img(src=img_loading_Page) )
                  , style="font-size:32px ; float:left
                  ; position: absolute ; background: #eee8aa ;color: #000000 ; padding: 15% 0 0 0
                  ; opacity: 1.0; z-index: 10000 ; top:0%; left:0% ; right:0% ; width: 100%; height: 400%
                  ; text-align: center; font-weight:bold"),
  # dashboardPagePlus
  dashboardPagePlus(skin = "blue", sidebar_background = "light" ,  loading_duration = 2 , enable_preloader = TRUE ,
                    dashboardHeader(
                                    # title
                                    title = tagList(
                                      tags$span(
                                        class = "logo-mini", img(src='icon-brain.jpg', height = 40 , width= 40)
                                      ),
                                      tags$span(
                                        class = "logo-lg", img(src='cmi_logo_black.png', height = 40 , width= 40) , 'Data Analysis'
                                      )
                                    )
                                    # title = glue::glue("Data Analysis") # glue??
                                  , titleWidth = 200 , disable = F
                                  , dropdownMenuOutput("menu") ),

                    dashboardSidebar(collapsed = F # if TRUE Will Sidebar close
                                   , width = 200
                                   # User name & Picture
                                   , sidebarUserPanel(" Vincent Chang ★ ",
                                                    subtitle = a(href = "#", icon("circle", class = "text-success") , "Online"),
                                                    # Image file should be in www/ subdir
                                                    image = "Vincent.jpg"
                                   )
                                   # search
                                   , sidebarSearchForm(label = "Search...", textId = "searchbar",  buttonId = "searchbtn")
                                   , sidebarMenu(id = "tabs",
                                                 # menuItem(div(img(src='m.png', height = 30 , width= 30), style = "position: relative ; font-size:14px  ; font-weight:bold ;",' Vincent Chang ★ ')),
                                                 menuItem("國家-數據分析", tabName = "Country_LTV", icon = icon("flag")),
                                                 menuItem("說明", tabName = "LTV_Ratio", icon = icon("book"), badgeLabel = "new", badgeColor = "green")
                                                 # menuItem("About", tabName = "About", icon = icon("info") )

                                     )
                    ),
                    dashboardBody(
                      tabItems(
                        # 1.原始數據
                        tabItem(tabName = "Country_LTV",
                                # Shiny UI  ==================================================
                                # Create a new Row in the UI for selectInputs
                                fluidRow(
                                         tags$style(".fa-database {color:#696969}"),
                                         p("各國家",icon("globe-asia"),"LTV評估","(輔助數位廣告出價)", style="color:#003366; font-size:24px; font-weight:bold ;text-align:center;"),
                                          column(4,
                                                # 數據角度：
                                                radioGroupButtons(
                                                                 inputId = "Data_direction",
                                                                 label = p("數據角度：", style="color:#000000; font-size:24px; font-weight:bold ;"),
                                                                 choices = c("1.多遊戲-單一國家" = "Country" ,"2.單一遊戲-多國家" = "Game" , "3.多遊戲-多國家" = "Game_Country"),
                                                                 status = "primary",
                                                                 justified = TRUE,
                                                                 individual = FALSE
                                                                 # checkIcon = list(yes = icon("ok",lib = "glyphicon"),
                                                                 # no = icon("remove",lib = "glyphicon"))
                                                              )
                                            ),
                                          column(12),
                                          column(2,
                                                 # 1.遊戲(pickerInput)：
                                                 shinyWidgets::pickerInput(inputId = "Main_Game"
                                                                           , label = p("遊戲:", style="color:#191970; font-size:16px; font-weight:bold ;")
                                                                           , choices = "mt"
                                                                           , options = pickerInput_options()
                                                                           , selected = 'mt'
                                                                           , multiple = T)
                                            ),
                                          column(2,
                                                 # 2.國家(pickerInput)：
                                                 shinyWidgets::pickerInput(inputId = "Main_Country"
                                                                           , label = p("國家:", style="color:#191970; font-size:16px; font-weight:bold ;")
                                                                           , choices = "mt"
                                                                           , options = pickerInput_options()
                                                                           , selected = 'TW'
                                                                           , multiple = T)
                                            ),
                                          column(2,
                                                 # 3.渠道(pickerInput)：
                                                 shinyWidgets::pickerInput(inputId = "Main_media_source"
                                                                           , label = p("渠道:", style="color:#191970; font-size:16px; font-weight:bold ;")
                                                                           , choices = "organic"
                                                                           , options = pickerInput_options()
                                                                           , selected = 'organic'
                                                                           , multiple = T)
                                            ),
                                         column(2,
                                               # 4.安裝數-篩選(numericInput)：
                                               numericInput(inputId = "AF_installs"
                                                            , label =  p("安裝數：", style="color:#191970; font-size:16px; font-weight:bold ;")
                                                            , width = '50%'
                                                            , min = 0, max = 1000, value = 1000 , step = 100)
                                           )
                                  ),
                                fluidRow(
                                         column(3,
                                               # 5.數據指標選擇(radioGroupButtons)：
                                                 awesomeRadio(inputId = "Indicator",
                                                              label = p("數據指標：", style="color:#191970; font-size:16px; font-weight:bold ;"),
                                                              inline = TRUE,
                                                              status = "success",
                                                              selected = 'LTV_Ratio_90',
                                                              choices = c("LTV_Ratio_90 " = "LTV_Ratio_90", "LTV_Ratio" = "Ratio" ,"LTV (USD)" = "LTV"))
                                           ),
                                         column(12,
                                               # 6.數據天數(radioGroupButtons)：
                                                useShinyjs(),
                                                shinyjs::hidden(awesomeRadio(inputId = "Day"
                                                             , label =  p("Day：" , style="color:#191970; font-weight:bold")
                                                             , choices = c(seq(from = 30,to = 180,by = 30))
                                                             , selected = "30"
                                                             , status = "info" ,  inline = T ))
                                           ) ,
                                         column(12,
                                              # 6.數據表格：
                                              DT::dataTableOutput("Row_table"))
                                  ),
                                shiny::hr() # 我是分隔線

                                #### ======= END ======= ####
                        ),
                        # 2.國家價值-評估
                        tabItem(tabName = "LTV_Ratio",
                                # Shiny UI  ==================================================
                                # Create a new Row in the UI for selectInputs
                                fluidRow(column(12,
                                                # DT::dataTableOutput("spread_table"))),
                                                uiOutput("description"))),
                                shiny::hr() # 我是分隔線

                                #### ======= END ======= ####
                        )

                      ) # tabItems close
                    )
  ) #close dashboardPagePlus
) #close tagList




#### ------   END   ------ ####

