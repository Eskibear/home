import requests
from bs4 import BeautifulSoup
class HttpGetter:
    def __init__(self):
        self.session = requests.session()
        self.headers = {
                "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36"
                }
        self.data = {}
        self.cookies = requests.cookies.cookiejar_from_dict({})

    def get(self, url):
        resp = self.session.get(url, headers = self.headers, params = self.data)
        self.cookies.update(resp.cookies)
        self.lastresp =  resp
        self.headers['Referer'] = url
        print(resp.url)
        return BeautifulSoup(resp.content)

    def post(self, url):
        resp = self.session.post(url, headers = self.headers, data = self.data)
        self.cookies.update(resp.cookies)
        self.lastresp =  resp
        print(resp.url)
        return BeautifulSoup(resp.content)

