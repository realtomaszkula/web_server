require 'socket'
require 'json'

class Server

  def initialize
    @server = TCPServer.open("localhost",2000)


loop  {
  @client = @server.accept

  ### REQUEST
  request = []
  while line = @client.gets and line !~ /^\s*$/
    request << line.chomp
  end

  rq_status_line  = request[0].split
  @verb = rq_status_line[0]

  case @verb
  when 'GET'
     @fname = rq_status_line[1]

     ### RESPONSE
     ## status line
     code = {
       200 => "200 OK",
       404 => "404 Not Found"
     }

     status_code = File.exists?(@fname)  ? code[200] : code[404]

     if status_code == code[404]
       response = "HTTP/1.1 #{status_code}\n"
       @client.puts response
     else
       status_line = "HTTP/1.1 #{status_code}\n"
       ## headers
       date = "Date: #{Time.now.ctime}"
       content_type = "Content-Type: text/html"
       content_length = "Content-Length: #{File.size(@fname)}"
       headers = date + "\r\n" + content_type + "\r\n" + content_length.to_s + "\r\n\r\n"

       ## body
       body = File.read(@fname)

       ## server response
       response = status_line + headers
       @client.puts response

       response = body
       @client.puts response
       @client.close
     end
  when 'POST'
  end


}
end
end

Server.new