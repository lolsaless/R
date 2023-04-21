x <- rnorm(10)

str(range(x))
range(x)[2]

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}


(x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

a <- x - range(x, na.rm = TRUE)[1]
b <- max(x, na.rm = TRUE) - min(x, na.rm = TRUE)

a/b
rescale01(x)
rescale01(5)
rescale01(c(0,1,2,3,4,5))

function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}


function(x) {
  mean_x = mean(is.na(x))
  
}

f1 <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}

f2 <- function(x) {
  if (length(x) <= 1) return(NULL)
  x[-length(x)]
}

f3 <- function(x, y) {
  rep(y, length.out = length(x))
}

f1(c("abc", "abcde", "ad"), "ab")

!(5%%3)
fizzbuzz <- function(x) {
  # these two lines check that x is a valid input
  stopifnot(length(x) == 1)
  stopifnot(is.numeric(x))
  if (!(x %% 3) && !(x %% 5)) {
    "fizzbuzz"
  } else if ((x %% 3) == 0) {
    "fizz"
  } else if ((x %% 5) == 0) {
    "buzz"
  } else {
    # ensure that the function returns a character vector
    as.character(x)
  }
}
fizzbuzz(6)
#> [1] "fizz"
fizzbuzz(10)
#> [1] "buzz"
fizzbuzz(15)
#> [1] "fizzbuzz"
fizzbuzz(2)
#> [1] "2"