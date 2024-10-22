# 필요한 라이브러리 설치
install.packages("ggplot2")

# 라이브러리 로드
library(ggplot2)

# 데이터 프레임 생성
data <- data.frame(
  Product = c('제주삼다수', '제주삼다수', '에브리데이산', '에브리데이산수', '아이시스(평화공원산림수)', '아이시스(평화공원산림수)', '평창수', '평창수', '아이시스(백학음료)', '아이시스(백학음료)', '백산수', '백산수', '지리산청정수', '지리산청정수', '동원샘물', '동원샘물'),
  Type = c('최소', '최대', '최소', '최대', '최소', '최대', '최소', '최대', '최소', '최대', '최소', '최대', '최소', '최대', '최소', '최대'),
  Ca = c(2.5, 4, 8.4, 15.5, 21.1, 28.1, 13.2, 19.99, 21.1, 28.1, 3, 5.8, 12.3, 13.6, 17, 28.3),
  K = c(1.5, 3.4, 1.2, 1.8, 1.1, 1.7, 0.6, 0.82, 1.1, 1.7, 1.4, 5.3, 0.1, 1.1, 0.5, 1.1),
  Na = c(4, 7.2, 5.9, 17.7, 3.9, 4.9, 5.46, 7.63, 3.9, 4.9, 4, 12, 4.2, 4.9, 5.4, 11.1),
  Mg = c(1.7, 3.5, 1.8, 2.2, 5, 6.8, 2.32, 2.79, 5, 6.8, 2.1, 5.4, 0.3, 1.3, 1.7, 3),
  F = c(0, 0, 0.1, 0.3, 0, 0.1, 0.01, 0.18, 0, 0.1, 0, 1, 0, 0.2, 0.2, 0.5),
  Address = c('제주시 조천읍 남로로 1717-35', '제주시 조천읍 남로로 1717-35', '경기도 남양주시 수동면 외방리 산19', '경기도 남양주시 수동면 외방리 산19', '경기도 연천군 백학면 두현리 1081-11', '경기도 연천군 백학면 두현리 1081-11', '강원도 평창군 봉평면 진로리 222번지', '강원도 평창군 봉평면 진로리 222번지', '경기도 연천군 백학면 두현리 1081-11', '경기도 연천군 백학면 두현리 1081-11', '백두산', '백두산', '경상남도 산청군 삼장면 친환경로 460-22', '경상남도 산청군 삼장면 친환경로 460-22', '경기도 연천군 청산면 대전리 산167-4', '경기도 연천군 청산면 대전리 산167-4')
)

# 상자 그림 생성
ggplot(data, aes(x=Product, y=Ca, fill=Type)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  labs(title="상자 그림(Ca)", x="제품명", y="Ca 값")
