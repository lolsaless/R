# Program: smoothing_BA_MA.R

# Programmer: Bumjo Kim

# Objective(s):
#   To remove irregular variation of time series data and to find out the overall trend of the data
#   using box average or moving average.

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

# Install required library
install.packages("forecast")    # for moving average
install.packages("zoo")         # for moving average

## Attach library
library(forecast)       # for moving average
library(zoo)            # for moving average

## Data loading
df <- read.csv("BA_MA.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
time <- data$Time
dat <- data$Case1
dat2 <- data$Case2

## Box average method - Case1 
ba1.window1 <- 5    # fixed window size for box average
ba1.mat1 <- matrix(dat, nrow=ba1.window1, ncol=floor(length(dat)/ba1.window1))
ba11 <- colMeans(ba1.mat1)
ba11

## Moving average method - Case1
ma1.window1 <- 5    # window size for moving average
ma11 <- ma(dat, ma1.window1, centre=TRUE)
ma11
ma1.window2 <- 21   # window size for moving average
ma12 <- ma(dat, ma1.window2, centre=TRUE)
ma12

## Box average method - Case2
ba2.window1 <- 5    # fixed window size for box average
ba2.mat1 <- matrix(dat2, nrow=ba2.window1, ncol=floor(length(dat2)/ba2.window1))
ba21 <- colMeans(ba2.mat1, na.rm=TRUE)
ba21

## Moving average method - Case2
ma2.window1 <- 5    # window size for moving average
ma21 <- rollapply(dat2, ma2.window1, mean, na.rm=TRUE, fill=NA)
ma21
ma2.window2 <- 21   # window size for moving average
ma22 <- rollapply(dat2, ma2.window2, mean, na.rm=TRUE, fill=NA)
ma22

# Results of smoothing method - Case1
plot(time, dat, type="b", pch=1, lty=2,
     xlim=c(min(time), max(time)), 
     ylim=c(min(dat), max(dat)),
     main="Comparison of smoothing method - Case1",
     xlab="Time", ylab="Data")
lines(seq(time[1],time[length(time)],ba1.window1)+floor(ba1.window1/2),
      ba11,
      type="l", col="red", lty=1,lwd=2,
      xlim=c(min(time), max(time)), 
      ylim=c(min(dat), max(dat)), 
      main="", xlab="", ylab="")
lines(time, ma11, type="l", col="green", lty=1, lwd=2,
      xlim=c(min(time), max(time)), 
      ylim=c(min(dat), max(dat)), 
      main="", xlab="", ylab="")
lines(time, ma12, type="l", col="navy", lty=1, lwd=2,
      xlim=c(min(time), max(time)), 
      ylim=c(min(dat), max(dat)), 
      main="", xlab="", ylab="")
legend("topright", c("Observed data","BA(5)","MA(5)","MA(21)"),
       pch=c(1,NA,NA,NA), lty=c(2,1,1,1), lwd=c(1,2,2,2),
       col=c("black","red","green","navy"))

# Results of smoothing method - Case2
plot(time, dat2, type="b", pch=1, lty=2,
     xlim=c(min(time), max(time)), 
     ylim=c(min(dat2,na.rm=T), max(dat2,na.rm=T)),
     main="Comparison of smoothing method - Case2",
     xlab="Time", ylab="Data")
lines(seq(time[1],time[length(time)],ba2.window1)+floor(ba2.window1/2),
      ba11,
      type="l", col="red", lty=1, lwd=2,
      xlim=c(min(time), max(time)), 
      ylim=c(min(dat2,na.rm=T), max(dat2,na.rm=T)), 
      main="", xlab="", ylab="")
lines(time, ma21, type="l", col="green", lty=1, lwd=2,
      xlim=c(min(time), max(time)), 
      ylim=c(min(dat2,na.rm=T), max(dat2,na.rm=T)), 
      main="", xlab="", ylab="")
lines(time, ma22, type="l", col="navy", lty=1, lwd=2,
      xlim=c(min(time), max(time)), 
      ylim=c(min(dat2,na.rm=T), max(dat2,na.rm=T)), 
      main="", xlab="", ylab="")
legend("topright", c("Observed data","BA(5)","MA(5)","MA(21)"),
       pch=c(1,NA,NA,NA), lty=c(2,1,1,1), lwd=c(1,2,2,2),
       col=c("black","red","green","navy"))

