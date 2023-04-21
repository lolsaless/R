# Program: MLRegression.R

# Programmer: Heewon Jeong

# Objective(s):
#   To perform multiple linear regression

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library

## Attach library

## Data loading
df <- read.csv("test_multiplereg.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
x1 <- data$x1  # independent variable 1
x2 <- data$x2  # independent variable 2
y <- data$y    # dependent variable

## Multiple linear regression
model <- lm(y ~ x1 + x2)
summary(model)

## Visualization
par(mfrow=c(2,2))
plot(model) 

