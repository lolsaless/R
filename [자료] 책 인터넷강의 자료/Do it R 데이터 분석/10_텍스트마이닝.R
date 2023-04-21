install.packages("multilinguer")
library(multilinguer)
install_jdk()

install.packages(c("hash", "tau", "Sejong", "RSQLite", "devtools", "bit", "rex",
                   "lazyeval", "htmlwidgets", "crosstalk", "promises", "later",
                   "sessioninfo", "xopen", "bit64", "blob", "DBI", "memoise", "plogr",
                   "covr", "DT", "rcmdcheck", "rversions"), type = "binary")

install.packages("remotes")


#KoLNP 패키지 설치
remotes::install_github('haven-jeon/KoNLP', upgrade = "never",
                        INSTALL_opts=c("--no-multiarch"))

library(KoNLP)

library(KoNLP) #최종적으로 "KoNLP" 패키지를 불러옵니다
extractNoun('테스트 입니다')
install.packages("KoNLP_0.80.2.tar.gz", type="source", repos=NULL)

useNIADic()

txt <- readLines("hiphop_utf-8.txt", encoding = "UTF-8")
head(txt)

#특수문자 제거하기
library(stringr)
txt <- str_replace_all(txt, "\\W", " ")

#명사 추출하기
extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")

#가사에서 명사 추출
nouns <- extractNoun(txt)

#추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))
df_word <- as.data.frame(wordcount, stringsAsFactors = FALSE)

library(tidyverse)
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

#두 글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)

nchar("wwwwww")

top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)
top20

#워드클라우드 패키지
install.packages("wordcloud")
library(wordcloud)
library(RColorBrewer)

#Dark2 색상목록에서 8개 색상 추출
pal <- brewer.pal(8, "Dark2")
#난수 고정하기
set.seed(1234)

wordcloud(words = df_word$word,  # 단어
          freq = df_word$freq,   # 빈도
          min.freq = 2,          # 최소 단어 빈도
          max.words = 200,       # 표현 단어 수
          random.order = FALSE,  # 고빈도 단어 중앙 배치
          rot.per = .1,          # 회전 단어 비율
          scale = c(4, 0.3),     # 단어 크기 범위
          colors = pal)          # 색상 목록

pal <- brewer.pal(9, "Blues")[5:9]
set.seed(1234)
wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 2,
          max.words = 200,
          random.order = FALSE,
          rot.per = .1,
          scale = c(4, 0.3),
          colors = pal)

#국정원 트윗 텍스트 마이닝
twitter <- read.csv("twitter.csv",
                    header = TRUE,
                    fileEncoding = "UTF-8")

twitter <- rename(twitter,
                  no = 번호,
                  id = 계정이름,
                  date = 작성일,
                  tw = 내용)

twitter$tw <- str_replace_all(twitter$tw, "\\W", " ")
twitter[10,5]

nouns <- extractNoun(twitter$tw)
wordcount <- table(unlist(nouns))
df_word <- as.data.frame(wordcount)
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

df_word <- filter(df_word, nchar(word) >= 2)

df_word$word <- as_vector(df_word$word)
class(df_word$word)
