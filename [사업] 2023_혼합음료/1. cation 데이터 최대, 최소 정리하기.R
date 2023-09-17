library(tidyverse)
library(readxl)
library(writexl)

data <- read_xlsx("20230917_sample_list(cation).xlsx")

data_min <- data %>% filter(minmax == "최소") %>% 
    select(Sample_number, raw_sample_number, Name, new_name, Ca, K, Na, Mg, F)

data_max <- data %>% filter(minmax == "최대") %>% 
    select(Sample_number, raw_sample_number, Name, new_name, Ca, K, Na, Mg, F)

write_xlsx(data_min, "cation_min.xlsx")
write_xlsx(data_max, "cation_max.xlsx")