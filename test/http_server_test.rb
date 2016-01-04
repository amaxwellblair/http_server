require 'simplecov'
SimpleCov.start
require 'hurley'
require 'socket'
require 'minitest'
require 'pry'

class HttpServerTest < Minitest::Test
  attr_reader :client

  def setup
    @client = Hurley::Client.new "http://127.0.0.1:9292"
  end

  def test_response_success
    response = Hurley.get("http://127.0.0.1:9292")
    assert response.success?
  end

  def test_custom_request
    skip
    k = client.get "" do |req|
      # binding.pry
      req.url
    end
    assert_equal "Hello", k.body.chomp
  end

  def test_hello_world_counter
    k = client.get "" do |req|
      # binding.pry
      req.url
    end
    assert_equal "<html><head></head><body><pre>Hello, World! (0)</pre></body></html>", k.body.chomp
  end

end
