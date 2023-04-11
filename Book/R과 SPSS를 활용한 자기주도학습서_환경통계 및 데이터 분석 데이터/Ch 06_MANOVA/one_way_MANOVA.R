# Program: one_way_MANOVA.R

# Programmer: Bumjo Kim

# Objective(s):
#   To analyze variance among WT, pH, and DO with Site

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("psych")       # for descriptive statistics
install.packages("biotools")    # for Box's test of equality of covariance matrices
install.packages("stats")       # for MANOVA test
install.packages("car")         # for Levene's Test
install.packages("DescTools")   # for post-hoc analysis

## Attach library
library(psych)      # for descriptive statistics
library(biotools)   # for Box's test of equality of covariance matrices
library(stats)      # for MANOVA test
library(car)        # for Levene's Test
library(DescTools)  # for post-hoc analysis

## Data loading
df <- read.csv("test_MANOVA_01.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
sites <- as.factor(data$Site) # categorized independent variable (Site)
wt <- data$WT # dependent variable1 (Water temperature)
ph <- data$pH # dependent variable2 (pH)
do <- data$DO # dependent variable3 (DO concentration)
Y <- cbind(wt, ph, do)

## Descriptive statistics (number of data, mean, standard deviation, ...)
describe(Y)
describeBy(Y, sites) # by group (Site)

## Box's Test of Equality of Covariance Matrices
test.box <- boxM(Y, data[,"Site"])
test.box

## MANOVA test
test.manova <- manova(Y ~ sites)
summary(test.manova, test="Pillai")
summary(test.manova, test="Hotelling-Lawley")
summary(test.manova, test="Roy")
summary(test.manova, test="Wilks")

## Levene's test for homogeneity of variance across groups
leveneTest(wt, sites, center=mean) # homogeneity of variance of WT
leveneTest(ph, sites, center=mean) # homogeneity of variance of pH
leveneTest(do, sites, center=mean) # homogeneity of variance of DO

## ANOVA test (Univariate tests)
summary.aov(test.manova)

## post-hoc analysis
## method option: 
##              "lsd"         -> Fisher's LSD
##              "hsd"         -> Tukey's HSD (Honestly significant difference)
##              "bonf"        -> Duun's (Bonferroni)
##              "scheffe"     -> Scheffe
##              "newmankeuls" -> Newman-Keuls
wt.aov <- aov(wt ~ sites)
ph.aov <- aov(ph ~ sites)
do.aov <- aov(do ~ sites)
PostHocTest(wt.aov, method="lsd")
PostHocTest(wt.aov, method="lsd")
PostHocTest(wt.aov, method="lsd")
