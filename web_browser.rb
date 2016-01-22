require 'socket'

class WebBrowser
  def initialize
    @HTTP = "HTTP/1.0"
    @email = "test@test.com"
    @user_agent = "HTTPTool/1.0"
    @port = 2000
    @code = nil
    start
  end

  private

  def start
    what_to_do

    case @verb
    when "GET"
      get_url
      open_socket
      request
      get_headers
      get_code
      response
      close_socket
    when "POST"
    end
  end

  def what_to_do
    puts "What do you wan to do? ex. GET"
    @verb = gets.chomp.upcase
  end

  def get_url
    puts "Enter URL, ex localhost/index.html"
    @host, @path = gets.chomp.split("/")
  end

  def open_socket
    @socket = TCPSocket.new(@host, @port)
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

  def close_socket
    @socket.close
  end

end

puts "ex. GET www.google.com/index.html"
puts "ex. POST www.google.com/index.html"





WebBrowser.new



# GET localhost/indasdex.html





