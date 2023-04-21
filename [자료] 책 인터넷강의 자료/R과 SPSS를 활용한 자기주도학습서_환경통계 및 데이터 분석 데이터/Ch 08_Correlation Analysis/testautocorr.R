# Program: testautocorr.R

# Programmer: Bumjo Kim

# Objective(s):
#   To perform Auto Correlation analysis

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

# Install required library

## Attach library

## Data loading
df <- read.csv("testautocorr.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
depth <- data$depth
tot_coli <- data$Total.coliform
e_coli <- data$E.coli
temp <- data$temp

## Auto Correlation test
# depth
acf_d <- acf(depth, lag.max=93, type="correlation", plot=TRUE) 
cbind(Lag=acf_d$lag,ACF = acf_d$acf)

# total coliform
acf_tc <- acf(tot_coli, lag.max=93, type="correlation", plot=TRUE) 
cbind(Lag=acf_tc$lag, ACF=acf_tc$acf)

# E. coli.
acf_ec <- acf(e_coli, lag.max=93, type="correlation", plot=TRUE) 
cbind(Lag=acf_ec$lag, ACF = acf_ec$acf)

# temperature
acf_t <- acf(temp, lag.max = 93, type = "correlation", plot = TRUE) 
cbind(Lag=acf_t$lag, ACF=acf_t$acf)
