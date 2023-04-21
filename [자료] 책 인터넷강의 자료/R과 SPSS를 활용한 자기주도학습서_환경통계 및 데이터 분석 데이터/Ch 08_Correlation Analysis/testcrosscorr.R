# Program: testcrosscorr.R

# Programmer: Bumjo Kim

# Objective(s):
#   To perform Cross Correlation analysis

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

# Install required library

## Attach library

## Data loading
df <- read.csv("testcrosscorr.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
depth <- data$depth
tot_coli <- data$Total.coliform
e_coli <- data$E.coli
temp <- data$temp

## Cross Correlation test
# total coliform with depth
ccf_tc_d <- ccf(tot_coli, depth, lag.max=93, type="correlation", plot=TRUE)
cbind(Lag=ccf_tc_d$lag, CCF=ccf_tc_d$acf)

# total coliform with E. coli
ccf_tc_ec <- ccf(tot_coli, e_coli, lag.max=93, type="correlation", plot=TRUE)
cbind(Lag=ccf_tc_ec$lag, CCF=ccf_tc_ec$acf)

# total coliform with temperature
ccf_tc_t <- ccf(tot_coli, temp, lag.max=93, type="correlation", plot=TRUE)
cbind(Lag=ccf_tc_t$lag, CCF=ccf_tc_t$acf)
