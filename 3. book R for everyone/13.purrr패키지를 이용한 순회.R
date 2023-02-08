library(purrr)

theList <- list(
  A = matrix(1:9, 3),
  B = 1:5,
  C = matrix(1:4, 2),
  D = 2
)

theList

theList2 <- theList

theList[[1]][2,1]
theList[1,2]
theList[[2]][4]

