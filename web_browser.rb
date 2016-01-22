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

  ## parsing length out of the header
  content_length = response.select {|line| line =~ /Content-Length:/}.to_s.gsub(/\D/, "").to_i




#  response = []
#   while(length > 0) line = socket.gets
#     response << line.chomp
#     length  -= 1
#   end

# puts "server response ...\n#{response.join("\n")} "

socket.close


