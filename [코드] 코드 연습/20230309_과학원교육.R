data <- data.frame(stn = c("서울", "부산", "대전", "대구", "인천", "광주"),
                   temp = c(22.7, 25.3,  25.4, 24.9, 22.9, 24.8),
                   prec = c(0, 18.5, 4, 10.4, 0, 0),
                   ws = c(0.5, 1.2, 0.9, 1.2, 0.7, 2.4),
                   rh = c(87, 97, 96, 97, 85, 84))

data <- as_tibble(data)

data <- data %>% mutate(color = ifelse(prec > 0, "blue", "black"))

data[data$prec>0, "color"] = "blue"
data[data$prec==0, "color"] = "black"
    
barplot(data$prec, names.arg = data$stn, col = data$color, main = "강수량")
barplot(data$prec, names.arg = data$stn, color = data$color, main = "강수량") #color는 그래픽 매개변수가 아님.

data[data$temp == max(data$temp),]

pororo <- data.frame(id = c("뽀로로", "크롱", "에디", "포비", "해리", "루피"),
                     math = c(81, 86, 98, 62, 86, 79),
                     eng = c(89, 63, 75, 65, 95, 93),
                     kor = c(92, 73, 86, 78, 93, 89))

pororo$total <- pororo$math + pororo$eng + pororo$kor

pororo$avg <- pororo$total/3

pororo[pororo$avg >= 80, "pass"] = "합격"
pororo[pororo$avg < 80, "pass"] = "불합격"

pororo %>% mutate(pass = ifelse(avg >= 80, "합격", "불합격"))
pororo[pororo$total == max(pororo$total), "id"]
pororo[pororo$total == min(pororo$total), "id"]
#or를 사용하여 [인덱스]안에 중복으로 설정할 수 있다.
pororo[pororo$total == max(pororo$total) | pororo$total == min(pororo$total), "id"]
pororo %>% filter(total == max(total)) %>% select(id)
pororo %>% filter(total == min(total)) %>% select(id)

#엑셀 데이터 복사 붙여넣기.
install.packages("clipr")
library(clipr)
#엑셀 시트 일부 영역을 복사하고, 아래 명령어 실행하면, 복사된 자료가 data.frame형태로 생성된다.
exam = read.table("clipboard")

#내보내고 싶은 자료 아래 명령어 실행 후, 엑셀에 붙여넣기 하면 된다.
write_clip(pororo)

library(readxl)
school_data <- read_xlsx("2019년_공시대상학교정보(전체).xlsx", col_names = TRUE)

school_data
data2 <- as.data.frame(school_data)

table(data2$설립구분)

data2 <- data2 %>% mutate(col = ifelse(설립구분 == "국립", "red",
                                       ifelse(설립구분 == "공립", "blue", "green")))
table(data2$col)

#위경도 자료로 지도그리기
install.packages("raster")
library(raster)

kor = getData("GADM", country = "KOR", level = 1)
kor = getData("GADM", country = "KOR", level = 2)
plot(kor)
#레벨에 따라서 구역이 세분화 된다.
#데이터집합@
table(kor@data$NAME_1)

kor2 <- subset(kor, NAME_1 %in% "Seoul")
plot(kor2)

data3 <- data2[data2$시도교육청 == "서울특별시교육청",]
points(data3$경도, data3$위도, col = data3$col, pch = 16, cex = 0.2)

table(data3$설립구분)
table(data3$col)
str(data3)
data3$설립일 <- as.numeric(data3$설립일)
data3[data3$설립일 == min(data3$설립일) | data3$설립일 == max(data3$설립일), "학교명"]

#raster와 dplyr과 충돌하여 select함수 실행 안됨
data3 %>% filter(설립일 == max(설립일)) %>% select(col)
str(data3$설립일)

library(tidyverse)
exam %>% filter(class == 1)
exam %>% filter(english >= 90 & class == 1)
exam %>% filter(class != 3)
exam %>% filter(class %in% c(1, 3, 5))

exam %>% filter(class %in% c(1,2)) %>% group_by(class) %>% 
  summarise(mean_math = mean(math),
            mean_english = mean(english))
mpg
displ_4 <- mpg %>% filter(displ <= 4)
displ_5 <- mpg %>% filter(displ >= 5)

mean(displ_4$hwy)
mean(displ_5$hwy)

mpg %>% mutate(test = ifelse(displ <= 4, 4, 5)) %>% group_by(test) %>% 
  summarise(test_hwy = mean(hwy))

mpg %>% filter(manufacturer %in% c("audi", "toyota")) %>% group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty))

mpg %>% filter(manufacturer %in% c("chevrolet", "ford", "honda")) %>% 
  summarise(mean_hwy = mean(hwy))

exam %>% select(id, math)

exam %>% filter(class %in% c(1, 3)) %>% select(id, english)

exam %>% filter(class == 5 & english > 80) %>% 
  select(id)

a <- mpg %>% filter(manufacturer %in% c("audi", "toyota")) %>% 
  select(cty)

mpg_data <- mpg %>% select(class, cty)
head(mpg_data)

mpg_data %>% filter(class %in% c("suv", "compact")) %>% group_by(class) %>% 
  summarise(mean_cty = mean(cty))

