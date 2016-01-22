require 'socket'

host = 'localhost'
port = 2000
path = "index.html"


socket = TCPSocket.new host,port

## request
request_line = "GET #{path} HTTP/1.0\r\n"
header = "From: tomaszkula@mail.com\r\nUser-Agent: HTTPTool/1.0\r\n\r\n"

request = request_line + header
socket.puts(request)

puts socket.gets

socket.close

puts "finished!"

