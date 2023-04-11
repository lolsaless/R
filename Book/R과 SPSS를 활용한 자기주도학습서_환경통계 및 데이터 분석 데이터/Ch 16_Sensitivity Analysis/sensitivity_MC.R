# Program: sensitivity_MC.R

# Programmer: Sora Shin

# Objective(s):
#   To perform the sensitivity analysis using Monte Carlo simulation

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("hydroGOF")  # for Nash-Sutcliffe efficiency

## Attach library
library(hydroGOF)             # for Nash-Sutcliffe efficiency

## Data loading
df <- read.csv("YSR1_WQ.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
x <- subset(data, select=c(3:8))  # pH, DO, SS, NO3, Temp. and PO4
y <- data$Chl.a                   # Chlorophyll a

## Normalization of input data
# To manipulate the range of data from -1 to 1
for (i in 1:6) {
  k <- x[,i]
  x[,i] <- -1 + (k-min(k))/(max(k)-min(k))*2
  }

## Multiple linear regression
# Eq'n: Chla = a0+a1*pH+a2*DO+a3*SS+a4*NO3+a5*Temp+a6*PO4
model <- lm(y ~ x[,1]+x[,2]+x[,3]+x[,4]+x[,5]+x[,6])
summary(model)

## Checking performance based on Nash-Sutcliffe model efficiency
chla.pre <- predict(model)
nse_value <- NSE(chla.pre, y)
nse_value

## Calculating empirical Cumulative distribution function of raw input data
raw.x <- subset(data, select=c(3:8))
ecdf_x <- vector('list',6)
ecdf_y <- vector('list',6)
for (j in 1:6){
  f <- ecdf(raw.x[,j])
  ecdf_x[[j]] <- environment(f)$x
  ecdf_y[[j]] <- environment(f)$y
}

## Selecting the raw input data randomly based on each parameter's CDF
n <- 10000      # the number of selection
x1.ph <- matrix(0, nrow=n, ncol=6)
x2.do <- matrix(0, nrow=n, ncol=6)
x3.ss <- matrix(0, nrow=n, ncol=6)
x4.no <- matrix(0, nrow=n, ncol=6)
x5.te <- matrix(0, nrow=n, ncol=6)
x6.po <- matrix(0, nrow=n, ncol=6)

# for pH
for (k in 1:6){
  dummy <- sample(ecdf_x[[k]])[1]
  for (m in 1:n){
    if (k==1){
      x1.ph[m,k] <- sample(ecdf_x[[k]])[1]
    }
    else if (k!=1){
      x1.ph[m,k] <- dummy 
    }
  }
}

# for DO
for (k in 1:6){
  dummy <- sample(ecdf_x[[k]])[1]
  for (m in 1:n){
    if (k==2){
      x2.do[m,k] <- sample(ecdf_x[[k]])[1]
    }
    else if (k!=2){
      x2.do[m,k] <- dummy 
    }
  }
}

# for SS
for (k in 1:6){
  dummy <- sample(ecdf_x[[k]])[1]
  for (m in 1:n){
    if (k==3){
      x3.ss[m,k] <- sample(ecdf_x[[k]])[1]
    }
    else if (k!=3){
      x3.ss[m,k] <- dummy 
    }
  }
}

# for NO3
for (k in 1:6){
  dummy <- sample(ecdf_x[[k]])[1]
  for (m in 1:n){
    if (k==4){
      x4.no[m,k] <- sample(ecdf_x[[k]])[1]
    }
    else if (k!=4){
      x4.no[m,k] <- dummy 
    }
  }
}

# for Temperature
for (k in 1:6){
  dummy <- sample(ecdf_x[[k]])[1]
  for (m in 1:n){
    if (k==5){
      x5.te[m,k] <- sample(ecdf_x[[k]])[1]
    }
    else if (k!=5){
      x5.te[m,k] <- dummy 
    }
  }
}

# for PO4
for (k in 1:6){
  dummy <- sample(ecdf_x[[k]])[1]
  for (m in 1:n){
    if (k==6){
      x6.po[m,k] <- sample(ecdf_x[[k]])[1]
    }
    else if (k!=6){
      x6.po[m,k] <- dummy 
    }
  }
}

## Normalization of selected data
# To manipulate the range of data from -1 to 1
# for pH
for (ii in 1:6) {
  k1 <- raw.x[,ii]
  x1.ph[,ii] <- -1 + (x1.ph[,ii]-min(k1))/(max(k1)-min(k1))*2
}

# for DO
for (ii in 1:6) {
  k2 <- raw.x[,ii]
  x2.do[,ii] <- -1 + (x2.do[,ii]-min(k2))/(max(k2)-min(k2))*2
}

# for SS
for (ii in 1:6) {
  k3 <- raw.x[,ii]
  x3.ss[,ii] <- -1 + (x3.ss[,ii]-min(k3))/(max(k3)-min(k3))*2
}

# for NO3
for (ii in 1:6) {
  k4 <- raw.x[,ii]
  x4.no[,ii] <- -1 + (x4.no[,ii]-min(k4))/(max(k4)-min(k4))*2
}

# for Temperature
for (ii in 1:6) {
  k5 <- raw.x[,ii]
  x5.te[,ii] <- -1 + (x5.te[,ii]-min(k5))/(max(k5)-min(k5))*2
}

# for PO4
for (ii in 1:6) {
  k6 <- raw.x[,ii]
  x6.po[,ii] <- -1 + (x6.po[,ii]-min(k6))/(max(k6)-min(k6))*2
}

## Simulation of MLR based on MC analysis selected input condition
# Eq'n: Chla = a0+a1*pH+a2*DO+a3*SS+a4*NO3+a5*Temp+a6*PO4
cof <- model$coefficients
# for pH
pre.mc.ph <- cof[1]+cof[2]*x1.ph[,1]+cof[3]*x1.ph[,2]+cof[4]*x1.ph[,3]+
  cof[5]*x1.ph[,4]+cof[6]*x1.ph[,5]+cof[7]*x1.ph[,6]
std.mc.ph <- sd(pre.mc.ph)
std.mc.ph

# for DO
pre.mc.do <- cof[1]+cof[2]*x2.do[,1]+cof[3]*x2.do[,2]+cof[4]*x2.do[,3]+
  cof[5]*x2.do[,4]+cof[6]*x2.do[,5]+cof[7]*x2.do[,6]
std.mc.do <- sd(pre.mc.do)
std.mc.do

# for SS
pre.mc.ss <- cof[1]+cof[2]*x3.ss[,1]+cof[3]*x3.ss[,2]+cof[4]*x3.ss[,3]+
  cof[5]*x3.ss[,4]+cof[6]*x3.ss[,5]+cof[7]*x3.ss[,6]
std.mc.ss <- sd(pre.mc.ss)
std.mc.ss

# for NO3
pre.mc.no <- cof[1]+cof[2]*x4.no[,1]+cof[3]*x4.no[,2]+cof[4]*x4.no[,3]+
  cof[5]*x4.no[,4]+cof[6]*x4.no[,5]+cof[7]*x4.no[,6]
std.mc.no <- sd(pre.mc.no)
std.mc.no

# for Temperature
pre.mc.te <- cof[1]+cof[2]*x5.te[,1]+cof[3]*x5.te[,2]+cof[4]*x5.te[,3]+
  cof[5]*x5.te[,4]+cof[6]*x5.te[,5]+cof[7]*x5.te[,6]
std.mc.te <- sd(pre.mc.te)
std.mc.te

# for PO4
pre.mc.po <- cof[1]+cof[2]*x6.po[,1]+cof[3]*x6.po[,2]+cof[4]*x6.po[,3]+
  cof[5]*x6.po[,4]+cof[6]*x6.po[,5]+cof[7]*x6.po[,6]
std.mc.po <- sd(pre.mc.po)
std.mc.po

## Compare the rank of each parameters
parameters <- c("pH","DO","SS","NO3","Temperature","PO4")
std.total <- c(std.mc.ph, std.mc.do, std.mc.ss, std.mc.no,
                 std.mc.te, std.mc.po)
ranking <- rank(-std.total)
sensitivity_result <- data.frame(parameters, std.total, ranking)
sensitivity_result
