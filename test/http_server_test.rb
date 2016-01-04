require 'simplecov'
SimpleCov.start
require 'hurley'
require 'socket'
require 'minitest'
require 'pry'

class HttpServerTest < Minitest::Test
  attr_reader :client, :iterator

  def setup
    @client = Hurley::Client.new "http://127.0.0.1:9292"
    @iterator = 0
  end

  def test_response_success
    response = Hurley.get("http://127.0.0.1:9292")
    assert response.success?
  end

  def test_hello_world_counter
    skip
    response = client.get "" do |req|
      req.url
    end
    assert_equal "<html><head></head><body><pre>Hello, World! (#{@iterator += 1})</pre></body></html>", response.body
  end

  def test_parse_request
    response = client.get "" do |req|
      req.url
    end
    parsed_request = ("<html><head></head><body><pre>\n" +
                      "Verb: GET\n" +
                      "Path: /\n" +
                      "Protocol: HTTP/1.1\n" +
                      "Host:  127.0.0.1\n" +
                      "Port: 9292\n" +
                      "Origin:  127.0.0.1\n" +
                      "Accept: */*\n" +
                      "</pre></body></html>")
    assert_equal parsed_request, response.body
  end


  # def test_custom_request
  #   skip
  #   k = client.get "" do |req|
  #     # binding.pry
  #     req.url
  #   end
  #   assert_equal "Hello", k.body.chomp
  # end

end
