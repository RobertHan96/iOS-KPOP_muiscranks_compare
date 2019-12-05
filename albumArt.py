import firebase_admin
from bs4 import BeautifulSoup as bs
import requests
from firebase_admin import credentials
from firebase_admin import firestore

# 파이어베이스와 파이썬 소스코드 파일간 연결하는 부분
cred = credentials.Certificate("./AccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# 멜론 크롤링
targetSite = "https://www.melon.com/chart/"
header = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko)'}
melonRequest = requests.get(targetSite, headers=header)
melonHtml = melonRequest.text
soup = bs(melonHtml, 'html.parser')

mtest1 = soup.findAll('div', {'class': 'wrap'})
allImages = soup.findAll("img")


imgArray = []
for i in mtest1:
    img = soup.find("img")
    imgSrc = img.get("src")
    imgArray.append(imgSrc)

print(imgArray)
