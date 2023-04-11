# Program: testARIMA.R

# Programmer: Bumjo Kim

# Objective(s):
#   To use autoregressive integrated moving average model for prediction

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("forecast")    # for arima model identification

## Attach library
library(forecast)               # for arima model identification

## Data loading
df <- read.csv("testARIMA.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
time <- data$Month
dat <- data$Passengers
log_dat <- data$Log.Passengers.

## Converting data frame into time series
ts_dat <- ts(dat, frequency=12, start=c(1949,1))
ts_dat

## Plotting raw data
plot(ts_dat, xlab="Time",ylab="Passengers", lwd=2)

## Decomposition of time series data
decom_dat <- decompose(ts_dat)
plot(decom_dat) 

## Model identification (decision of p,d,q value) - method1
best_pdq <- auto.arima(ts_dat)
best_pdq

plot(forecast(best_pdq, h=24),xlab="Time",ylab="Passengers", lwd=2)
legend("topleft", c("Observed","Prediction"),
       col=c(1,4), lty=c(1,1), lwd=2)

## Creating ARIMA model - method2
# order   : A specification of non-seasonal part of the ARIMA model (p,d,q).
# seasonal: A specification of seasonal part of the ARIMA model 
fit <- arima(ts_dat, order=c(2, 1, 1), 
             seasonal=list(order=c(0, 1, 0), period=12)) 
fit

## Prediction of created ARIMA model
fore <- predict(fit, n.ahead=24)
U <- fore$pred + 1.96*fore$se    # upper boundary of confidence interval (95%)
L <- fore$pred - 1.96*fore$se    # lower boundary of confidence interval (95%)

ts.plot(ts_dat, fore$pred, U, L, 
        main="ARIMA(2,1,1)", xlab="Time", ylab="Passengers",
        col=c(1, 2, 4, 4), lty=c(1, 1, 2, 2), lwd=2)
legend("topleft", c("Observed","Prediction","95% confidence interval"),
       col=c(1,2,4), lty=c(1,1,2), lwd=2)

## Checking AC and PACF of residuals
res <- residuals(fit)
acf(res, main="Residual ACF")
pacf(res, main="Residual PACF")

