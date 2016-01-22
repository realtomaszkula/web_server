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
      send_request
      recieve_headers
      read_status_code
      recieve_body
      close_socket
    when "POST"
      ask_for_input
      open_socket
      send_request
      send_body
      recieve_result
      close_socket
    end
  end

  ## USER MENU
  def what_to_do
    puts "What do you wan to do? GET / POST"
    @verb = gets.chomp
  end

  def ask_for_input
    results = {viking: {}}
    puts "Viking name"
      results[:viking][:name] =  gets.chomp
     puts "Viking email"
      results[:viking][:email] = gets.chomp
    @body = results.to_json
  end

  def send_body
    @socket.puts  @body
  end

  def recieve_result
    results = []
      while line = @socket.gets and line !~ /^\s*$/
        results << line.chomp
      end
    puts results.join("\n")
  end

  def get_url
    puts "Enter URL, ex localhost/index.html"
    @host, @path = gets.chomp.split("/")
  end

  def open_socket
    @socket = TCPSocket.new(@host, @port)
  end

  def send_request
    request_line = "#{@verb} #{@path} \r\n"
    header1 = "From: #{@email}\r\n"
    header2 = "User-Agent: #{@user_agent}\r\n"
    header3 = "Content-Length: #{@body.length}\r\n" if @verb == "POST"

    request = request_line + header1 + header2 + "\r\n"  if @verb == "GET"
    request = request_line + header1 + header2 + header3 + "\r\n"  if @verb == "POST"

    puts "\nrequesting ... \n#{request}"

    @socket.puts request
  end


  def recieve_headers
   headers = []
    while line = @socket.gets and line !~ /^\s*$/
      headers << line.chomp
    end

    @response_headers = headers
  end

  def recieve_body
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

  def read_status_code
    @code = @response_headers[0].split(" ")[1].to_i
  end

  def error
    puts "Error 404, Not Found!"
  end

  def close_socket
    @socket.close
  end

end

WebBrowser.new






