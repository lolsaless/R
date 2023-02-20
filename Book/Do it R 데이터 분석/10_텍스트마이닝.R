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
