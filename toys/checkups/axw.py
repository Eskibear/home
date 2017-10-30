import HttpGetter
import json
import re
import keyring
from PIL import Image
from pytesseract import *
from datetime import date
with open("log/axw.log", "at") as f:
    f.write(str(date.today()))
username = keyring.get_password("jaccount", "username")
password = keyring.get_password("jaccount", username)

data = { 
}

hg = HttpGetter.HttpGetter()

url = "http://aixinwu.sjtu.edu.cn/index.php/login"
soup = hg.get(url)

jaccount_url = soup.meta.attrs['content'][7:]
soup = hg.get(jaccount_url)

logged = False
times = 0
while not logged and times <= 5:
    times += 1
    captcha_url = "https://jaccount.sjtu.edu.cn/jaccount/captcha"
    hg.down(captcha_url, '/tmp/a.jpg')
# parse jpg
    im = Image.open('/tmp/a.jpg')
    captcha = image_to_string(im)
    print(captcha)
    data = {
        'sid':soup.find("input", attrs={'name':'sid'}).attrs['value'],
        'returl':soup.find("input", attrs={'name':'returl'}).attrs['value'],
        'se':soup.find("input", attrs={'name':'se'}).attrs['value'],
        'v':soup.find("input", attrs={'name':'v'}).attrs['value'],
        'captcha':captcha,
        'user':username,
        'pass':password,
        'imageField.x':55,
        'imageField.y':3
    }

    hg.data = data
    login_url = "https://jaccount.sjtu.edu.cn/jaccount/ulogin"
    soup = hg.post(login_url)

    ptn = re.compile(r'https?.*')

    logged = True
    if len(ptn.findall(soup.meta.attrs['content'])) == 0:
        logged = False
        hg.data = {}
    else:
        next_url = ptn.findall(soup.meta.attrs['content'])[0]
        soup = hg.get(next_url)

money = "times out"
if logged:
    money = soup.find("ul",class_="header_userInfo_box").li.text.encode('ascii', 'ignore').decode('ascii')

with open("log/axw.log", "at") as f:
    f.write("total: "+money+'\n')
