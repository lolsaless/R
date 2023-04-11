# Program: clusteranalysis.R

# Programmer: Bumjo Kim

# Objective(s):
#   To perform hierarchical cluster analysis

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("factoextra")  # for determining optimal number of clusters
install.packages("DescTools")   # for post-hoc analysis

## Attach library
library(factoextra)             # for determining optimal number of clusters
library(DescTools)              # for post-hoc analysis

## Data loading
df <- read.csv("testCA.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Calculation of distance
dis.matrix <- dist(as.matrix(data), method="euclidean")

## Cluster analysis
ca <- hclust(dis.matrix, 'ward.D2') # Ward's method
plot(ca, hang = -1)
rect.hclust(ca, k=3, border=c(2:4)) # k: number of clusters

## Determining optimal number of clusters
CN <- fviz_nbclust(data, FUN=hcut, method="wss")
CN
coeffdelta <- CN$data[-length(CN$data[,2]),2] - CN$data[-1,2]
cbind(CN$data[-1,], coeffdelta)

## Clustering table
Cluster <- cutree(ca, 3) # number of clusters
Clustertable <- cbind(data, Cluster)
Clustertable

## One-way ANOVA
anova_selfc <- lm(data$Selfconcept ~ as.factor(Clustertable$Cluster))
anova_absen <- lm(data$Absence ~ as.factor(Clustertable$Cluster))
anova_nsmoke <- lm(data$Nonsmokingpolice ~ as.factor(Clustertable$Cluster))
anova(anova_selfc)
anova(anova_absen)
anova(anova_nsmoke)

## post-hoc analysis
PostHocTest(aov(anova_selfc), method="hsd")   # Tukey HSD
PostHocTest(aov(anova_absen), method="hsd")   # Tukey HSD
PostHocTest(aov(anova_nsmoke), method="hsd")  # Tukey HSD

## Visualization
plot(Clustertable[4:6], cex=1.5, 
     pch=Clustertable$Cluster, col=Clustertable$Cluster)
par(new=TRUE)
par(fig=c(0, 1, 0, 1), oma=c(0, 0, 0, 0), mar=c(0, 0, 0, 0), new=TRUE)
plot(0, 0, type='n', bty='n', xaxt='n', yaxt='n')
legend("bottom", c("Cluster1","Cluster2","Cluster3"),
       bty="n", pch=1:3, col=1:3, horiz=TRUE)

