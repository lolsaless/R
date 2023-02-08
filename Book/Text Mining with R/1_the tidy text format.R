text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")

text_df <- tibble(line = 1:4, text = text)
text_df

library(tidytext)

text_df %>% 
  unnest_tokens(word, text)
library(janeaustenr)
library(dplyr)
library(stringr)

original_books <- austen_books() %>% 
  group_by(book) %>% 
  mutate(line_number = row_number(),
         chapter = cumsum(str_detect(text,
                                     regex("^chapter [\\divxlc]",
                                           ignore_case = TRUE)))) %>% 
  ungroup()


#str_detect
xx<-c("네이버","네이버에서","네이버를","naver","naver에서","naver는","중앙일보","동아일보") 
str_detect(xx, 'sp')