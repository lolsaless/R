# Program: Regression.R

# Programmer: Heewon Jeong

# Objective(s):
#   To perform simple linear regression

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library

## Attach library

## Data loading
df <- read.csv("test_regression.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
x <- data$TN  # independent variable
y <- data$TP  # dependent variable

## Linear regression
f1 <- function(x, a, b) {
  a*x + b  # definition of simple linear model
}

out1 <- nls(y ~ f1(x, a, b), start=list(a=1, b=2))
summary(out1) # result of simple linear regression model

fitted.data1 <- predict(out1)
result1 <- aov(y ~ fitted.data1)
summary(result1) # statistical significance of regression model

cor(y, fitted.data1) # coefficient of determination

## Polynomial regression
f2 <- function(x, a, b, c) {
  a*(x^2) + b*x + c   # definition of polynomial model
}

out2 <- nls(y ~ f2(x, a, b, c), start=list(a=1, b=2, c=0))
summary(out2)  # result of polynomial regression model

fitted.data2 <- predict(out2)
result2 <- aov(y ~ fitted.data2)
summary(result2)  # statistical significance of regression model

cor(y, fitted.data2)  # coefficient of determination

## Exponential regression
f3 <- function(x, a, b) {
  a*exp(b*x)    # definition of exponential model
}

out3  <- nls(y ~ f3(x, a, b), start=list(a=1, b=0))
summary(out3)  # result of exponential regression model

fitted.data3 <- predict(out3)
result3 <- aov(y ~ fitted.data3)
summary(result3)  # statistical significance of regression model

cor(y,fitted.data3)  # coefficient of determination

## Sigmoid regression
f4 <- function(x, a, b) {
  1/(1+a*exp(b*x))    # definition of sigmoid model
}

out4  <- nls(y ~ f4(x, a, b), start=list(a=1, b=0))
summary(out4)  # result of sigmoid regression model

fitted.data4 <- predict(out4)
result4 <- aov(y ~ fitted.data4)
summary(result4)  # statistical significance of regression model

cor(y, fitted.data4)  # coefficient of determination

