library(tidyverse)
library(stringr)

c <- "\u00b5"
c
str_length(c("a", "R for data science", NA))

str_c("x", "y")
str_c("x", "y", "z", sep = ", ")
str_c("x", "y", "z", sep = ",")

x <- c("abc", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x), "-|")

str_c("prefix-", c("a", "b", "c"), "-suffix")

name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)

str_c(c("x", "y", "z"), collapse = ", ")

#문자열 서브셋하기
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
str_sub(x, 2, 3)
str_sub(x, -3, -1)

str_sub("a", 1, 5)

str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x


str_c("x", "y", "z", collapse = ", ")
str_c("x", "y", "z", sep = ", ")
str_c(c("x", "y", "z"), c("x", "y", "z"), collapse = ", ")
str_c(c("x", "y", "z"), c("x", "y", "z"), c("x", "y", "z"), sep = ", ")

x <- str_c("a", "abc", "abcd", "abcde", "abcdef", collapse = ", ")
x <- str_c("a", "abc", "abcd", "abcde", "abcdef", sep = ", ")
x <- c("a", "abc", "abcd", "abcde", "abcdef")

L <- str_length(x)
m <- ceiling(L / 2)
str_sub(x, m, m)


str_trim(" abc ")
#> [1] "abc"
str_trim(" abc ", side = "left")
#> [1] "abc "
str_trim(" abc ", side = "right")
#> [1] " abc"

str_pad("abc", 5, side = "both")
#> [1] " abc "
str_pad("abc", 4, side = "right")
#> [1] "abc "
str_pad("abc", 4, side = "left")
#> [1] " abc"

str_pad("abc", 5, side = "left")

x <- c("apple", "banana", "pear")
str_view(x, "an")
str_view(x, ".a.")

dot <- "\\."
dot
writeLines(dot)

str_view(c("abc", "a.c", "bef"), "a\\.c")

x <- "a\\b"
writeLines(x)

str_view(x, "\\\\")

"\"'\\"
str_view("\\")

str_view("\"'\\", "\"'\\\\", match = TRUE)

str_view("\"'\\", "\"'\\\\", match = TRUE)

str_view("\\..\\..\\..")
str_view(c(".a.b.c", ".a.b", "....."), c("\\..\\..\\.."), match = TRUE)

str_view(x, "^a")
str_view(x, "a$")

str_view("$^$")

str_view(c("$^$", "ab$^$sfas"), "^\\$\\^\\$$", match = TRUE)
str_view("\\s")
str_view("\\sw", "\\s", match = TRUE)

words
str_view(words, "y$")
str_view(words, "x$")
str_length(words, 3)
str_view(words, "^...$")

str_subset(words, "[u]$")
str_subset(words, "eed$")
str_subset(words, "[^e]ed$")

str_subset(words, "i(ng|se)")
str_subset(words, "i(ng|ze)")

str_subset(stringr::words, "(cei|[^c]ie)")


str_view(words, "q[^u]", match = TRUE)
x <- c("123-456-7890", "(123)456-7890", "(123) 456-7890", "1235-2351")
str_view(x, "\\d\\d\\d-\\d\\d\\d-\\d\\d\\d\\d")
str_view(x, "[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]")
str_view(x, "\\(\\d\\d\\d\\)\\s*\\d\\d\\d-\\d\\d\\d\\d")
str_view(x, "\\([0-9][0-9][0-9]\\)[ ]*[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]")
str_subset(x, "\\d\\d\\d-\\d\\d\\d-\\d\\d\\d\\d")

str_view(x, "\\d{3}-\\d{3}-\\d{4}")

str_view(x, "\\(\\d{3}\\)\\s*\\d{3}-\\d{4}")

x <- "1988 is the longest year in Roman numerals: MDCCCLXXX,XXXX,XXXXX,XXXXXX,XXVIII"
str_view(x,"MD?")
str_view(x, "CC+")
str_view(x, "CC*")
str_view(x, "XX*")
str_view(x, "XX?")
str_view(x, "XX+")

str_view(x, "CC*[LX]+")

str_view(x, "X{2}")
str_view(x, "X{2,}")
str_view(x, "X{3,4}")

str_view(x, "C{2,3}?")
str_view(x, '[LX]')

str_view_all(x, "C[LX]+")
str_view(x, "C[LX]+")
str_view_all(x, "C[LX]{1,}")
str_view_all(x, "C[LX]*")

x <- c("dog", "$1.23", "lorem ipsum")

str_view(x, "^.*$")

x <- c("{a}", "{abc}")
str_view(x, "\\{.+\\}")
x <- "2018-01-11"
str_view(x, "\\d{4}-\\d{2}-\\d{2}")

x <- "\\\\\\\\"
str_view(x, "\\\\{4}")

str_view(words, "^[^aeiou]{4}", match = TRUE)
str_view(words, "^[^aeiou]{3}", match = TRUE)

str_view(x, "\\d{3}-[0-9]{3}-\\d{4}")

str_view(words, "[aeiou]{3}")
str_view(words, "([aeiou]|[^aeiou]){2}")
str_view(words, "([aeiou]|[^aeiou]){2}")
str_view(words, "([aeiou][^aeiou]){2}")

str_view(fruit, "(..)\\1")
str_view("aaa", "(.)\\1\\1")

str_subset(words, "^(.)((.*\\1$)|\\1?$)")
str_subset(words, "^(...........)")

str_view(words, "^(.)(.*\\1$)")
str_view(words, "(.)\\1$")
str_view(words, "^(.)(.*\\1$)")
str_subset(words, "^(.)((.*\\1$)|\\1?$)")
str_view(words, "^(.)((.*\\1$)|\\1?$)")
str_subset(words, "([A-Za-z][A-Za-z]).*\\1")
str_view("abba", "(.)(.)\\2\\1")
str_view("a1a1", "(..)\\1")

str_subset("eleven", "([a-z]).*\\1.*\\1")
str_subset("eleven", "([a-z]).*\\1.*\\1")
str_subset(words, "([a-z]).*\\1.*\\1")

no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
no_vowels_1 <- !str_detect(words, "[aeiou]")

identical(no_vowels_1, no_vowels_2)

df <- tibble(
  word = words,
  i = seq_along(word)
)
df %>% filter(
  str_detect(word, "x$")
)

df %>% 
  mutate(vowels = str_count(word, "[aeiou]"),
         consonants = str_count(word, "[^aeiou]"))
