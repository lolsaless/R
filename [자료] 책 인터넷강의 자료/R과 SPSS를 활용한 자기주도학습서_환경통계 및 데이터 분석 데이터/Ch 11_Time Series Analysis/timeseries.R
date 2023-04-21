# Program: timeseries.R

# Programmer: Bumjo Kim

# Objective(s):
#   To break a time series data into its components (trend, period and randomness)

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

# Install required library

## Attach library

## Data loading
df <- read.csv("timeseries.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
time <- data$time
dat <- data$velocity

## De-trending
fdet <- function(x, a, b){
    a*x + b 
} # definition of polynomial fitting model

trendfit <- nls(dat ~ fdet(time, a, b), start=list(a=0.1, b=0.1))
trendfit
trend.dat <- predict(trendfit)  # trend component of data
detrend.dat <- dat - trend.dat  # de-trended data
trendfit2 <- nls(detrend.dat ~ fdet(time, a, b), start=list(a=0.1, b=0.1))
trend2.dat <- predict(trendfit2)

# Scatter plot of raw data
plot(time, dat, pch=1, 
     xlim=c(min(time), max(time)), 
     ylim=c(min(dat), max(dat)), 
     main="Scatter plot of raw data", 
     xlab="Time", ylab="Velocity")
legend("topright", c("Observed data"), pch=c(1))

# Trend component of raw data
plot(time, dat, pch=1, 
     xlim=c(min(time), max(time)), 
     ylim=c(min(dat), max(dat)), 
     main="Trend component of data", 
     xlab="Time", ylab="Velocity")
par(new=TRUE)
plot(time, trend.dat, pch=2, type="l", col="red", lwd=2, 
     xlim=c(min(time), max(time)), 
     ylim=c(min(dat), max(dat)),
     main="", xlab="", ylab="")
legend("topright", c("Observed data","Linear model fit"), 
       pch=c(1,NA), lty=c(NA,1), lwd=c(1,2), col=c("black","red"))

# De-trended data
plot(time, detrend.dat, pch=1, 
     xlim=c(min(time), max(time)), 
     ylim=c(min(detrend.dat), max(detrend.dat)), 
     main="Detrended data", xlab="Time", ylab="Velocity")
par(new=TRUE)
plot(time, trend2.dat, type="l", col="red", lwd=2,
     xlim=c(min(time), max(time)), 
     ylim=c(min(detrend.dat), max(detrend.dat)),
     main="", xlab="", ylab="")
legend("topright", c("Detrended data","Trend model fit"), 
       pch=c(1,NA), lty=c(NA,1), lwd=c(1,2), col=c("black","red"))

## De-period 
fdec <- function(x, a0, w1, a1, a2, b1, b2){
  a0 + a1*cos(w1*x) + b1*sin(w1*x) + a2*cos(2*w1*x) + b2*sin(2*w1*x)
} # definition of periodic fitting model

periodfit <- nls(detrend.dat ~ fdec(time, a0, w1, a1, a2, b1, b2), 
                  start=list(a0=0.25, w1=0.25, a1=0.25, a2=0.25, b1=0.25, b2=0.25))
periodfit
period.dat <- predict(periodfit)          # periodic component of detrended data
deperiod.dat <- detrend.dat - period.dat  # deperiod data
periodfit2 <- nls(deperiod.dat ~ fdec(time, a0, w1, a1, a2, b1, b2), 
                  start=list(a0=0.25, w1=0.25, a1=0.25, a2=0.25, b1=0.25, b2=0.25))
period2.dat<- predict(periodfit2)

# periodic component of de-trended data
plot(time, detrend.dat, pch=1, 
     xlim=c(min(time), max(time)), 
     ylim=c(min(detrend.dat), max(detrend.dat)), 
     main="Periodic component of detrended data", 
     xlab="Time", ylab="Velocity")
par(new=TRUE)
plot(time, period.dat, pch=2, type="l", col="red", lwd=2,
     xlim=c(min(time), max(time)), 
     ylim=c(min(detrend.dat), max(detrend.dat)),
     main="", xlab="", ylab="")
legend("topright", c("Detrended data","Periodic model fit"), 
       pch=c(1,NA), lty=c(NA,1), lwd=c(1,2), col=c("black","red"))

# Deperiod data
plot(time, deperiod.dat, pch=1, 
     xlim=c(min(time), max(time)), 
     ylim=c(min(deperiod.dat), max(deperiod.dat)), 
     main="Deperiod data", xlab="Time", ylab="Velocity")
par(new=TRUE)
plot(time, period2.dat, type="l", col="red", lwd=2,
     xlim=c(min(time), max(time)), 
     ylim=c(min(deperiod.dat), max(deperiod.dat)),
     main="", xlab="", ylab="")
legend("topright", c("Deperiod data","Periodic model fit"), 
       pch=c(1,NA), lty=c(NA,1), lwd=c(1,2), col=c("black","red"))

## Randomness component of de-period data
meanDeperiod <- mean(deperiod.dat)
stdDeperiod <- sd(deperiod.dat)
inlier.dat <- replace(deperiod.dat, deperiod.dat > stdDeperiod
                      | deperiod.dat < -stdDeperiod, 0) # Eliminate outliers
rand.dat <- replace(inlier.dat, which(inlier.dat>=0), 
                    runif(which(inlier.dat>=0))*stdDeperiod + meanDeperiod)
rand.dat <- replace(rand.dat, which(rand.dat<0), 
                    -1*runif(which(rand.dat<0))*stdDeperiod + meanDeperiod) # randomness component of de-period data saved as variable 'rand.dat'

## Time series model
model.dat <- trend.dat + period.dat + rand.dat # trend + periodic + randomness

# Comparison of observed data and time series model
plot(time, dat, type="b", pch=1, lty=2,
     xlim=c(min(time), max(time)), 
     ylim=c(min(dat), max(dat)),
     main="Comparison of observed data and time series model",
     xlab="Time", ylab="Velocity")
par(new=TRUE)
plot(time, model.dat, type="l", col="red", lwd=2,
     xlim=c(min(time), max(time)), 
     ylim=c(min(dat), max(dat)), 
     main="", xlab="", ylab="")
legend("topright", c("Observed data","Times series model fit"),
       pch=c(1,NA), lty=c(2,1), lwd=c(1,2), col=c("black","red"))

## Abnomaly 
abnomal.dat <- dat - model.dat
uppernoise <- stdDeperiod
lowernoise <- -1*stdDeperiod

plot(time, abnomal.dat, type="l", col="red",
     xlim=c(min(time), max(time)),
     ylim=c(min(abnomal.dat), max(abnomal.dat)),
     main="Abnomaly data", xlab="Time", ylab="Velecity")
par(new=TRUE)
abline(h= uppernoise, lty=2, lwd=2)
par(new=TRUE)
abline(h=lowernoise, lty=2, lwd=2)
legend("topright", c("Abnomaly","White noise"),
       pch=c(NA,NA), lty=c(1,2), lwd=c(1,2), col=c("red","black"))

