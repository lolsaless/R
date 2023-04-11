# Program: 4d_data analysis.R

# Programmer: Heewon Jeong

# Objective(s):
#   To perform 4d spatial and temporal data analyses

## Clear workspace
dev.off()     # clear all plots
rm(list=ls()) # clear global Environmental
cat("\f")     # clear Console

## Install required library
install.packages("plotly")       # for 4D plot 

## Attach library
library(plotly)                  # for 4D plot

## Data loading
df <- read.csv("contour4d.csv", header=TRUE)
data <- data.frame(df) # raw data saved as variable 'data'

## Variables assigning
x_site <- data$x  # x location
y_site <- data$y  # y location
time <- data$time # Time
conc <- data$data # TP
x_site <- as.matrix(x_site)
y_site <- as.matrix(y_site)
time <-  as.matrix(time)
conc <- as.matrix(conc)

## Data editing
z1 <- matrix(rep(0,25), nrow=5)
z2 <- matrix(rep(0,25), nrow=5)
z3 <- matrix(rep(0,25), nrow=5)
z4 <- matrix(rep(0,25), nrow=5)
z5 <- matrix(rep(0,25), nrow=5)

for (i in 1:nrow(data)){
  if(time[i]==1){
    z1[x_site[i],y_site[i]] <- conc[i]
  }
  if(time[i]==2){
    z2[x_site[i],y_site[i]] <- conc[i]
  }
  else if(time[i]==3){
    z3[x_site[i],y_site[i]] <- conc[i]
  }
  else if(time[i]==4){
    z4[x_site[i],y_site[i]] <- conc[i]
  }
  else{
    z5[x_site[i],y_site[i]] <- conc[i]
  }
}

## 4D plot
p1 <- plot_ly(showscale=TRUE) %>%
  add_surface(z=~z1, cmin=min(conc), cmax=max(conc), color=~z1) %>%
  layout(scene=list(zaxis=list(range=c(min(conc),max(conc)))))
  
p2 <- plot_ly(showscale = TRUE) %>%
  add_surface(z=~z1, cmin=min(conc), cmax=max(conc), color=~z1) %>%
  add_surface(z=~z2, cmin=min(conc), cmax=max(conc), color=~z2) %>%
  add_surface(z=~z3, cmin=min(conc), cmax=max(conc), color=~z3) %>%
  add_surface(z=~z4, cmin=min(conc), cmax=max(conc), color=~z4) %>%
  add_surface(z=~z5, cmin=min(conc), cmax=max(conc), color=~z5) %>%
  layout(scene=list(zaxis=list(range=c(min(conc),max(conc)))))

p1
p2



