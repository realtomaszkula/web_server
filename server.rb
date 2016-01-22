require 'socket'
require 'json'

class Server

  def initialize
    @server = TCPServer.open("localhost",2000)
    start
  end

def start
  loop  {
    @client = @server.accept
    analyze_request

  case @verb
  when 'GET'
    @fname = @rq_status_line[1]
    get_staus_code
    if @status_code == 404
     @response = "HTTP/1.1 #{@status_code} OK\n"
     send_response
    else
     status_line = "HTTP/1.1 #{@status_code} Not Found\n"
     headers = get_headers

     @response = status_line + headers
     send_response

     @response = File.read(@fname)
     send_response
    end
    close
  when 'POST'
    get_length
    get_body
    p @body
    close
  end

  }
end

  def get_headers
    header1 = "Date: #{Time.now.ctime}\r\n"
    header2 = "Content-Type: text/html\r\n"
    header3 = "Content-Length: #{File.size(@fname)}\r\n"
    headers = header1 +  header2 + header3 + "\r\n"
  end

  def send_response
    @client.puts @response
  end

  def get_staus_code
    @status_code = File.exists?(@fname) ? 200 : 404
  end

  def analyze_request
    @request = []
    while line = @client.gets and line !~ /^\s*$/
       @request << line.chomp
    end

    @rq_status_line  = @request[0].split
    @verb = @rq_status_line[0]
  end


  def get_length
    @length = @request.select {|line| line =~ /Content-Length:/}.to_s.gsub(/\D/, "").to_i
  end

  def get_body
    @body = @client.read(@length)
  end

  def close
    @client.close
  end

end

Server.new