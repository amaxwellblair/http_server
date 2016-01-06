class Request
  attr_accessor :request

  def initialize(request)
    @request = request
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

  def first_line
    @first_line ||= request[0].split(" ")
  end

  def fourth_line
    @fourth_line ||= request[3].split(": ")
  end

  def sixth_line
    @sixth_line ||= request[5].split(":")
  end

  def verb
    first_line[0]
  end

  def path
    first_line[1].split("?")[0]
  end

  def param
    param_find_all(first_line[1].split("?")[1])
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
