import requests
from bs4 import BeautifulSoup
class HttpGetter:
    def __init__(self):
        self.headers = {
                "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36"
                }
        self.data = {}
        self.cookies = ''

    def get(self, url):
        resp = requests.get(url, headers = self.headers, cookies = self.cookies, params = self.data)
        self.cookies = resp.cookies
        self.lastresp =  resp
        self.headers['Referer'] = url
        return resp.content

    def post(self, url):
        resp = requests.post(url, headers = self.headers, cookies = self.cookies, data = self.data)
        self.cookies = resp.cookies
        self.lastresp =  resp
        return resp.content


hg = HttpGetter()
