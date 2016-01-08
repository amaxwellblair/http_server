require 'time'
require 'response_codes'

class Header
  attr_accessor :request, :response, :url, :response_code, :new_url
  include ResponseCodes

  def initialize(request, response, url = "http://127.0.0.1:9292/")
    @request = request
    @response = response
    @url = url
    @new_url = url
  end

  def create
    path_finder
    headers = ["http/1.1 #{response_code}",
              "location: #{new_url}",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{response.output_length}\r\n\r\n"].join("\r\n")
    headers
  end

  def path_finder
    formatted_request = request.path.gsub("/","")
    if respond_to?(formatted_request.to_sym)
      send(formatted_request)
    elsif formatted_request == ""
      root
    else
      @response_code = not_found
    end
  end

  def root
    @response_code = ok
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

  def start_game
    if request.verb == "GET"
      root
    elsif request.verb == "POST"
      if response.the_game.turn_count == 0
        @new_url = (url[0..-2] + request.path)
        @response_code = moved_permanently
        response.the_game.turn_counter
      else
        @new_url = (url[0..-2] + request.path)
        @response_code = forbidden
      end
    end
  end

  def game
    if request.verb == "GET"
      root
    elsif request.verb == "POST"
      @new_url = (url[0..-2] + request.path)
      @response_code = moved_permanently
    end
  end

  def error_back_trace
    @response_code = internal_server_error
  end

  def shutdown_restart
    root
  end

end
