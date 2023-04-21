# Install the required packages if you haven't already
if (!require("dplyr")) {
    install.packages("dplyr")
}

# Load the required packages
library(dplyr)

# Set the working directory
folder_path <- "D:/R_coding/Data crawling/food safety country crawling/data/"

# List all the CSV files in the specified directory
csv_files <- list.files(path = folder_path, pattern = "*.csv", full.names = TRUE)

# Function to read a CSV file, convert all columns to character type, and return its content as a data frame
read_and_combine_csv <- function(file) {
    data <- read.csv(file, stringsAsFactors = FALSE)
    data[] <- lapply(data, as.character)  # Convert all columns to character type
    return(data)
}

# Read and combine the CSV files into a single data frame
combined_data <- lapply(csv_files, read_and_combine_csv) %>%
    bind_rows(.id = "source_file")

# Check if the output directory exists, if not, create it
output_directory <- "D:/R_coding/Data crawling/food safety country crawling/"
if (!dir.exists(output_directory)) {
    dir.create(output_directory, recursive = TRUE)
}

# Write the combined data frame to a new CSV file
output_file <- file.path(output_directory, "combined_data.csv")
write.csv(combined_data, file = output_file, row.names = FALSE)
