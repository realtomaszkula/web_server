require 'socket'

server = TCPServer.open("localhost",2000)

loop  {
  client = server.accept

  puts request = client.gets


  ## requested file name
  name = "index.html"

  ## status line
  status_code = "200 OK"
  status_line = "HTTP/1.1 #{status_code}\n"

  ## headers
  date = "Date: #{Time.now.ctime}"
  content_type = "Content-Type: text/html"
  content_length = "Content-Length: #{File.size(name)}"
  headers = date + "\n" + content_type + "\n" + content_length.to_s + "\n\n"

  ## body
  body = File.read(name)

  ## full server response
  response = status_line + headers + body

  puts "#{response}"

  client.puts response
  puts "response sent"
  client.close
}
