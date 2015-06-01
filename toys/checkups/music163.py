import HttpGetter
import json
import keyring
from datetime import date
with open("log/music164.log", "at") as f:
    f.write(str(date.today()))
username = keyring.get_password("netease", "username")
data = { 
        'username': username,
        'password': keyring.get_password("netease", username),
        'rememberLogin':"false"
}

hg = HttpGetter.HttpGetter()

url = "http://music.163.com/"
soup = hg.get(url)

hg.data = data
soup = hg.post("http://music.163.com/api/login/?csrf_token=")
recipe = json.loads(soup.text)

checkup_url = "http://music.163.com/api/point/dailyTask"
hg.data = {
        'type':'0',
        'csrf_token': hg.cookies['__csrf']
        }
soup = hg.get(checkup_url)
with open("log/music164.log", "at") as f:
    f.write(soup.text)
hg.data = {
        'type':'1',
        'csrf_token': hg.cookies['__csrf']
        }
soup = hg.get(checkup_url)
with open("log/music164.log", "at") as f:
    f.write(soup.text)
hg.data = {
        'type':'2',
        'csrf_token': hg.cookies['__csrf']
        }
soup = hg.get(checkup_url)
with open("log/music164.log", "at") as f:
    f.write(soup.text+'\n')
