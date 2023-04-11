# Program: 3d_data analysis.R

# Programmer: Heewon Jeong

# Objective(s):
#   To perform 3d spatial and temporal data analyses

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("plot3D")    # for 3D plot

## Attach library
library(plot3D)               # for 3D plot

## Data loading
df <- read.csv("contour3d.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
x <- data$site  # Site
y <- data$time  # Time
z <- data$TP    # TP

## Data matrix
x1 <- matrix(x, nrow=length(levels(as.factor(y))), 
             ncol=length(levels(as.factor(x))))
y1 <- matrix(y, nrow=length(levels(as.factor(y))), 
             ncol=length(levels(as.factor(x))))
z1 <- matrix(z, nrow=length(levels(as.factor(y))), 
             ncol=length(levels(as.factor(x))))

## Visualization - 3D plot
persp3D(x1,y1,z1,  
        xlab="Monitoring site", 
        ylab="Monitoring TIME(hr)", 
        zlab="TP concentration(mg/L)",
        border='black', facets=TRUE, colkey=FALSE, 
        bty="b2", ticktype='detailed')
