str(iris)
head(iris, 10)

irisMat2 <- as.matrix(iris[, 1:4])
head(irisMat2)

apply(iris[, 1:4], MARGIN = 1, FUN = mean)

apply(iris[, 1:4], MARGIN = 2, FUN = mean)

avg <- 0
for(i in 1:nrow(iris)) {
  row = iris[i, 1:4]
  row = as.numeric(row)
  avg[i] <- mean(row)
}
avg

n <- 300000
set.seed(seed = 1234)
univ <- data.frame(
  국어 = sample(40:100, size = n, replace = TRUE),
  영어 = sample(40:100, size = n, replace = TRUE),
  수학 = sample(40:100, size = n, replace = TRUE)
)

str(univ)
head(univ, 10)

apply(univ, MARGIN = 2, FUN = mean)

lapply(univ, mean)
sapply(univ, mean)

sapply(univ, FUN = function(i) {
  result <- length(i[i >= 70])
  return(result)
})

#매개변수(univ)에 지정된 데이터프레임의 각 원소(열벡터)를 function()함수로 전달하면 function()함수는 넘겨받은 벡터를 i에 지정하고, 중괄호 안의 코드를 실행한다.
#벡터 i의 각원소가 70이상인지 비교 연산으로 실행하면, 논리형 벡터로 변환된다. 논리형 벡터로 불리언 인덱싱을 하면 벡터 i에서 70이상인 원소만 남는다. lenght()함수는 벡터i에서 70이상인 원소읭 개수를 result에 할당한다.
#univ의 각 원소(열벡터)별로 스칼라인 result가 반환되므로 최종결과는 스칼라를 모은 벡터로 반환된다.
#sapply()함수가 반환봗은 벡터를 출력한다.

