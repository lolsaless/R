# Program: two_way_MANOVA_edap.R

# Programmer: Bumjo Kim

# Objective(s):
#   To analyze variance among WT, pH, and DO with site and season

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("psych")    # for descriptive statistics
install.packages("biotools") # for Box's test of equality of covariance matrices
install.packages("stats")    # for MANOVA test
install.packages("car")      # for Levene's Test
install.packages("DescTools") # for post-hoc analysis

## Attach library
library(psych)    # for descriptive statistics
library(biotools) # for Box's test of equality of covariance matrices
library(stats)    # for MANOVA test
library(car)      # for Levene's Test
library(DescTools)  # for post-hoc analysis

## Data loading
df <- read.csv("testmanova2.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
sites <- as.factor(data$Site)     # factoring of categrized independent variable (Site)
seasons <- as.factor(data$Season) # factoring of categrized independent variable (Month)
wt <- data$WT # dependent variable1 (Water temperature)
ph <- data$pH # dependent variable2 (pH)
do <- data$DO # dependent variable3 (DO concentration)
Y <- cbind(wt, ph, do)

## Descriptive statistics (number of data, mean, standard deviation, ...)
describe(Y)
describeBy(Y,sites) # by group (Site)
describeBy(Y,seasons)# by group (Season) 
describeBy(subset(data, sites==1, select = c("WT","pH","DO","Season")),subset(seasons, sites==1)) # for site 1 by group (Season)
describeBy(subset(data, sites==2, select = c("WT","pH","DO","Season")),subset(seasons, sites==2)) # for site 2 by group (Season)
describeBy(subset(data, sites==3, select = c("WT","pH","DO","Season")),subset(seasons, sites==3)) # for site 2 by group (Season)

## MANOVA test
test.manova <- manova(Y ~ sites*seasons)
summary(test.manova, test="Pillai")
summary(test.manova, test="Hotelling-Lawley")
summary(test.manova, test="Roy")
summary(test.manova, test="Wilks")

## ANOVA test (Univariate tests)
summary.aov(test.manova)

## post-hoc analysis
## method option: 
##              "lsd" -> Fisher's LSD
##              "hsd" -> Tukey's HSD
##              "bonf" -> Duun's (Bonferroni)
##              "scheffe" -> Scheffe
##              "newmankeuls" - Newman-Keuls
wt.aov <- aov(wt ~ sites*seasons)
ph.aov <- aov(ph ~ sites*seasons)
do.aov <- aov(do ~ sites*seasons)
PostHocTest(wt.aov, method="lsd")
PostHocTest(wt.aov, method="lsd")
PostHocTest(wt.aov, method="lsd")

