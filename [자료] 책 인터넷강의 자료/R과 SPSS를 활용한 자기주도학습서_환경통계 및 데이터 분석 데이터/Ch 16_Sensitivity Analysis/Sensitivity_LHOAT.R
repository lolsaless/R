# Program: sensitivity_LHOAT.R

# Programmer: Sora Shin

# Objective(s):
#   To perform the sensitivity analysis using Latin-hypercube one factor at a time method

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("hydroGOF")  # for Nash-Sutcliffe efficiency
install.packages("hydroPSO")  # for LH-OAT sensitivity analysis

## Attach library
library(hydroGOF)             # for Nash-Sutcliffe efficiency
library(hydroPSO)             # for LH-OAT sensitivity analysis

## Data loading
df <- read.csv("YSR1_WQ.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
x <- subset(data, select=c(3:8))  # pH, DO, SS, NO3, Temp. and PO4
y <- data$Chl.a                   # Chlorophyll a

## Multiple linear regression
# Eq'n: Chla = a0+a1*pH+a2*DO+a3*SS+a4*NO3+a5*Temp+a6*PO4
model <- lm(y ~ x[,1]+x[,2]+x[,3]+x[,4]+x[,5]+x[,6])
summary(model)

## Checking performance based on Nash-Sutcliffe model efficiency
chla.pre <- predict(model)
nse_value <- NSE(chla.pre, y)
nse_value

## LH-OAT sensitivity analysis
# Eq'n: Chla = a0+a1*pH+a2*DO+a3*SS+a4*NO3+a5*Temp+a6*PO4
cof <- model$coefficients
model2 <- function(x){
  cof[1]+cof[2]*x[1]+cof[3]*x[2]+cof[4]*x[3]+
    cof[5]*x[4]+cof[6]*x[5]+cof[7]*x[6]
}

num <- 10000            # the number of LH simulation
fr <- 0.1               # the fraction by which the parameter is changed
lower <- apply(x,2,min) # the lowest value of parameters
upper <- apply(x,2,max) # the highest values of parameters

set.seed(1)
sensitivity <- lhoat(fn=model2,
                     lower=lower,
                     upper=upper,
                     control=list(N=num, f=fr, normalise=TRUE,
                                  write2disk=TRUE, verbose=TRUE))
sensitivity$Ranking   # results of sensitivity analysis
