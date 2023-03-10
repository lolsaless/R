#JAVA mac x64DMG installer 설치
#https://selenium-release.storage.googleapis.com/index.html selenium 다운로드
#https://github.com/mozilla/geckodriver/releases geckordriver다운로드
#https://chromedriver.chromium.org/downloads (크롬드라이버 다운로드)
#Mac cd /Users/lolsaless/Documents/selenium 폴더이동
#windows cd 후 폴더명 기입
#ls로 파일명 확인
#java -Dwebdriver.gecko.driver="geckodriver" -jar selenium-server-standalone-4.0.0-alpha-2.jar -port 4445 터미널에서 실행

library(RSelenium)

remDr = remoteDriver(remoteServerAddr = "localhost",
                     port = 4445L,
                     browserName = "chrome")

remDr$open()
remDr$navigate("https://naver.com")

library(rvest)
library(httr)

r <- remDr$getPageSource()[[1]]
read_html(r)
