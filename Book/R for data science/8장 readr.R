library(tidyverse)
parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))

parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")

#미주방식
parse_number("$123,456,789")
#유럽방식
parse_number("123.456.789",
             locale = locale(grouping_mark = "."))
#스위스방식
parse_number("123'456'789",
             locale = locale(grouping_mark = "'"))

#문자열
charToRaw("조의호")
charToRaw("Hadley")

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

charToRaw("こんにちは")


guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

a <- today()
parse_date("2010-10-01")
