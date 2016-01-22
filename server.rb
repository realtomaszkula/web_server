require 'socket'

server = TCPServer.open(2000)

loop {
  client = server.accept


  puts  "#{request = client.read.split}"

  ## status line
  status_code = "200 OK"
  status_line = "HTTP/1.1 #{status_code}\n"

  ## headers
  date = "Date: #{Time.now.ctime}"
  content_type = "Content-Type: text/html"
  content_length = "Content-Length: 123"
  headers = date + "\n" + content_type + "\n" + content_length.to_s + "\n\n"

  # body
  name = "index.html"
  body = File.read(name)

  # full server response
  puts "#{response = status_line + headers + body}"

  client.puts response
  client.close
}