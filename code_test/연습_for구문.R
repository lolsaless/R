fun <- function(x,y) {
  print(x + y)
}


fun(1,2)




for(i in 1:20) {
  if (i%%2 == 0) {
    print(i+10)
  } else {
    print(i)
  }
}

print(10, '1')


while (i <= 10) {
  print(i)
  i <- i+1
}


while(i <= 10) {
  print(i)
  i <- i+1
}


for_list <- list()
for(i in 1:20) {
  for_list[[i]]
}

print(for_list)


price_list <- list()
for (i in 1:20) {
  price_list[[i]] <- 2
}
price_list <- do.call(cbind, price_list)


for_list = list()
for (i in 1:4) {
  for (ii in 1) {
    for_list[[i]] = i+ii
  }
}
print(for_list)
