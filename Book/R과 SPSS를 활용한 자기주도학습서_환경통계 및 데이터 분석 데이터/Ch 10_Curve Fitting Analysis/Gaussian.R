# Program: Exponential02.R

# Programmer: Sora Shin

# Objective(s):
#   To fit the data to gaussian function

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library

## Attach library

## Data loading
df <- read.csv("testgaussian.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
x <- data$number
y <- data$turbidity

## Definition of function (gaussian)
f <- function(x, a, b, c) {
  a*exp(-((x - b)/c)^2)
}

## Curve fitting (gaussian)
y2 <- nls(y ~ f(x, a, b, c), start=list(a=30.0, b=15.0, c=5.0))
y2
summary(y2)
fitted.data <- predict(y2)

## Visualization
plot(x, y, pch=1, xlim=c(min(x), max(x)), ylim=c(min(y), max(y)), 
     xlab="Time", ylab="Turbidity")
par(new=TRUE)
plot(x, fitted.data, type='l', xlim=c(min(x), max(x)), ylim=c(min(y), max(y)),
     axes=FALSE, col="red", xlab="Time", ylab="Turbidity")
par(new=FALSE)
