require 'minitest/autorun'
require 'minitest/pride'
require 'header'

class FakeRequest

  def path
    "/hello"
  end

  def verb
    "POST"
  end

end

class FakeResponse

  def output_length
    "100"
  end

  def the_game
    FakeGame.new
  end

  def turn_count
    0
  end

end

class FakeGame

  def turn_count
    1
  end

  def turn_counter
    0
  end

end

class FakeResponseBadPath

  def path
      "/omgdoubles"
  end

end

class HeaderTest < Minitest::Test

  attr_reader :header

  def setup
    @header = Header.new(FakeRequest.new, FakeResponse.new, "http://127.0.0.1:9292/")
  end

  def test_create_header
    assert_equal "http/1.1 200 OK\r\n" +
                  "location: http://127.0.0.1:9292/\r\n" +
                  "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r\n" +
                  "server: ruby\r\n" +
                  "content-type: text/html; charset=iso-8859-1\r\n" +
                  "content-length: 100\r\n\r\n", header.create
  end

  def test_path_finder_root
    header.path_finder
    assert_equal "200 OK", header.response_code
  end

  def test_start_game
    header.start_game
    assert_equal "403 Forbidden", header.response_code
  end

  def test_game
    header.game
    assert_equal "301 Moved Permanently", header.response_code
  end

  def test_error_back_trace
    header.error_back_trace
    assert_equal "500 Internal Server Error", header.response_code
  end

  def test_path_finder_not_found
    skip
    #edit this header = Header.new(FakeRequest.new, FakeResponse.new, "http://127.0.0.1:9292/")
    header.path_finder
    assert_equal "404 Not Found", header.response_code
  end

end
