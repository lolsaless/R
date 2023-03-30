library(stringr)

x <- "abc ABC 123 .!?\\(){}"
x2 <- "abc ABC 123 .!?\\\\(){}"

writeLines(x2)

str_view(x, "a")
str_view(x, "\\.")
str_view(x, "\\!")
str_view(x2, "\\\\\\\\")
str_view(x, "\\.")

str_view(words, "^x|x$")
str_view(words, "(^[aeiou]|[^aeiou]$)")
str_view(words, "^[aeiou].*[^aeiou]$")

str_subset(words, "^[aeiou].*[^aeiou]$")

vowels <- str_count(words, "[aeiou]")
words[which(vowels == max(vowels))]

length(sentences)

head(sentences)

color <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c(color, collapse = "|")

color_match

has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
head(matches)

more <- sentences[str_count(sentences, color_match) > 1]
more

str_view_all(more, color_match)
str_view(more, color_match)

str_extract_all(more, color_match, simplify = TRUE)

librar