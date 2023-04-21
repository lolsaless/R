# Program: Exponential02.R

# Programmer: Sora Shin

# Objective(s):
#   To fit the data to exponential function

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library

## Attach library

## Data loading
df <- read.csv("testexponential02.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
x <- data$time
y <- data$microbe_2

## Definition of function (exponential)
f <- function(x, a, b, c, d) {
  a*exp(b*x) + c*exp(d*x)
}

## Curve fitting (exponential)
y2 <- nls(y ~ f(x, a, b, c, d), start=list(a=1, b=0.5, c=0.0001, d=2))
y2
summary(y2)
fitted.data <- predict(y2)

## Visualization
plot(x, y, pch=1, xlim=c(min(x), max(x)), ylim=c(min(y), max(y)), 
     xlab="Time", ylab="Microbes")
par(new=TRUE)
plot(x, fitted.data, type='l', xlim=c(min(x), max(x)), ylim=c(min(y), max(y)),
     axes=FALSE, col="red", xlab="Time", ylab="Microbes")
par(new=FALSE)
