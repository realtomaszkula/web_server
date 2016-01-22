require 'socket'

host = 'localhost'
port = 2000
path = "index.html"

request = "GET #{path} HTTP/1.0\r\n\r\n"

socket = TCPSocket.open(host,port)
socket.print(request)
puts socket.gets

# headers,body = response.split("\r\n\r\n", 2)
# print body