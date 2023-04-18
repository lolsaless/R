library(httr)
library(rvest)
library(tidyverse)
library(lubridate)
library(xts)
library(dygraphs)

url <- 'http://www.rrfsuwon.co.kr/_Skin/24_1.php'

data <- POST(url, body = list(
    gubun = 'period',
    sYear = '2020',
    sMonth = '10',
    sDate = '2010-01-01',
    eDate = '2023-04-17'
))

data_selection <- read_html(data) %>% html_table(fill = TRUE) %>% .[[1]]

# Create a vector of keywords to be removed in Korean
# keywords <- c("language", "language", "language", "lash", "lash")
keywords <- c("일자", "최대", "최소", "평균", "합계")

# Use the subset function to select rows that do not contain any of the keywords
data_type <- subset(data_selection, !apply(data_selection, 1,
                                           function(x) any(grepl(paste(keywords, collapse = "|"),
                                                                 gsub("[^[:alpha:]]", " ", x)))))

ts_suwon <- data_type
ts_suwon$일자 <- ymd(ts_suwon$일자)

# 변수명 변경
names(ts_suwon) <- c("Date", "waste", "Incinerated_waste", "bottom_ash", "fly_ash", "note")
ts_suwon$note <- NULL

# 인터랙티브그래프 만들기
waste <- ts_suwon
ts_waste <- xts(waste$waste, order.by = waste$Date)

input_waste <- xts(waste$waste, order.by = waste$Date)
incinerated_waste <- xts(waste$Incinerated_waste, order.by = waste$Date)

ts_waste2 <- cbind(input_waste, incinerated_waste)
head(ts_waste2)
dygraph(ts_waste2) %>% dyRangeSelector()



#----실행오류----
# library(ggplot2)
# 
# # Convert the xts object to a data frame with a Date column
# ts_waste2_df <- data.frame(Date = index(ts_waste2), coredata(ts_waste2))
# 
# # Create the ggplot chart
# ggplot(ts_waste2_df, aes(x = Date)) +
#     geom_line(aes(y = input_waste, color = "Input Waste")) +
#     geom_line(aes(y = incinerated_waste, color = "Incinerated Waste")) +
#     labs(title = "Time Series Plot of Waste Data",
#          x = "Date",
#          y = "Waste",
#          color = "Waste Type") +
#     theme_minimal()


#----실행오류----
# library(plotly)
# library(shiny)
# # Inside your Shiny app's server function, create the plotly object
# output$plot <- renderPlotly({
#     waste_plot <- ggplot(ts_waste2_df, aes(x = Date)) +
#         geom_line(aes(y = input_waste, color = "Input Waste")) +
#         geom_line(aes(y = incinerated_waste, color = "Incinerated Waste")) +
#         labs(title = "Time Series Plot of Waste Data",
#              x = "Date",
#              y = "Waste",
#              color = "Waste Type") +
#         theme_minimal()
#     
#     ggplotly(waste_plot)
# })


#----ts_waste2_df오류----
# library(shiny)
# library(ggplot2)
# library(plotly)
# 
# # Define UI for the app
# ui <- fluidPage(
#     titlePanel("Time Series Plot of Waste Data"),
#     mainPanel(
#         plotlyOutput("waste_plot")
#     )
# )
# 
# # Define server logic for the app
# server <- function(input, output) {
#     output$waste_plot <- renderPlotly({
#         waste_plot <- ggplot(ts_waste2_df, aes(x = Date)) +
#             geom_line(aes(y = input_waste, color = "Input Waste")) +
#             geom_line(aes(y = incinerated_waste, color = "Incinerated Waste")) +
#             labs(title = "Time Series Plot of Waste Data",
#                  x = "Date",
#                  y = "Waste",
#                  color = "Waste Type") +
#             theme_minimal()
#         
#         ggplotly(waste_plot)
#     })
# }
# 
# # Run the app
# shinyApp(ui = ui, server = server)


library(shiny)
library(ggplot2)
library(plotly)

# Convert the xts object to a data frame with a Date column
ts_waste2_df <- data.frame(Date = index(ts_waste2), coredata(ts_waste2))

# Define UI for the app
ui <- fluidPage(
    titlePanel("Time Series Plot of Waste Data"),
    mainPanel(
        plotlyOutput("waste_plot")
    )
)

# Define server logic for the app
server <- function(input, output) {
    output$waste_plot <- renderPlotly({
        waste_plot <- ggplot(ts_waste2_df, aes(x = Date)) +
            geom_line(aes(y = input_waste, color = "Input Waste")) +
            geom_line(aes(y = incinerated_waste, color = "Incinerated Waste")) +
            labs(title = "Time Series Plot of Waste Data",
                 x = "Date",
                 y = "Waste",
                 color = "Waste Type") +
            theme_minimal()
        
        ggplotly(waste_plot)
    })
}

# Run the app
shinyApp(ui = ui, server = server)
