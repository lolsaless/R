## Importing Libraries
library(readxl)
library(ggplot2)
library(car)
library(tidyverse)
library(ggrepel)

setwd("D:/")
## Reading Data
df <- read_excel("phenol_data.xlsx")

## Data Transformation for NP
df$Log_NP <- log10(df$NP + 1)

## Data Transformation for OP
df$Log_OP <- log10(df$OP + 1)

## Adding row numbers
df <- df %>% mutate(row_num = row_number())

## Reshape the dataframe
df_long <- df %>% 
    gather(Type, Value, Log_NP, Log_OP)

ggplot(df_long, aes(group, Value, color = Type)) +
    geom_boxplot(alpha=0.2, position=position_dodge(width=1)) +
    geom_point(aes(shape=Type), position=position_jitterdodge(jitter.width=0.01), alpha=0.7) +
    scale_shape_manual(values=c("Log_NP"=2, "Log_OP"=16)) +
    labs(title="Transformed Log NP and OP Values by Group", x="Group", y="Transformed Value") +
    theme_minimal()
