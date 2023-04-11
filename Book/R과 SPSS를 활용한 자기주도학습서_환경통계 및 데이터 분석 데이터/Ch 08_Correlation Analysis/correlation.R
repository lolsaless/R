# Program: correlation.R

# Programmer: Bumjo Kim

# Objective(s):
#   To perform Pearson's correlation and Spearman's rank correlation analysis

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

# Install required library

## Attach library

## Data loading
df <- read.csv("testcorr.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
flow <- data$Flow
tss <- data$TSS

## Correlation test
## method option: 
##              "pearson"  -> Pearson's product-moment correlation
##              "spearman" -> Spearman's rank correlation
cor(df, method="pearson")
cor.test(flow, tss, method="pearson")
cor(df, method="spearman")
cor.test(flow, tss, method="spearman", exact=FALSE)

