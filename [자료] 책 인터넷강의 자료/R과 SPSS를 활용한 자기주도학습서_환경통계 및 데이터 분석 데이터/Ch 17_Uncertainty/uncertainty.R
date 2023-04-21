# Program: uncertainty.R

# Programmer: Bumjo Kim

# Objective(s):
#   To perform uncertainty analysis (law of propagation of uncertainty)

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library

## Attach library

## Data loading
df <- read.csv("UncertaintyPractice.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
t <- data$time
x <- data$x
a <- data$a
b <- data$b
c <- data$c

## Evaluation of Y
y <- a*x^2 + b*sin(x) - x*log(c)

## Law of propagation of uncertainty
# Standard uncertainty
std_x <- sd(x)
std_a <- sd(a)
std_b <- sd(b)
std_c <- sd(c)

# Partial derivative
y1 <- 2*a*x + b*cos(x) - log(c)   # dy/dx
y2 <- x^2                         # dy/da
y3 <- sin(x)                      # dy/db
y4 <- -1*x/c                      # dy/dc

# Law of propagation of uncertainty
Uy1 <- y1^2*std_x^2 + 2*std_x*std_a*cor(x,a)*y1*y2 +
       2*std_x*std_b*cor(x,b)*y1*y3 + 2*std_x*std_c*cor(x,c)*y1*y4
Uy2 <- y2^2*std_a^2 + 2*std_a*std_b*cor(a,b)*y2*y3 + 
       2*std_a*std_c*cor(a,c)*y2*y4
Uy3 <- y3^2*std_b^2 + 2*std_b*std_c*cor(b,c)*y3*y4
Uy4 <- y4^2*std_c^2
Uy <- sqrt(Uy1+Uy2+Uy3+Uy4)

k1 <- 1          # for 68.3% of Confidence interval
                 # k1 value of 1.645  -> 90.0 % CL
                 # k1 value of 1.96   -> 95.0 % CL
                 # k1 value of 2.567  -> 99.0 % CL
                 # k1 value of 3      -> 99.7 % CL

## Visualization
plot(t,y, type ="l", lwd=2,
     xlim=c(min(t), max(t)), 
     ylim=c(min(y-k1*Uy), max(y+k1*Uy)),
     main="Uncertainty of evaluation value of Y", xlab="Time", ylab="Y")
lines(t, y+k1*Uy, col="red", lty=4, lwd=1,
     xlim=c(min(t), max(t)), 
     ylim=c(min(y-k1*Uy), max(y+k1*Uy)))
lines(t, y-k1*Uy, col="red", lty=1, lwd=1,
     xlim=c(min(t), max(t)), 
     ylim=c(min(y-k1*Uy), max(y+k1*Uy)))
legend("topright", c("Estimation of Y(t)","Upper u(Y)","Lower u(Y)"),
       pch=c(NA,NA,NA), lty=c(1,4,1), lwd=c(2,1,1),
       col=c("black","red","red"))

