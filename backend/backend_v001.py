import logging
import json
from urllib.parse import urlparse, parse_qs
import requests
import argparse
import http.server as server
import socketserver as SocketServer


class HTTPRequestHandler(server.SimpleHTTPRequestHandler):

    # Handles GET requests by returning the files
    def do_GET(self):
        server.SimpleHTTPRequestHandler.do_GET(self)
        logging.warning(self.headers)

    # Handles POST requests forwarding them to the GraphDB instance and returning the GraphDB response (PROXY)
    def do_POST(self):
        length = int(self.headers['Content-Length'])
        data = self.rfile.read(length)
        result = parse_qs(data, strict_parsing=True)
        
        for key in result:
            if len(result[key]) == 1:
                result[key] = result[key][0]

        headers = {'Accept':"application/x-sparqlstar-results+json, application/sparql-results+json;q=0.9, */*;q=0.8"}

        resp = requests.post(url=url, data=result,headers=headers)
        query_result = resp.json()
        self.send_response(200)
        self.send_header('Content-type','application/json')
        self.end_headers()
        self.wfile.write(bytes(str(json.dumps(query_result)), "utf8"))

# --------------------------------------------------------------------------
# Parse the CLI arguments and retrieve the port number
# --------------------------------------------------------------------------
parser=argparse.ArgumentParser(description="How to run the python backend server:",formatter_class=argparse.ArgumentDefaultsHelpFormatter,prog = "NBA-CPS server",epilog = "Restart and provide the correct parameters.")
parser.add_argument('--listen_port', help='The server Port', default=8080)
parser.add_argument('--graphdb_port', help='The GraphDB Port', default=7200)
args=parser.parse_args()
config=vars(args)
port=int(config['listen_port'])

# The url of the GraphDB repository
url='http://db:'+str(config['graphdb_port'])+'/repositories/CPS-NBA'

# --------------------------------------------------------------------------
# Start the HTTP server and loop forever
# --------------------------------------------------------------------------
Handler = HTTPRequestHandler
httpd = SocketServer.TCPServer(("", port), Handler)
httpd.serve_forever()
