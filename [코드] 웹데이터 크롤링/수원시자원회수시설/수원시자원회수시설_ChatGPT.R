if (!require(pacman)){
    install.packages("pacman")
    library(pacman)
}

# library 불러오기
p_load(httr, rvest, tidyverse, lubridate, xts, shiny, plotly)

# 수원시자원화회수시설 자료 크롤링 시작
url <- 'http://www.rrfsuwon.co.kr/_Skin/24_1.php'

data <- POST(url, body = list(
    gubun = 'period',
    sYear = '2020',
    sMonth = '10',
    sDate = '2021-01-01',
    eDate = '2022-12-31'
))

data_selection <- read_html(data) %>% html_table(fill = TRUE) %>% .[[1]]

# keywords <- c("language", "language", "language", "lash", "lash")
keywords <- c("일자", "최대", "최소", "평균", "합계")

# Use the subset function to select rows that do not contain any of the keywords
data_type <- subset(data_selection, !apply(data_selection, 1,
                                           function(x) any(grepl(paste(keywords, collapse = "|"),
                                                                 gsub("[^[:alpha:]]", " ", x)))))

# ts_suwon에 data_type할당
ts_suwon <- data_type
ts_suwon$일자 <- ymd(ts_suwon$일자)

# 변수명 변경, 삭제
names(ts_suwon) <- c("Date", "waste", "Incinerated_waste", "bottom_ash", "fly_ash", "note")
ts_suwon$note <- NULL

# waste ~ fly_ash까지 숫자로 변경
ts_suwon <- ts_suwon %>% 
    mutate_at(vars(waste:fly_ash), ~ as.numeric(.))


# Shiny를 이용하여
# Define UI(정상작동)
ui <- fluidPage(
    titlePanel("Waste Time Series Data"),
    sidebarLayout(
        sidebarPanel(
            dateRangeInput("date_range", label = "Date Range", start = min(ts_suwon$Date), end = max(ts_suwon$Date)),
            selectInput("type", label = "Waste Type", choices = c("waste", "Incinerated_waste", "bottom_ash", "fly_ash"), selected = "waste")
        ),
        mainPanel(
            plotOutput("waste_plot")
        )
    )
)

# Define server(정상작동)
server <- function(input, output) {
    output$waste_plot <- renderPlot({
        # Filter data based on user input
        filtered_data <- ts_suwon %>%
            filter(Date >= input$date_range[1] & Date <= input$date_range[2])
        ggplot(filtered_data, aes(x = Date, y = !!sym(input$type))) +
            geom_line() +
            xlab("Date") +
            ylab("Waste") +
            ggtitle(paste("Waste Type:", input$type))
    })
}

# # Run app
shinyApp(ui, server)

# Define UI(여러 변수 선택 가능)
ui <- fluidPage(
    titlePanel("Waste Time Series Data"),
    sidebarLayout(
        sidebarPanel(
            dateRangeInput("date_range", label = "Date Range", start = min(ts_suwon$Date), end = max(ts_suwon$Date)),
            checkboxGroupInput("type", label = "Waste Type", choices = c("waste", "Incinerated_waste", "bottom_ash", "fly_ash"), selected = "waste")
        ),
        mainPanel(
            plotOutput("waste_plot")
        )
    )
)

# Define server(여러 변수 선택 가능)
server <- function(input, output) {
    output$waste_plot <- renderPlot({
        # Filter data based on user input
        filtered_data <- ts_suwon %>%
            filter(Date >= input$date_range[1] & Date <= input$date_range[2])
        
        # Create the initial ggplot object
        p <- ggplot(filtered_data, aes(x = Date)) +
            xlab("Date") +
            ylab("Waste") +
            ggtitle("Waste Types")
        
        # Add lines for selected waste types
        for (waste_type in input$type) {
            p <- p + geom_line(aes_string(y = waste_type), color = switch(waste_type,
                                                                          "waste" = "gray57",
                                                                          "Incinerated_waste" = "deeppink4",
                                                                          "bottom_ash" = "dodgerblue4",
                                                                          "fly_ash" = "sienna4"
            ))
        }
        
        return(p)
    })
}

# Run app
shinyApp(ui, server)

#####################################################
####################완성코드#########################

# Define UI(여러변수 선택 및 확대 가능)
ui <- fluidPage(
    titlePanel("Waste Time Series Data"),
    sidebarLayout(
        sidebarPanel(
            dateRangeInput("date_range", label = "Date Range", start = min(ts_suwon$Date), end = max(ts_suwon$Date)),
            checkboxGroupInput("type", label = "Waste Type", choices = c("waste", "Incinerated_waste", "bottom_ash", "fly_ash"), selected = "waste")
        ),
        mainPanel(
            plotlyOutput("waste_plot")
        )
    )
)

# Define server(여러변수 선택 및 확대 가능)
server <- function(input, output) {
    output$waste_plot <- renderPlotly({
        # Filter data based on user input
        filtered_data <- ts_suwon %>%
            filter(Date >= input$date_range[1] & Date <= input$date_range[2])
        
        # Create the initial ggplot object
        p <- ggplot(filtered_data, aes(x = Date)) +
            xlab("Date") +
            ylab("Waste") +
            ggtitle("Waste Types")
        
        # Add lines for selected waste types
        for (waste_type in input$type) {
            p <- p + geom_line(aes_string(y = waste_type), color = switch(waste_type,
                                                                          "waste" = "gray57",
                                                                          "Incinerated_waste" = "deeppink4",
                                                                          "bottom_ash" = "dodgerblue4",
                                                                          "fly_ash" = "sienna4"
            ))
        }
        
        # Convert ggplot to plotly for interactivity
        ggplotly(p)
    })
}

# Run app
shinyApp(ui, server)
