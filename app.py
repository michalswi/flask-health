from flask import Flask
from flask import Response
import os

from checkStatus import get_status_code

app = Flask(__name__)

PORT = os.environ.get("SERVER_PORT", "5000")
URL = f"http://localhost:{PORT}"

@app.route('/', methods=['GET'])
def home():
    return "hello world\n"

@app.route('/hz', methods=['GET'])
def gethz():
    """azure health check"""
    return "OK", 200    

@app.route('/healthz', methods=['GET'])
def get():
    """docker/localhost health check"""
    # NO verification
    # return "OK", 200
    # WITH verification
    if get_status_code(URL) == 200:
        return Response("ok", status = 200)

if __name__ == '__main__':
    app.run(host = '0.0.0.0', port = PORT, debug = True)
