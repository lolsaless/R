# Program: Unpaired_ttest.R

# Programmer: Heewon Jeong

# Objective(s):
#   To compare mean of two unpaired groups

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("psych")   # for descriptive statistics

## Attach library
library(psych)              # for descriptive statistics

## Data loading
df <- read.csv("unpaired-ttest.csv", header=TRUE)
data <- data.frame(df)  # raw data saved as variable 'data'

## Variables assigning
A <- data$River_A_SS # SS concentration of River A 
B <- data$River_B_SS # SS concentration of River B 

## Descriptive statistics (number of data, mean, standard deviation, ...)
describe(A)
describe(B)

## F-test
Result_var <- var.test(A,B)
Result_var

## unpaired t-test
un_T <- t.test(A,B,
               alternative=c("two.sided"), paired=FALSE, var.equal=FALSE)
un_T
