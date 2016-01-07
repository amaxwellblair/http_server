require 'time'

class Header
  attr_accessor :request, :response, :url, :response_code

  def initialize(request, response, url = "http://127.0.0.1:9292/")
    @request = request
    @response = response
    @url = url
  end

  def create
    path_finder
    headers = ["http/1.1 #{response_code}",
              "location: #{url}",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{response.length}\r\n\r\n"].join("\r\n")
    headers
  end

  def path_finder
    formatted_request = request.path.gsub("/","")
    if respond_to?(formatted_request.to_sym)
      send(formatted_request)
    else
      root
    end
  end

  def root
    @response_code = ok
    @url = url
  end

  def hello
    root
  end

  def datetime
    root
  end

  def shutdown
    root
  end

  def wordsearch
    root
  end

  def hello_restart
    root
  end

  def shutdown_restart
    root
  end

  def start_game
    root
  end

  def game
    if request.verb == "GET"
      root
    elsif request.verb == "POST"
      @url = (url[0..-2] + request.path)
      @response_code = moved_permanently
    end
  end

  def ok
    "200 OK"
  end

  def moved_permanently
    "301 Moved Permanently"
  end

  def unauthorized
    "401 Unauthorized"
  end

  def forbidden
    "403 Forbidden"
  end

  def not_found
    "404 Not Found"
  end

  def internal_server_error
    "500 Internal Server Error"
  end

end
