# Create the 'data_tms' directory if it doesn't exist
dir.create('data_tms', showWarnings = FALSE)

# http referrer to leave the address of the site to be crawled and traces (?) necessary for crawling
url_tms <- 'https://www.stacknsky.or.kr/stacknsky/selectMeasureResult.do2'
ref_tms <- 'https://www.stacknsky.or.kr/stacknsky/contentsDa.jsp'

# Define the years and region codes to be scraped
years <- 2015:2019
codes <- 1:17

# Define a named character vector for region codes and names
region_names <- c('서울', '부산', '대구', '인천','광주', '대전', '울산', '경기','강원', '충북','충남', '전북', '전남', '경북','경남', '제주', '세종')
names(region_names) <- as.character(codes)

# Loop through all combinations of year and region code and send POST requests
for (year in years) {
    for (code in codes) {
        # Send the POST request
        response <- POST(url_tms,
                         body = list(year = year, brtcCode = code),
                         add_headers(referer = ref_tms))
        # Convert the response to a data frame
        data_tms <- content(response, as = 'text') %>%
            fromJSON() %>%
            do.call(rbind, .)
        
        # Write the data to a CSV file
        region_name <- region_names[[as.character(code)]]
        filename <- sprintf("data_tms/%d_%s.csv", year, region_name)
        write.csv(data_tms, file = filename, row.names = FALSE)
        
        # Sleep for 5 seconds to avoid being detected as a DDoS attack
        Sys.sleep(5.0)
    }
}

#### first ####
# Get the list of files in the data_tms folder
file_list <- list.files("data_tms", pattern = "*.csv", full.names = TRUE)

# Create an empty data frame to store the combined data
combined_data <- data.frame()

# Iterate through the list of files and add the data to the combined data frame
for (file in file_list) {
    temp_data <- read.csv(file)
    combined_data <- rbind(combined_data, temp_data)
}

# Rename the columns to match the specified order
colnames(combined_data) <- c("HF", "TSP", "ADRES", "SOX", "YEAR", "INDICT_NM", "HCL", "CODE", "CO", "NH3", "NOX ")

write.csv(combined_data, "combined_data.csv")