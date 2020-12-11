
codes = data.frame(a = c(1:17),
                   b = c('서울', '부산', '대구', '인천','광주', '대전', '울산', '경기','강원', '충북','충남', '전북',
                         '전남', '경북','경남', '제주', '세종'))


for (i in 1:17) {
  if(i > 5) {
    print(i)
  }
}

###성공했다. ㅋㅋㅋㅋ
for (i in 1:17) {
  for (ii in Codes$a) {
    if (i == ii){
      print(Codes$b[[ii]])
    }
  }
}
