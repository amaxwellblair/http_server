require 'minitest/autorun'
require 'minitest/pride'
require 'response'

class FakeRequest

  def path
    "/"
  end

  def parse
    "Verb: GET\n" +
    "Path: /\n" +
    "Protocol: HTTP/1.1\n" +
    "Host:  127.0.0.1\n" +
    "Port: 9292\n" +
    "Origin:  127.0.0.1\n" +
    "Accept: */*\n"
  end

  def param
    {word:"hello"}
  end

  def verb
    "POST"
  end

end

class ResponseTest < Minitest::Test

  attr_reader :response, :root

  def setup
    @response = Response.new(FakeRequest.new)
    @root = "Verb: GET\n" +
                  "Path: /\n" +
                  "Protocol: HTTP/1.1\n" +
                  "Host:  127.0.0.1\n" +
                  "Port: 9292\n" +
                  "Origin:  127.0.0.1\n" +
                  "Accept: */*\n"
  end

  def test_path_finder
    assert_equal root, response.path_finder
  end

  def test_hello
    assert_equal "Hello, World! (0)\n" + root, response.hello
  end

  def test_datetime
    assert_equal "#{Time.new.strftime("%I:%M%p on %A, %B %d, %Y")}\n" + root, response.datetime
  end

  def test_shutdown
    assert_equal "Total Requests: -1\n" + root, response.shutdown
  end

  def test_word_search
    assert_equal "WORD is a known word", response.word_search
  end

  def test_start_game
    response.start_game
    assert response.the_game.class == Game
  end

  def test_game
    assert_equal "You haven't started a game yet!", response.game
  end

  def test_force_error
    assert_raises(RuntimeError) {response.force_error}
  end

  def test_error_back_trace
    assert_equal @back_trace, response.error_back_trace
  end

end
