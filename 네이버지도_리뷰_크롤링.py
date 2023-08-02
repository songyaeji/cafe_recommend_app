pip install selenium

pip install requests

# selenium의 webdriver를 사용하기 위한 import
from selenium import webdriver

# selenium으로 키를 조작하기 위한 import
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
import time # 페이지 로딩을 기다리는데에 사용할 time 모듈 import
import pandas as pd
from bs4 import BeautifulSoup
import requests
import re

# 크롤링
'''
네이버 지도의 경우, 크롤링 자체를 막아뒀음. 출력이 아예 안 됨.
그러나 아래 전체로 보는 페이지(카톡으로 보낸 링크)에서는 리뷰 크롤링이 가능함.

따라서 우회(?)하는 방식을 사용함.

링크 중간에 '1098819515' 이렇게 숫자가 나오는데, 이게 카페/음식점의 고유번호임
이 고유번호만 바꿔주면 크롤링 가능한 페이지로 들어갈 수 있음.

문제는 강남역 주변의 카페의 고유번호를 크롤링해야 하는데, 네이버지도에서는 못함.
그래서 네이버에 '강남역 카페'를 검색해서 나오는 몇 개의 카페는 고유번호를 가져올 수 있음.

이걸 가져와서 하나씩 링크에 넣고 리뷰를 크롤링하는 방법을 사용함.
'''

#크롬 드라이버에 url 주소 넣고 실행
url = 'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=%EA%B0%95%EB%82%A8%EC%97%AD+%EC%B9%B4%ED%8E%98'
# 강남역 카페

# 크롬 브라우저 시작
driver = webdriver.Chrome('/Users/imsoyeong/Downloads/chromedriver_mac64/chromedriver.exe') 
driver.get(url)

# 페이지가 완전히 로딩되도록 1초동안 기다림
time.sleep(1)

webpage = requests.get(url)
soup = BeautifulSoup(webpage.content, "html.parser")

# 총 5페이지 하나씩 넘기기
cafe_num = []
cnt = 1
while True:
    # 정규표현식 패턴을 사용하여 'place/'와 '?' 사이의 값을 추출
    pattern = r'place/([^?]+)'
    
    # 스크롤 로딩을 위함
    while True:
        bh = driver.execute_script('return document.body.scrollHeight')
        ah = driver.execute_script('return document.body.scrollHeight')
        if ah == bh:
            break
        bh = ah
        
    time.sleep(1)
    # 추출
    infos = soup.select('.CHC5F > .tzwk0')
    for info in infos:
        info = str(info.select)
        try:
            match = re.search(pattern, info)
            extracted_value = match.group(1)
            cafe_num.append(int(extracted_value))
            
        except:
            pass
    
    driver.find_element('xpath', '//*[@id="place-main-section-root"]/section/div/div[5]/a[2]').click()
    cnt +=1
    
    if cnt == 5:
        break


# 리스트에서 중복된 값 제거
list(set(cafe_num))
cafe_num.extend([1483295656, 1186606414, 1754767885, 1081873068, 1478381424, 21082407, 1490841787])
cafe_num = list(set(cafe_num))


### 고유번호 하나씩 넣어서 리뷰 크롤링
cafe_name = []
comments = []
for num in cafe_num:
    url = 'https://pcmap.place.naver.com/restaurant/{}/review/visitor?shouldKeywordUnfold=true'.format(num)
    #크롬 드라이버에 url 주소 넣고 실행
    driver.get(url)
    time.sleep(2)
    
    # 카페이름
    name = driver.find_element(By.CSS_SELECTOR, '.Fc1rA').text
    
    # 스크롤 로딩을 위함
    while True:
        bh = driver.execute_script('return document.body.scrollHeight')
        time.sleep(2)
        ah = driver.execute_script('return document.body.scrollHeight')
        if ah == bh:
            break
        bh = ah
    
    while True:
        try:
            # 리뷰 크롤링
            reviews = driver.find_elements(By.CSS_SELECTOR, '.zPfVt')
            for re in reviews:
                cafe_name.append(name)
                comments.append(re.text)
                
            # 더보기 버튼 누르기
            driver.find_element('xpath', '//*[@id="app-root"]/div/div/div/div[7]/div[3]/div[3]/div[2]/a').click()
            time.sleep(1.5)
        except:
            break

# 데이터프레임 저장
df = pd.DataFrame({'cafe_name':cafe_name,
                   'comments':comments})