mpg %>% arrange(-cyl)
mpg %>% arrange(desc(hwy))

mpg %>% arrange(cyl, desc(hwy))

mpg %>% filter(manufacturer == "audi") %>% select(hwy, model) %>% 
  arrange(desc(hwy)) %>% 
  head(5)

exam %>% mutate(test = ifelse(science >= 60, "pass", "fail")) %>% 
  head(5)

mpg2 <- mpg %>% mutate(total = cty + hwy)
mpg2 <- mpg2 %>% mutate(avg = total/2)
mpg2 %>% select(model, avg) %>% 
  arrange(desc(avg)) %>% 
  head(3)

mpg %>% mutate(total = cty + hwy,
               avg = total/2) %>% 
  select(model, avg) %>% 
  arrange(desc(avg)) %>% 
  select(model) %>% 
  head(3)

mpg %>% filter(class == "suv") %>% 
  select(manufacturer, cty, hwy) %>% 
  mutate(total = cty, hwy,
         avg = total/2) %>% 
  group_by(manufacturer) %>% 
  arrange(desc(5))

mpg %>% filter(class == "suv") %>% 
  group_by(manufacturer) %>% mutate(total = cty + hwy) %>% 
  summarise(avg = mean(total)) %>% 
  arrange(desc(avg)) %>% 
  head(5)


mpg %>% select(class, cty) %>% 
  group_by(class) %>% 
  summarise(avg_cty = mean(cty)) %>% 
  arrange(desc(avg_cty))

mpg %>% select(manufacturer, hwy) %>% 
  group_by(manufacturer) %>% 
  summarise(avg_hwy = mean(hwy)) %>% 
  arrange(desc(avg_hwy)) %>% 
  head(3)

mpg %>% filter(class == "compact") %>% 
  select(manufacturer, class) %>% 
  group_by(manufacturer) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))


test1 <- data.frame(id = c(1,2,3,4,5),
                    midterm = c(60,80,70,90,85))
test2 <- data.frame(id = c(1,2,3,4,5),
                    final = c(70,83,65,95,80))

head(test1)
head(test2)

left_join(test1, test2, by = "id")
merge(test1, test2, by = "id")

test1 %>% rename(a = "id",
                 b = "midterm")


df_midwest <- midwest %>% mutate(kids = (poptotal - popadults)/poptotal *100)

df_midwest %>% select(county, kids) %>% 
  arrange(desc(kids)) %>% 
  head(5)

df_midwest %>% mutate(grade = ifelse(kids >= 40, "large",
                                                   ifelse(kids >= 30, "middle", "small"))) %>% 
  group_by(grade) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))

table(df_midwest$grade)

df_midwest %>% mutate(asia_ratio = (popasian/poptotal)*100) %>% 
  arrange(-asia_ratio) %>% 
  select(state, county, asia_ratio) %>%  
  tail(10)

midwest %>% mutate(kids = (poptotal - popadults) / poptotal * 100,
                   grade = ifelse(kids >= 40, "large",
                                  ifelse(kids >= 30, "middle", "small"))) %>% 
  group_by(grade) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))

df <- data.frame(sex = c("M", "F", NA, "M", "F"),
                 score = c(5, 4, 3, 4, NA))
is.na(df)

which(is.na(df$score))

mean(df$score, na.rm = TRUE)

df %>% filter(!is.na(score))
df %>% filter(is.na(score))
df[!is.na(df$score),]

na.omit(df)
df[complete.cases(df),]

exam2 <- exam

exam2[c(5, 10, 15), "math"] = NA
exam2 %>% mutate(math2 = ifelse(is.na(math),
                                mean(math, na.rm = TRUE),
                                math))

#결측치 관리법
#결측치를 평균으로 하면, 값이 감소하는 경향을 알 수 없다.
data <- data.frame(time = paste0(seq(1, 24), ":00"),
                   pcp = c(seq(24, 1, by = -1)))
data[5:10, "pcp"] = NA
data

library(zoo)

#결측치를 마지막으로 관측된 값으로 넣는다. na.locf
na.locf(data$pcp)
#결측값을 점점 감소하는 값으로 채워준다. na.approx
na.approx(data$pcp)

#이상치 outlier
outlier <- data.frame(sex = c(1, 2, 1, 3, 2, 1),
                      score = c(5, 4, 3, 4, 2, 6))

box_hwy <- boxplot(mpg$hwy)
box_hwy$out

boxplot(mpg$hwy)$stats


#크롤링
library(XML)
library(RCurl)

url2<-getURL("https://www.weather.go.kr/w/obs-climate/land/city-obs.do")
tables<-as.data.frame(readHTMLTable(url2,encoding='UTF-8'))
names(tables)<-
  c("id","current","vis","cloud","l.cloud","Tcurrent","dew","sensible","prec","rh","dir","ws","hpa")
head(tables)


#이미지 얼굴인식
library(magick)
library(image.libfacedetection)

image <- image_read("http://photo.jtbc.joins.com/news/2019/06/24/20190624095608385.jpg")
image

faces <- image_detect_faces(image)
faces
plot(faces, image, border = "red", lwd = 7, col = "white")

