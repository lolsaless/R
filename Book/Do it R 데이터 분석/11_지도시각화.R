install.packages("mapproj")
install.packages("ggiraphExtra")
library(ggiraphExtra)
str(USArrests)
head(USArrests)
#지역명 변수 설정하기

library(tibble)

?rownames_to_column
crime <- rownames_to_column(USArrests, var = "state")
crime
#소문자로 만들기
crime$state <-tolower(crime$state)

str(crime)

install.packages("maps")
library(ggplot2)

states_map <- map_data("state")
str(states_map)

#단계 구분도 만들기
ggChoropleth(data = crime,
             aes(fill = Murder,
                 map_id = state),
             map = states_map)

ggChoropleth(data = crime,
             aes(fill = Murder,
                 map_id = state),
             map = states_map,
             interactive = TRUE)