require 'simplecov'
SimpleCov.start
require 'hurley'
require 'socket'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'time'

`ruby ./lib/ruby_built_server.rb &>/dev/null &`

class HttpServerTest < Minitest::Test
  attr_reader :client, :debug_info, :html_begin, :html_end

  def self.test_order
    :alpha
  end

  def setup
    @client = Hurley::Client.new "http://127.0.0.1:9292"
    @debug_info = (   "Verb: GET\n" +
                      "Path: /\n" +
                      "Protocol: HTTP/1.1\n" +
                      "Host:  127.0.0.1\n" +
                      "Port: 9292\n" +
                      "Origin:  127.0.0.1\n" +
                      "Accept: */*\n" )
    @html_begin = "<html><head></head><body><pre>"
    @html_end = "</pre></body></html>"
  end

  def parse_helper(path)
    @debug_info = (    "Verb: GET\n" +
                      "Path: #{path}\n" +
                      "Protocol: HTTP/1.1\n" +
                      "Host:  127.0.0.1\n" +
                      "Port: 9292\n" +
                      "Origin:  127.0.0.1\n" +
                      "Accept: */*\n" )
  end

  def time_helper
    time_is_now = Time.new.strftime("%I:%M%p on %A, %B %d, %Y")
  end

  def hello_helper
    path = "/hello_restart"
    response = client.get path do |req|
      req.url
    end
  end

  def response_helper
    path = "/shutdown_restart"
    response = client.get path do |req|
      req.url
    end
  end

  # def restart_helper
  #   `ruby ./lib/ruby_built_server.rb`
  # end


  def test_response_success
    response = Hurley.get("http://127.0.0.1:9292")
    assert response.success?
  end

  def test_root_path
    response = client.get "" do |req|
      req.url
    end
    assert_equal html_begin + debug_info + html_end, response.body
  end

  def test_hello_path
    hello_helper
    path = "/hello"
    3.times do |i|
      response = client.get path do |req|
        req.url
      end
      parse_helper(path)
      assert_equal html_begin + "Hello, World! (#{i})\n#{debug_info}" + html_end, response.body
    end
  end

  def test_date_time
    path = "/datetime"
    response = client.get path do |req|
      req.url
    end
    parse_helper(path)
    assert_equal html_begin + "#{time_helper}\n#{debug_info}" + html_end, response.body
  end

  def test_shut_down
    response_helper
    path = "/hello"
    3.times do |i|
      response = client.get path do |req|
        req.url
      end
    end
    path = "/shutdown"
    response = client.get path do |req|
      req.url
    end
    parse_helper(path)
    assert_equal html_begin + "Total Requests: #{3}\n#{debug_info}" + html_end, response.body
  end

end
