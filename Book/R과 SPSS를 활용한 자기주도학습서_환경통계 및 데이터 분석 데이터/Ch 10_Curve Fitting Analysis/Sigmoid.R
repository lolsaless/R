# Program: Exponential02.R

# Programmer: Sora Shin

# Objective(s):
#   To fit the data to a custom equation

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library

## Attach library

## Data loading
df <- read.csv("testsigmoid.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
x <- data$Distance
y <- data$TP

## Definition of function (sigmoid)
f <- function(x, a) {
  1/(1 + exp(-a*x))
}

## Curve fitting (sigmoid)
y2 <- nls(y ~ f(x, a), start=list(a=0.5))
y2
summary(y2)
fitted.data <- predict(y2)

## Visualization
plot(x, y, pch=1, xlim=c(min(x), max(x)), ylim=c(min(y), max(y)), 
     xlab="Distance", ylab="Conc. of TP")
par(new=TRUE)
plot(x, fitted.data, type='l', xlim=c(min(x), max(x)), ylim=c(min(y), max(y)),
     axes=FALSE, col="red", xlab="Distance", ylab="Conc. of TP")
par(new=FALSE)
