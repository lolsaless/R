x<-list(c(1,2,3),c(4,5,6))
x

lapply(x, rbind)
do.call(rbind, x)


#lapply함수는 각각의 리스트 요소에 인수로 받은 함수를 적용
#do.call함수는 함수의 인수에 리스트의 각각요소를 제공
#

final <- NULL
for(i in 1:10){
  
  a <- c(1,2,3)
  final <- rbind(final, a)
}
final

list1 <- list()
for (i in 1:10){
  
  a <- c(1,2,3)
  list1[[i]] <- a
}

list1

lapply(list1, rbind)
do.call(rbind, list1)


iris_num <- NULL
for (i in 1:ncol(iris)) {
  if(is.numeric(iris[,i]))
    iris_num <- cbind(iris_num, iris[,i])
}

iris_df <- data.frame(iris_num)
iris_df

dim(iris)

iris

iris_num_sapply <- iris[, sapply(iris, is.numeric)]
iris_num_sapply

d <- matrix(1:9, ncol = 3)
