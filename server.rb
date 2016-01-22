require 'socket'

server = TCPServer.open(2000)

loop {
  client = server.accept

  request = client.read.split

  ## status line
  status_code = "200 OK"
  status_line = "HTTP/1.1 #{status_code}"

  ## headers
  date = Time.now.ctime
  content_type = "text/html"
  content_length = 1
  headers = date + content_type + content_length

  # body
  name = "index.html"
  body = File.read(name)

  # full server response
  response = status_line + headers + body

  client.puts response
  client.close
}