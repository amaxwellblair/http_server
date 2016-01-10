class Request
  attr_accessor :request

  def initialize(request)
    @request = request  
    @path = 0
  end

  def param_find_all(str)
    parm_hash = {}
     all_the_params = str.split("&")
     all_the_params.each do |param|
       break_down = param.split("=")
       parm_hash[break_down[0].to_sym] = break_down[1]
     end
     parm_hash
  end

  def parse
    "Verb: #{verb}\n" +
    "Path: #{path}\n" +
    "Protocol: #{protocol}\n" +
    "Host: #{host}\n" +
    "Port: #{port}\n" +
    "Origin: #{origin}\n" +
    "Accept: #{accept}\n"
  end

  # ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Accept-Encoding: gzip, deflate", "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9", "Accept-Language: en-us", "Cache-Control: max-age=0", "Connection: keep-alive"]

  # def host
  #   request[/Host: \S+/]
  # end
  #
  # def accept
  #   request[/Accept: \S+/]
  # end
  #
  # def protocol
  #   request[/HTTP\S+/]
  # end
  #
  # def verb
  #   request[/\S+/]
  # end
  #
  # def path
  #   request[/\/\S+/]
  # end

  def first_line
    request[0].split(" ")
  end

  def fourth_line
    request[3].split(": ")
  end

  def sixth_line
    request[5].split(":")
  end

  def verb
    first_line[0]
  end

  def path(input = nil)
    first_line[1].split("?")[0]
  end

  def param
    return nil if first_line[1].split("?")[1].nil?
    param_find_all(first_line[1].split("?")[1])
  end

  def body
    return nil if request.last.split("?")[1].nil?
    param_find_all(request.last.split("?")[1])
  end

  def protocol
    first_line[2]
  end

  def accept
    fourth_line[1]
  end

  def host
    sixth_line[1]
  end

  def origin
    sixth_line[1]
  end

  def port
    sixth_line[2]
  end

end
