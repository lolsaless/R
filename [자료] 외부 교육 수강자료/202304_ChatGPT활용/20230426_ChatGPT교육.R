library(dplyr)

# 데이터프레임 생성
df <- data.frame(
    dept = c("인사팀", "인사팀", "총무팀", "관리팀", "기획팀", "영업팀", "생산팀", "인사팀", "기술팀", "마케팅팀", "인사팀", "영업팀", "총무팀", "기획팀", "생산팀", "인사팀", "기술팀", "마케팅팀", "인사팀", "영업팀"),
    position = c("부장", "과장", "사원", "대리", "과장", "부장", "과장", "대리", "사원", "과장", "사원", "대리", "부장", "대리", "사원", "과장", "대리", "사원", "부장", "과장"),
    gender = c("남자", "여자", "남자", "여자", "남자", "여자", "남자", "여자", "남자", "여자", "여자", "남자", "여자", "남자", "여자", "남자", "남자", "여자", "여자", "남자"),
    basic_pay = c(768790, 891400, 891400, 953400, 953400, 768790, 891400, 953400, 891400, 768790, 891400, 953400, 891400, 768790, 891400, 953400, 891400, 768790, 891400, 953400),
    tax = c(69890, 81036, 81036, 86763, 86673, 69890, 81036, 86763, 81036, 69890, 81036, 86763, 81036, 69890, 81036, 86763, 81036, 69890, 81036, 86763),
    payment = c(698900, 810364, 810364, 866637, 866727, 698900, 810364, 866637, 810364, 698900, 810364, 866637, 810364, 698900, 810364, 866637, 810364, 698900, 810364, 866637)
)

# 인사팀, 대리, 남자의 기본급 합계
df %>%
    filter(dept == "관리팀" & position == "대리" & gender == "여자") %>%
    summarize(sum_basic_pay = sum(basic_pay))


#새로운 데이터 프레임 생성
library(dplyr)

# 할인율 변수 추가
new_df <- df %>%
    mutate(discount_rate = runif(n(), 0.005, 0.02))


# 할인율 변수 추가
new_df <- df %>%
    mutate(discount_rate = seq(from = 0.5, to = 2, by = 0.5)[sample(n(), replace = TRUE)])

new_df

new_df <- df %>%
    mutate(discount_rate = sample(seq(from = 0.5, to = 2, by = 0.5), size = n(), replace = TRUE, prob = NULL)) %>%
    replace_na(list(discount_rate = 0))


library(dplyr)
library(tidyr)

# 할인율 변수 추가
new_df <- df %>%
    mutate(discount_rate = sample(seq(from = 0.5, to = 2, by = 0.5), size = n(), replace = TRUE, prob = NULL)) %>%
    replace_na(list(discount_rate = 0))

new_df

# 할인율 변수 추가
new_df <- df %>%
    mutate(discount_rate = ifelse(is.na(discount_rate), sample(seq(from = 0.5, to = 2, by = 0.5), size = sum(is.na(discount_rate)), replace = TRUE, prob = NULL), discount_rate))

new_df %>% group_by(gender) %>% 
    summarise(sum_pay = sum(basic_pay),
              mean_pay = mean(basic_pay))

