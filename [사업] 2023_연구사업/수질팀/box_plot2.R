# Importing Libraries
library(readxl)
library(ggplot2)
library(tidyverse)

# Dummy data as given
df <- read_excel("phenol_data.xlsx")

# Data Transformation for NP
df$Log_NP <- log10(df$NP + 1)

# Data Transformation for OP
df$Log_OP <- log10(df$OP + 1)

# Reshape the dataframe
df_long <- df %>%
    gather(Type, Value, Log_NP, Log_OP)

# Plotting
ggplot(df_long, aes(group, Value, fill = Type)) +
    geom_boxplot(position = position_dodge(width = 1), alpha = 0.7) +
    labs(title = "Transformed Log NP and OP Values by Group", x = "Group", y = "Transformed Value") +
    theme_minimal()
_