## Importing Libraries
library(readxl)
library(ggplot2)
library(car)
library(tidyverse)
library(ggrepel)

## Reading Data
df <- read_excel("data_opnp.xlsx")

## Data Transformation for NP
df$Log_NP <- log(df$NP + 1)

## Data Transformation for OP
df$Log_OP <- log(df$OP + 1)

## Adding row numbers
df <- df %>% mutate(row_num = row_number())

## Plotting NP
p_np <- ggplot(df, aes(x=row_num, y=Log_NP, color=group)) +
    geom_point() +
    geom_hline(yintercept=0, linetype="dashed", color = "red") +
    labs(title="Transformed Log NP Values by Group", x="Index", y="Transformed_Log_NP") +
    theme_minimal()

## Plotting OP
p_op <- ggplot(df, aes(x=row_num, y=Log_OP, color=group)) +
    geom_point() +
    geom_hline(yintercept=0, linetype="dashed", color = "red") +
    labs(title="Transformed Log OP Values by Group", x="Index", y="Transformed_Log_OP") +
    theme_minimal()

## Print the plots
print(p_np)
print(p_op)
