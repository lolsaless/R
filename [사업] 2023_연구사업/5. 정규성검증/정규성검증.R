library(MASS)
library(ggplot2)
library(ggpubr)

# 제공된 데이터
Ca_values <- c(3.16, 4.44, 9.93, 6.79, 13.93, 11.89, 11.65, 17.65, 10.81, 8.84, 26.81, 21.82, 42.11)
ln_Ca_values <- log(Ca_values)

# 대수정규분포의 모수 추정
fit <- fitdistr(Ca_values, "lognormal")

# K-S test 수행
ks_result <- ks.test(ln_Ca_values, "plnorm", meanlog = fit$estimate[1], sdlog = fit$estimate[2])

# Z value 계산
z_value <- ks_result$statistic * sqrt(length(Ca_values))

print(paste("K-S statistic:", ks_result$statistic))
print(paste("p-value:", ks_result$p.value))
print(paste("Z value:", z_value))

# Q-Q plot 그리기
ggqqplot(ln_Ca_values, distribution = "lnorm", meanlog = fit$estimate[1], sdlog = fit$estimate[2])

if (ks_result$p.value > 0.05) {
    print("The data follows a log-normal distribution (at 5% significance level).")
} else {
    print("The data does not follow a log-normal distribution (at 5% significance level).")
}

# 데이터 저장
data <- data.frame(Sample = 1:length(Ca_values), Ca = Ca_values, ln_Ca = ln_Ca_values)
write.csv(data, "Ca_values.csv", row.names = FALSE)
print("Data saved to Ca_values.csv")
