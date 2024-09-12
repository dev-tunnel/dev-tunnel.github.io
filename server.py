#!/usr/bin/env python3
PORT = 8000
import http.server

class Handler(http.server.CGIHTTPRequestHandler):
    cgi_directories =  ['/.well-known']

httpd = http.server.HTTPServer( ("", PORT), Handler)

try:
    print ("Server Started at port:", PORT)
    httpd.serve_forever()
except KeyboardInterrupt:
    print('\nShutting down server')
    httpd.socket.close()
