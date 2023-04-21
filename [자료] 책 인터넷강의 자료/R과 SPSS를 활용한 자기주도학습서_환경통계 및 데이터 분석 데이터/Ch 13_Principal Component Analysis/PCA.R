# Program: PCR.R

# Programmer: Sora Shin

# Objective(s):
#   To perform principal component analysis

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("psych")   # for descriptive statistics and PCA

## Attach library
library(psych)              # for descriptive statistics and PCA

## Data loading
df <- read.csv("PCA_Example.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Descriptive statistics (number of data, mean, standard deviation, ...)
describe(data)

## Correlation
round(cor(data),3)      

## KMO and Bartlett's Test
KMO(data)
cortest.bartlett(cor(data), n=nrow(data))

## Principal component analysis
# Number of principal components
pca <- prcomp(data, center=TRUE, scale.=TRUE)
screeplot(pca, type="l")
summary(pca)
pca$sdev^2    # Eigenvalue with respect to principal components

# Component matrix
PCA <- principal(data, nfactor=3, rotate="none", 
                 score=TRUE)          # the factor value is the number of PC 
PCA

# Rotated component matrix
PCA_rot <- principal(data, nfactor=3, rotate="varimax",
                         score=TRUE)  # the factor value is the number of PC 
PCA_rot


