require 'socket'

host = 'localhost'
port = 2000
path = "index.html"


socket = TCPSocket.new host,port

puts "retrieving ... \nlocalhost/index.html \n\n"

## request
request_line = "GET #{path} HTTP/1.0\r\n"
header = "From: tomaszkula@mail.com\r\nUser-Agent: HTTPTool/1.0"

request = request_line + header + "\r\n\r\n"

puts "requesting ... \n#{request}"

socket.puts(request)

 response = []
  while line = socket.gets and line !~ /^\s*$/
    response << line.chomp
  end

puts "server response ...\n#{response.join("\n")} "

socket.close


