import http.server
import os
import logging
import simplejson
import json
from urllib.parse import urlparse, parse_qs
import requests

url = 'http://localhost:7270/repositories/CPS-NBA'


try:
    import http.server as server
except ImportError:
    import SimpleHTTPServer as server

class HTTPRequestHandler(server.SimpleHTTPRequestHandler):


    def do_GET(self):
        server.SimpleHTTPRequestHandler.do_GET(self)
        logging.warning(self.headers)

    def do_POST(self):
        length = int(self.headers['Content-Length'])
        data = self.rfile.read(length)
        result = parse_qs(data, strict_parsing=True)
        
        for key in result:
            if len(result[key]) == 1:
                result[key] = result[key][0]

        headers = {'Accept':"application/x-sparqlstar-results+json, application/sparql-results+json;q=0.9, */*;q=0.8"}

        resp = requests.post(url=url, data=result,headers=headers)
        print(str(resp))
        query_result = resp.json()
        print(str(json.dumps(query_result)))
        self.send_response(200)
        self.send_header('Content-type','application/json')
        self.end_headers()
        self.wfile.write(bytes(str(json.dumps(query_result)), "utf8"))


if __name__ == '__main__':
    server.test(HandlerClass=HTTPRequestHandler)
