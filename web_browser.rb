require 'socket'

class WebBrowser
  def initialize(host, path, verb)
    @verb = verb
    @host = host
    @path = path
    @HTTP = "HTTP/1.0"
    @email = "test@test.com"
    @user_agent = "HTTPTool/1.0"
    @port = 2000
    @socket = TCPSocket.new(@host, @port)
    @code = nil
    start
  end

  private

  def start
    request
    get_headers
    get_code
    response
    close
  end

  def request
    puts "\nretrieving ... \n#{@host}/#{@path} #{@HTTP} \n\n"

    request_line = "#{@verb} #{@path} \r\n"
    header = "From: #{@email}\r\nUser-Agent: #{@user_agent}"
    request = request_line + header + "\r\n\r\n"

    puts "requesting ... \n#{request}"
    @socket.puts(request)
  end

  def get_headers
   headers = []
    while line = @socket.gets and line !~ /^\s*$/
      headers << line.chomp
    end
    @response_headers = headers
  end

  def response
    puts "server head response ...\n#{@response_headers.join("\n")} "
    unless @code == 404
      get_length
      body = @socket.read(@length)
      puts "\nserver body response ...\n#{body} "
    end
  end

  def get_length
    @length = @response_headers.select {|line| line =~ /Content-Length:/}.to_s.gsub(/\D/, "").to_i
  end

  def get_code
    @code = @response_headers[0].split(" ")[1].to_i
  end

  def error
    puts "Error 404, Not Found!"
  end

  def close
    @socket.close
  end

end

puts "What do you wan to do?"
puts "ex. of input GET www.google.com/index.html"

input = gets.chomp.split(" ")

verb = input[0]
host, path = input[1].split("/")

WebBrowser.new(host, path, verb)



# GET localhost/indasdex.html





