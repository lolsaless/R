# Program: One_sample_ttest.R

# Programmer: Heewon Jeong

# Objective(s):
#   To compare mean of a data set with the given population mean

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("psych")   # for descriptive statistics

## Attach library
library(psych)              # for descriptive statistics

## Data loading
df <- read.csv("paired-ttest.csv", header=TRUE)
data <- data.frame(df)  # raw data saved as variable 'data'

## Variables assigning
A <- data$AFTER          # difference between Before and After

## Descriptive statistics (number of data, mean, standard deviation, ...)
describe(A)

## One sample t-test
One_sample <- t.test(A, mu=14, alternative=c("two.sided"))
One_sample
