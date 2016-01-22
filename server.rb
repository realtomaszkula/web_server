require 'socket'
require 'json'

class Server

  def initialize
    @server = TCPServer.open("localhost",2000)
    start
  end

def start
  loop  {
    accept_client
    analyze_request

    case @verb
    when 'GET'
      read_file_name
      set_status_code

      case @status_code
      when 404
       @response = "HTTP/1.1 #{@status_code} Not Found\n"
       send_response
      when 200
       status_line = "HTTP/1.1 #{@status_code} OK\n"
       headers = create_headers

       @response = status_line + headers
       send_response

       @response = File.read(@fname)
       send_response
      end

    when 'POST'
      read_length
      read_body
      parse_body

     @response = generate_content
     send_response
    end

    close_client
  }
end

  ## accept connection
  def accept_client
    @client = @server.accept
  end

  ## Initial request, reading verb
  def analyze_request
    @request = []
    while line = @client.gets and line !~ /^\s*$/
       @request << line.chomp
    end

    @status_line  = @request[0].split
    @verb = @status_line[0]
  end

  ## GET request

  def read_file_name
    @fname = @status_line[1]
  end

  def set_status_code
    @status_code = File.exists?(@fname) ? 200 : 404
  end

  def create_headers
    header1 = "Date: #{Time.now.ctime}\r\n"
    header2 = "Content-Type: text/html\r\n"
    header3 = "Content-Length: #{File.size(@fname)}\r\n"
    headers = header1 +  header2 + header3 + "\r\n"
  end

  def send_response
    @client.puts @response
  end

  ## POST request

  def read_length
    @length = @request.select {|line| line =~ /Content-Length:/}.to_s.gsub(/\D/, "").to_i
  end

  def read_body
    @body = @client.read(@length)
  end

  def parse_body
    @params = JSON.parse(@body)
  end

  def generate_content
    html = File.read("thanks.html")
    li = "<li>Viking name: #{@params["viking"]["name"]}</li><li>Email: #{@params["viking"]["name"]}</li>"
    html.sub(/<%\= yield %>/,li).gsub(/\n/,"").strip.gsub(/>\s+</,"><")
  end

  ## close connection

  def close_client
    @client.close
  end

end

Server.new