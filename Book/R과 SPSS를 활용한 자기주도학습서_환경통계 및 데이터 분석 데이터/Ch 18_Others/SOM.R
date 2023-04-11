# Program: SOM.R

# Programmer: Heewon Jeong

# Objective(s):
#   To classify data according to their characteristics using Self organizing map

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("SOMbrero")  # for Self-organized map

## Attach library
library(SOMbrero)             # for Self-organized map

## Data loading
df <- read.csv("SOM_Data.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Normalization of data
data.scale <- data.frame(scale(data)) # normalized to 0 of mean, 1 of stdev

## Training the SOM model
model <- trainSOM(x.data=data.scale, dimension=c(5,5),
                  nb.save=10, maxit=2000, scaling="none",
                  radius.type="letremy")
plot(model, what="energy")

## Visualization
table(model$clustering)
plot(model, what="prototypes", type="umatrix", print.title=TRUE)
plot(model, what="prototypes", type="radar")
plot(model, what="obs", type="names", print.title=TRUE, scale=c(1,1))

## Clustering results
clusters <- superClass(model, k=5)
summary(clusters)
plot(clusters)                  # dendrogram
plot(clusters, type="dendro3d") # 3d dendrogram
