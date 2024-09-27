from http.server import HTTPServer, BaseHTTPRequestHandler
import socket


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(
            b"Hello from the container! This is being served on port 80.\n"
        )
        self.wfile.write(f"Your IP address is: {self.client_address[0]}\n".encode())


def run_server():
    host = "0.0.0.0"
    port = 80
    server_address = (host, port)
    httpd = HTTPServer(server_address, SimpleHTTPRequestHandler)
    print(f"Server running on port {port}")
    httpd.serve_forever()


if __name__ == "__main__":
    run_server()
