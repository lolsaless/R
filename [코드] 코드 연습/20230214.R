#Purrr
library(tidyverse)
theList <- list(
  A = matrix(1:9, 3),
  B = 1:5,
  C = matrix(1:4,2),
  D = 2
)

theList

lapply(theList, sum)

library(purrr)
theList %>% map(sum)
theList %>% lapply(., sum)

identical(lapply(theList, sum), theList %>% map(sum))

m_list <- list(
  a = list(12:20,
    b = list(13:30,
      c = 1:9
    )
  )
)
m_list[[1]][2]
m_list[[1]][1]

theList2 <- theList
theList2[[1]][2,1] <- NA
theList2[[2]][4] <- NA
theList2

theList2 %>% map(function(x) sum(x, na.rm = TRUE))

theList %>% map_int(NROW)
theList

theList %>% map_int(function(x) mean(x))


theList3 <- list(
  a = 1:10,
  b = 2:30,
  c = seq(1,10,2)
)
theList3

theList %>% map_int(mean)
theList %>% map_dbl(mean)

theList %>% map_chr(class)

theList3
