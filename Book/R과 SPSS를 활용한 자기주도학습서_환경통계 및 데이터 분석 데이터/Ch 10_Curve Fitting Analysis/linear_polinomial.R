# Program: linear_polinomial.R

# Programmer: Sora Shin

# Objective(s):
#   To fit the data to linear polynomial

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library

## Attach library

## Data loading
df <- read.csv("testpolynomial.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
x <- data$time
y <- data$temp

## Definition of function (linear polynomial)
f <- function(x, a, b) {
  a*x + b
}

## Curve fitting (linear polynomial)
y2 <- nls(y ~ f(x, a, b), start=list(a=1, b=1))
y2
summary(y2)
fitted.data <- predict(y2)

## Visualization
plot(x, y, pch=1, xlim=c(min(x), max(x)), ylim=c(min(y), max(y)), 
     xlab="Time", ylab="Temperature")
par(new=TRUE)
plot(x, fitted.data, type='l',
     xlim=c(min(x), max(x)), ylim=c(min(y), max(y)),
     axes=FALSE, col="red", xlab="Time", ylab="Temperature")
par(new=FALSE)
