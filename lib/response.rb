class Response
  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def path_list
    {"/" => self.root}
  if request.path == "/"
    response = request.parse
  elsif request.path == "/hello"
    response = "Hello, World! (#{hello_count += 1})\n" + request.parse
  elsif request.path == "/hello_restart"
    hello_count = -1
    response = request.parse
  elsif request.path == "/datetime"
    response = "#{Time.new.strftime("%I:%M%p on %A, %B %d, %Y")}\n" + request.parse
  elsif request.path == "/shutdown"
    response = "Total Requests: #{response_count}\n" + request.parse
    circuitbreaker = 1
  elsif request.path == "/shutdown_restart"
    response_count = -1
  elsif request.path == "/word_search"
    if DICT.any?{|word| word.chomp == request.param[:word]}
      response = "WORD is a known word"
    else
      response = "WORD is not a known word"
    end
  else
    response = request.parse
  end

  response_count += 1

end
