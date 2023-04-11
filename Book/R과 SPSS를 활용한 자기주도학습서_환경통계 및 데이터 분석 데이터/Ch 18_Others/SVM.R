# Program: SVM.R

# Programmer: Heewon Jeong

# Objective(s):
#   To estimate chl-a using support vector machine(SVM)

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("caret")     # for Support vector machine
install.packages("hydroGOF")  # for Nash sutcliffe efficiency

## Attach library
library(caret)                # for Support vector machine
library(hydroGOF)             # for Nash sutcliffe efficiency

## Data loading
df <- read.csv("SVM_Data.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Normalization of data
data.scale <- data.frame(scale(data)) # normalized to 0 of mean, 1 of stdev

## Arrangement of input and output data
# 70% of data for training and rest of data for validation
set.seed(12)
size <- nrow(data.scale)
index <- sample(1:size, round(size*0.7))
training.data.scale <- data.scale[index,] # normalized training data set
test.data.scale <- data.scale[-index,]    # normalized test data set

## Setting up the Support vector machine and training
n <- names(training.data.scale)
f <- as.formula(paste("Chla ~", paste(n[!n %in% "Chla"], collapse="+")))
fitControl <- trainControl(method="optimism_boot", number=10)
svm_fit <- train(f,
                data=training.data.scale,
                method="svmPoly",
                trControl=fitControl)

trained.scale <- svm_fit$trainingData$.outcome  # trained result of Chla
tested.scale <- predict(svm_fit,
                    newdata=test.data.scale)    # predicted result of Chla

## De-normalization
k <- data$Chla
train <- data[index,]
test <- data[-index,]
trained <- trained.scale*sd(k)+mean(k) # de-normalization of trained result
tested <- tested.scale*sd(k)+mean(k)   # de-normalization of tested result

## Model performance
plot(trained, train[,7], xlim=c(min(k),max(k)), ylim=c(min(k),max(k)),  
     xlab="Measured Chl-a conc", ylab="Predicted Chl-a conc",
     main="SVM Training")
abline(0,1)
plot(tested, test[,7], xlim=c(min(k),max(k)), ylim=c(min(k),max(k)),  
     xlab="Measured Chl-a conc", ylab="Predicted Chl-a conc",
     main="SVM Testing")
abline(0,1)

## NSE
NSE(trained, train[,7])   # NSE at training step
NSE(tested, test[,7])     # NSE at validation step
