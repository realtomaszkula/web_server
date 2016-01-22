require 'socket'

host = 'localhost'
port = 2000
path = "iasdndex.html"


socket = TCPSocket.new host,port

puts "retrieving ... \nlocalhost/index.html \n\n"

## request
request_line = "GET #{path} HTTP/1.0\r\n"
header = "From: tomaszkula@mail.com\r\nUser-Agent: HTTPTool/1.0"

request = request_line + header + "\r\n\r\n"

puts "requesting ... \n#{request}"

socket.puts(request)

## response headers
 response = []
  while line = socket.gets and line !~ /^\s*$/
    response << line.chomp
  end

  puts "server head response ...\n#{response.join("\n")} "

  if response[0].split(" ")[0].to_i != 404
    ## parsing length out of the header
    content_length = response.select {|line| line =~ /Content-Length:/}.to_s.gsub(/\D/, "").to_i

    ## response body
    body = socket.read(content_length)

    puts "\nserver body response ...\n#{body} "

  end

socket.close


