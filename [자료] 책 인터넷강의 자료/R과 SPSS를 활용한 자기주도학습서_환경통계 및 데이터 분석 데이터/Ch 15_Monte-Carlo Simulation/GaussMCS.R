# Program: GaussMCS.R

# Programmer: Heewon Jeong

# Objective(s):
#   To use Monte Carlo simulation to generate a Gaussian distribution

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library

## Attach library

## Parameters for Gauss distribution
mu <- readline(prompt = "Enter the mean value for Gaussian distribution: ")
mu <- as.numeric(mu)
stdev <- readline(prompt = "Enter the standard deviation value for Gaussian distribution: ")
stdev <- as.numeric(stdev)
num <- readline(prompt = "Enter the how many Mote Carlo simulation to perform: ")
num <- as.numeric(num)
lwr <- readline(prompt = "Enter the minimum value of Mote Carlo simulation result: ")
lwr <- as.numeric(lwr)
upr <- readline(prompt = "Enter the maximum value of Mote Carlo simulation result: ")
upr <- as.numeric(upr)

## Monte Calro simulation
mysamp <- function(n, m, s, min, max, rounding) {
  samp <- round(rnorm(n, m, s), rounding)
  samp[samp < lwr] <- lwr
  samp[samp > upr] <- upr
  samp
}
set.seed(8)
returns <- mysamp(n=num, m=mu, s=stdev, min=lwr, max=upr, rounding=3)
returns

## Plot the simulation results
plot(returns, type='l', col='blue')

## Visualize frequency with histogram
hist(returns, breaks=10) # with 10 bins

## Random sampling
sample(returns, size=10)  # Random sampling of 10 samples
