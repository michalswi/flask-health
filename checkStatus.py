import requests

def get_status_code(url):
    r = requests.get(url)
    return r.status_code