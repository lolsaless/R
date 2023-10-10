install.packages("psych")

library(psych)

df <- read.csv("PCA_Example.csv", header = TRUE)

data <- data.frame(df)

describe(data)

round(cor(data), 3)

KMO(data)

cortest.bartlett(cor(data), n = nrow(data))

pca <- prcomp(data, center = TRUE, scale. = TRUE)
screeplot(pca, type = "l")
summary(pca)
pca$sdev^2

PCA <- principal(data, nfactors = 3, rotate = "none",
                 score = TRUE)
PCA

PCA_rot <- principal(data, nfactors = 3, rotate = "varimax",
                     score = TRUE)
PCA_rot
