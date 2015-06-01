import HttpGetter
import json
username = keyring.get_password("netease", "username")
data = { 
        'username': username
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
print(soup.text)
hg.data = {
        'type':'1',
        'csrf_token': hg.cookies['__csrf']
        }
soup = hg.get(checkup_url)
print(soup.text)
hg.data = {
        'type':'2',
        'csrf_token': hg.cookies['__csrf']
        }
soup = hg.get(checkup_url)
print(soup.text)
