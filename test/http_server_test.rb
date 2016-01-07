require 'hurley'
require 'socket'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'time'


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

  def test_A_response_success
    response = Hurley.get("http://127.0.0.1:9292/")
    assert response.body
  end

  def test_B_root_path
    response = client.get "" do |req|
      req.url
    end
    assert_equal html_begin + debug_info + html_end, response.body
  end

  def test_C_hello_path
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

  def test_D_date_time_path
    path = "/datetime"
    response = client.get path do |req|
      req.url
    end
    parse_helper(path)
    assert_equal html_begin + "#{time_helper}\n#{debug_info}" + html_end, response.body
  end

  def test_E_word_exists
    param = "?word=word"
    path = "/word_search"
    response = client.get (path + param) do |req|
      req.url
    end
    assert_equal html_begin + "WORD is a known word" +  html_end, response.body
  end

  def test_F_word_does_not_exist
    param = "?word=djns"
    path = "/word_search"
    response = client.get (path + param) do |req|
      req.url
    end
    assert_equal html_begin + "WORD is not a known word" +  html_end, response.body
  end

  def test_G_first_post_starts_game
    param = ""
    path = "/start_game"
    response = client.post (path + param)
    assert_equal html_begin + "Good luck!" + html_end, response.body
  end

  def test_H_first_post_returns_nothing_game
    param = ""
    path = "/start_game"
    response = client.post (path + param)
    assert_equal html_begin + "" + html_end, response.body
  end

  def test_I_get_game_no_guesses
    param = ""
    path = "/game"
    response = client.get (path + param)
    assert_equal html_begin + "You have not made any guesses!" + html_end, response.body
  end

  def test_J_post_game_too_high
    param = "?guess=40"
    path = "/game"
    response = client.post (path + param)
    assert_equal html_begin + ("You've made 1 guess(es).\n40 is too damn high!") + html_end, response.body
  end

  def test_K_post_game_too_low
    param = "?guess=10"
    path = "/game"
    response = client.post (path + param)
    assert_equal html_begin + "You've made 2 guess(es).\n10 is too low..." + html_end, response.body
  end

  def test_L_post_game_just_right
    param = "?guess=34"
    path = "/game"
    response = client.post (path + param)
    assert_equal html_begin + ("You've made 3 guess(es).\nYou win! OMG!!!!@@ CONGRATULATIONS!!!") + html_end, response.body
  end

  def test_M_path_error
    param = ""
    path = "/askljdnf"
    response = client.get (path + param)
    parse_helper(path)
    assert_equal html_begin + debug_info + html_end, response.body
  end

  def test_N_shut_down
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
