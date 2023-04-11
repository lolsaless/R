# Program: nonhierarchical.R

# Programmer: Bumjo Kim

# Objective(s):
#   To perform non-hierarchical cluster analysis (k-means clustering method)

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library

## Attach library

## Data loading
df <- read.csv("kmeans.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
DO <- data$DO
BOD <- data$BOD
COD <- data$COD
SS <- data$SS
TN <- data$TN
TP <- data$TP

## k-means test
datatest <- data.frame(cbind(DO,BOD,SS,TP))
ktest <- kmeans(datatest, 4, nstart=30, algorithm="Lloyd") # number of clusters: 4
ktest

## One-way ANOVA
anova_do <- lm(data$DO ~ as.factor(ktest$cluster))
anova_bod <- lm(data$BOD ~ as.factor(ktest$cluster))
anova_ss <- lm(data$SS ~ as.factor(ktest$cluster))
anova_tp <- lm(data$TP ~ as.factor(ktest$cluster))
anova(anova_do)
anova(anova_bod)
anova(anova_ss)
anova(anova_tp)


