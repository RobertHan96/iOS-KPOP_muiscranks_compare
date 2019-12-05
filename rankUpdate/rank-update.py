# 필요한 패키지 모듈 임포트
import firebase_admin
from bs4 import BeautifulSoup as bs
import requests
from firebase_admin import credentials
from firebase_admin import firestore

# 파이어베이스와 파이썬 소스코드 파일간 연결하는 부분
cred = credentials.Certificate("./AccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()
# iOS 컬렌션뷰 출력을 위한 순차적인 1~100 숫자 딕셔너리 생성
rankIndex = {}
for index in range(0, 100):
    rankIndex.update(
        {'rank{}'.format(index+1): str(index+1)}
    )
    index += 1


def melon():
    # 멜론 랭킹 정보 크롤링
    targetSite = "https://www.melon.com/chart/"
    header = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko)'}
    request = requests.get(targetSite, headers=header)
    rawHtml = request.text
    soup = bs(rawHtml, 'html.parser')

    title = soup.findAll('div', {'class': 'ellipsis rank01'})
    artist = soup.findAll('div', {'class': 'ellipsis rank02'})

    titleMelon = []
    artistMelon = []

    for index1 in title:  # 제목, 가수 정보를 각각 리스트에 저장
        titleMelon.append(index1.find('a').text)

    for index2 in artist:
        artistMelon.append(index2.find(
            'span', {"class", "checkEllipsis"}).text)

    # 리스트에 값을 인덱싱번호와 함께 딕셔너리 형태로 변환
    index = 0
    index2 = 0
    title = {}
    artist = {}
    for index in range(0, 100):
        title.update(
            {'title{}'.format(index+1): titleMelon[index]})
        index = index + 1

    for index2 in range(0, 100):
        artist.update({'artist{}'.format(
            index2+1): artistMelon[index2]})
        index2 = index2 + 1

    # 멜론 랭킹 앨범아트 정보 다운받기

    # 랭킹 정보 파이어베이스 업데이트 구문
    mTitleUpload = db.collection(u'melon').document(u'ranking').set(title)
    mArtistUpload = db.collection(u'melon').document(
        u'ranking').set(artist, merge=True)
    mRankUpload = db.collection(u'melon').document(
        u'ranking').set(rankIndex, merge=True)


def genie():
    # 지니챠트 크롤링
    targetSite = "https://www.genie.co.kr/chart/top200"  # top1~50
    targetSite2 = "https://www.genie.co.kr/chart/top200?ditc=D&ymd=20191018&hh=12&rtm=Y&pg=2"  # top51~100
    header = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko)'}
    request = requests.get(targetSite, headers=header)
    request2 = requests.get(targetSite2, headers=header)
    rawHtml = request.text + request2.text
    soup = bs(rawHtml, 'html.parser')

    title = soup.findAll('a', {'class': 'title ellipsis'})
    artist = soup.findAll('a', {'class': 'artist ellipsis'})

    titleGenie = []
    artistGenie = []
    i2 = 5
    for i in title:
        titleGenie.append(i.text.strip())

    for i2 in artist:
        artistGenie.append(i2.text.strip())
    del artistGenie[0:5]  # 웹상의 TOP5 가수 정보로 인해 중복 노출되는 문제 해결

    # 리스트에 값을 인덱싱번호와 함께 딕셔너리 형태로 변환

    title = {}
    artist = {}

    for dicI in range(100):
        title.update(
            {'title{}'.format(dicI+1): titleGenie[dicI]})

    for dicI in range(100):
        artist.update({'artist{}'.format(
            dicI+1): artistGenie[dicI]})

    # 멜론 랭킹 앨범아트 정보 다운받기

    # 랭킹 정보 파이어베이스 업데이트 구문
    titleUpload = db.collection(u'genie').document(u'ranking').set(title)
    artistUpload = db.collection(u'genie').document(
        u'ranking').set(artist, merge=True)
    rankUpload = db.collection(u'genie').document(
        u'ranking').set(rankIndex, merge=True)


def bugs():
    # 벅스 챠트 크롤링
    targetSite = "https://music.bugs.co.kr/chart"
    header = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko)'}
    request = requests.get(targetSite, headers=header)
    rawHtml = request.text
    soup = bs(rawHtml, 'html.parser')

    bugsTitle = soup.findAll('p', {'class': 'title'})
    bugsArtist = soup.findAll('p', {'class': 'artist'})

    titleBugs = []
    artistBugs = []

    for index5 in bugsTitle:
        titleBugs.append(index5.text.strip())

    for index6 in bugsArtist:
        artistBugs.append(index6.text.strip())
    # 리스트에 값을 인덱싱번호와 함께 딕셔너리 형태로 변환
    title = {}
    artist = {}

    for dicI in range(100):
        title.update(
            {'title{}'.format(dicI+1): titleBugs[dicI]})

    for dicI in range(100):
        artist.update({'artist{}'.format(
            dicI+1): artistBugs[dicI]})

    # 랭킹 정보 파이어베이스 업데이트 구문
    titleUpload = db.collection(u'bugs').document(u'ranking').set(title)
    artistUpload = db.collection(u'bugs').document(
        u'ranking').set(artist, merge=True)
    rankUpload = db.collection(u'bugs').document(
        u'ranking').set(rankIndex, merge=True)


def musicRanksUpdate():
    melon()
    genie()
    bugs()


musicRanksUpdate()
