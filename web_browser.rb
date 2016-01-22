require 'socket'
require 'json'

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
      get_body
      close_socket
    when "POST"
      set_body
      open_socket
      request
    end
  end

  def what_to_do
    puts "What do you wan to do? GET / POST"
    # @verb = gets.chomp
    @verb = "GET"
  end

  def set_body
    results = {viking: {}}
    puts "Viking name"
      results[:viking][:name] = "Tomasz"
     puts "Viking email"
      results[:viking][:email] = "mail@mail"
    @body = results.to_json
  end

  def get_url
    puts "Enter URL, ex localhost/index.html"
    # @host, @path = gets.chomp.split("/")
    @host = "localhost"
    @path = "index.html"
  end

  def open_socket
    @socket = TCPSocket.new(@host, @port)
  end

  def request
    request_line = "#{@verb} #{@path} \r\n"
    header1 = "From: #{@email}\r\n"
    header2 = "User-Agent: #{@user_agent}\r\n"
    header3 = "Content-Length: #{@body.length}\r\n" if @verb == "POST"

    request = request_line + header1 + header2 + "\r\n"  if @verb == "GET"
    request = request_line + header1 + header2 + header3 + "\r\n"  if @verb == "POST"

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

  def get_body
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





