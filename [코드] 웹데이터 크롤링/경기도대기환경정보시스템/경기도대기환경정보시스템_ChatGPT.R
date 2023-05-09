if (!require(pacman)) {
    install.packages("pacman")
    library (pacman)
}

# Load required packages
pacman::p_load(rvest, httr, jsonlite, readxl, purrr, tidyjson)

# Set configuration options
config <- list(
    url_air = 'https://air.gg.go.kr/default/tms.do',
    ref_air = 'https://air.gg.go.kr/default/esData.do?mCode=A010010000',
    wd = 'D:/R_coding/Web_crawling/Gyeonggi-do Atmospheric Environment Information System',
    user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36',
    sleep_time = 10.0
)

# Load location codes from file
locCd <- read_excel("locCd.xlsx")

# Define function to retrieve data for a single location
get_location_data <- function(locCd, year, config) {
    data_air <- POST(config$url_air,
                     body = list(op = 'getByLoc',
                                 fromDt = paste0(year, "-01-01"),
                                 toDt = paste0(year, "-12-31"),
                                 locCd = as.numeric(locCd),
                                 typeCd = '3'),
                     user_agent(config$user_agent),
                     add_headers(referer = config$ref_air))
    content <- content(data_air, as='text')
    jsonlite::fromJSON(content, flatten = TRUE)
}

# Define function to process JSON data using purrr
process_data_purrr <- function(data) {
    data %>%
        map_df(~tibble::as_tibble(.))
}

# Define function to process JSON data using tidyjson
process_data_tidyjson <- function(data) {
    data %>%
        as.tbl_json() %>%
        gather_array() %>%
        spread_all() %>%
        as_tibble()
}

# Process data for each year and location code
results <- list()
for (year in 2020:2021) {
    from_year <- paste0(year,"-01-01")
    to_year <- paste0(year, "-12-31")
    count = 0
    result_year <- list()
    for (i in 1: nrow(locCd)) {
        count = count + 1
        location_name <- paste0(locCd$region[count], '_', locCd$branch[count])
        location_data <- get_location_data(locCd[i,1], year, config)
        write.csv(location_data, file.path(config$wd, paste0(year, '_', location_name, '.csv')), row.names = FALSE)
        message(paste0(year, '_', location_name, '.csv file crawled'))
        Sys.sleep(config$sleep_time)
        result_year[[count]] <- location_data
    }
    year_results <- purrr::map_df(result_year, ~process_data_purrr(.)) # or process_data_tidyjson() for tidyjson approach
    results[[year]] <- year_results
}
