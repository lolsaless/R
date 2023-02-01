library(stringr)
x <- "\u00b5"
x

str_c("x", "y")
str_c("x", "y", sep = "; ")
x <- c("abc", NA)
x
str_c("|-", x, "-|", sep = "")
str_c("|-", str_replace_na(x), "-|", sep = "")

str_c("prefix-", c("a","b","c"), "-suffix")

name <- "Cho"
time <- "morning"
birthday <- FALSE

str_c(
  "good ", time, " ", name
)
str_c(
  "good ", time, " ", name,
  if(birthday) " and", "."
)


x <- c("Apple", "Banana", 'Pear')
x
str_sub(x, 1, 1)
str_to_lower((str_sub(x,1,1)))

str_sub(x, 1, 1) <- str_to_lower((str_sub(x,1,1)))
x

dot <- "\\."
dot <- "\."
dot <- "."
dot
writeLines(dot)
str_view(c("abc", "a.c", "bef"), "a\\.c")
x
str_view(x, ".a.")
library(htmlwidgets)
