require 'minitest/autorun'
require 'minitest/pride'
require 'request'

class RequestTest < Minitest::Test

  def test_param_find_all
    request = Request.new("doesn't matter")
    parm_hash = request.param_find_all("word=parmesan")
    assert_equal "parmesan", parm_hash[:word]
  end

  def test_parse
    request = Request.new(["GET / HTTP/1.1", "User-Agent: Hurley v0.2", "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "Accept: */*", "Connection: close", "Host: 127.0.0.1:9292"])
    assert_equal "Verb: GET\n" +
                  "Path: /\n" +
                  "Protocol: HTTP/1.1\n" +
                  "Host:  127.0.0.1\n" +
                  "Port: 9292\n" +
                  "Origin:  127.0.0.1\n" +
                  "Accept: */*\n",request.parse
  end

end
