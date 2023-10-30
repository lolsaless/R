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

## Plotting NP with Boxplots
p_np_combined <- ggplot(df, aes(x=group, y=Log_NP, color=group)) +
    geom_point(position=position_jitterdodge(jitter.width=0.4), alpha=0.7) + # Jitter the points for better visibility
    geom_boxplot(alpha=0.2) + # Overlay boxplots
    labs(title="Transformed Log NP Values by Group", x="Group", y="Transformed_Log_NP") +
    theme_minimal()

## Plotting OP with Boxplots
p_op_combined <- ggplot(df, aes(x=group, y=Log_OP, color=group)) +
    geom_point(position=position_jitterdodge(jitter.width=0.4), alpha=0.7) + # Jitter the points for better visibility
    geom_boxplot(alpha=0.2) + # Overlay boxplots
    labs(title="Transformed Log OP Values by Group", x="Group", y="Transformed_Log_OP") +
    theme_minimal()

## Print the combined plots
print(p_np_combined)
print(p_op_combined)

## Plotting NP with Boxplots
p_np_combined <- ggplot(df, aes(x=group, y=Log_NP, color=group)) +
    geom_point(position=position_jitterdodge(jitter.width=0.4), alpha=0.7) + # Jitter the points for better visibility
    geom_boxplot(alpha=0.2) + # Overlay boxplots
    labs(title="Transformed Log NP Values by Group", x="Group", y="Transformed_Log_NP") +
    theme_minimal() +
    ylim(-1, 3) # Adjust y-axis limits

## Plotting OP with Boxplots
p_op_combined <- ggplot(df, aes(x=group, y=Log_OP, color=group)) +
    geom_point(position=position_jitterdodge(jitter.width=0.4), alpha=0.7) + # Jitter the points for better visibility
    geom_boxplot(alpha=0.2) + # Overlay boxplots
    labs(title="Transformed Log OP Values by Group", x="Group", y="Transformed_Log_OP") +
    theme_minimal() +
    ylim(-1, 3) # Adjust y-axis limits

## Print the combined plots
print(p_np_combined)
print(p_op_combined)


## Reshape the dataframe
df_long <- df %>% 
    gather(Type, Value, Log_NP, Log_OP)

## Plotting combined NP and OP with Boxplots
p_combined <- ggplot(df_long, aes(x=group, y=Value, color=group)) +
    geom_point(aes(shape=Type), position=position_jitterdodge(jitter.width=0.4), alpha=0.7) + # Use different shapes for NP and OP
    geom_boxplot(aes(fill=group), alpha=0.2, position=position_dodge(width=0.75)) + # Separate boxplots for NP and OP
    scale_shape_manual(values=c("Log_NP"=2, "Log_OP"=16)) + # Triangle for NP and Circle for OP
    labs(title="Transformed Log NP and OP Values by Group", x="Group", y="Transformed Value") +
    theme_minimal() +
    facet_wrap(~Type, scales="free", ncol=1) # Separate facets for NP and OP

## Print the combined plot
print(p_combined)

## Subset the data for only "Car wash" and "Textile" groups
df_sub <- df_long %>% 
    filter(group %in% c("Car wash", "Textile"))

## Plotting combined NP and OP with Boxplots for "Car wash" and "Textile"
p_sub_combined <- ggplot(df_sub, aes(x=group, y=Value, color=group)) +
    geom_point(aes(shape=Type), position=position_jitterdodge(jitter.width=0.4), alpha=0.7) + # Use different shapes for NP and OP
    geom_boxplot(aes(fill=group), alpha=0.2, position=position_dodge(width=0.75)) + # Separate boxplots for NP and OP
    scale_shape_manual(values=c("Log_NP"=2, "Log_OP"=16)) + # Triangle for NP and Circle for OP
    labs(title="Transformed Log NP and OP Values for Car wash and Textile", x="Group", y="Transformed Value") +
    theme_minimal() +
    facet_wrap(~Type, scales="free", ncol=1) # Separate facets for NP and OP

## Print the subset combined plot
print(p_sub_combined)


## Plotting combined NP and OP with Boxplots
p_combined <- ggplot(df_long, aes(x=group, y=Value, color=group)) +
    geom_point(aes(shape=Type), position=position_jitterdodge(jitter.width=0.6, dodge.width=0.75), alpha=0.7) + # Adjust dodge width for points
    geom_boxplot(aes(fill=group), alpha=0.2, position=position_dodge(width=0.75)) + # Separate boxplots for NP and OP
    scale_shape_manual(values=c("Log_NP"=2, "Log_OP"=16)) + # Triangle for NP and Circle for OP
    labs(title="Transformed Log NP and OP Values by Group", x="Group", y="Transformed Value") +
    theme_minimal() +
    facet_wrap(~Type, scales="free", ncol=2) # Arrange facets from left to right

## Print the combined plot
print(p_combined)

