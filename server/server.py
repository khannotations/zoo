# Copyright Jon Berg , turtlemeat.com

from subprocess import check_output as qx
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer


class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            if self.path == "/zoo":
                output = qx(['ruby hzw.rb', ''])
                print output
                self.send_response(200)
                self.send_header('Content-type',  'text/html')
                self.end_headers()
                self.wfile.write(output)
                return
            return
        except IOError:
            self.send_error(404, 'File Not Found: %s' % self.path)

    def do_POST(self):
        self.send_error(404, 'Route Not Found: %s' % self.path)


def main():
    try:
        server = HTTPServer(('', 80), MyHandler)
        print 'started httpserver...'
        server.serve_forever()
    except KeyboardInterrupt:
        print '^C received, shutting down server'
        server.socket.close()

if __name__ == '__main__':
    main()
