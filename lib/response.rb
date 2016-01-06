require 'time'

class Response
  attr_accessor :request, :hello_count, :response_count, :circuitbreaker

  DICT = File.readlines("/usr/share/dict/words")

  def initialize(request = nil)
    @request = request
    @hello_count = -1
    @response_count = -1
    @circuitbreaker = -1
  end

  def root
    request.parse
  end

  def hello
    hello_counter
    "Hello, World! (#{hello_count})\n" + root
  end

  def hello_counter
    @hello_count += 1
  end

  def hello_restart
    @hello_count = -1
    root
  end

  def response_restart
    @response_count = -1
    root
  end

  def response_counter
    @response_count += 1
  end

  def datetime
    "#{Time.new.strftime("%I:%M%p on %A, %B %d, %Y")}\n" + root
  end

  def shutdown
    "Total Requests: #{response_count}\n" + root
  end

  def word_search
    return nil if request.param.nil?
    if DICT.any?{|word| word.chomp == request.param[:word]}
      "WORD is a known word"
    else
      "WORD is not a known word"
    end
  end

  def path_list
    response_counter
    # {
    #  "/" => root,
    #  "/hello" => hello,
    #  "/hello_restart" => hello_restart,
    #  "/datetime" => datetime,
    #  "/shutdown" => shutdown,
    #  "/shutdown_restart" => response_restart,
    #  "/word_search" => word_search
    # }

     if "/" == request.path
       root
     elsif "/hello" == request.path
       hello
     elsif "/hello_restart" == request.path
       hello_restart
     elsif "/datetime" == request.path
       datetime
     elsif "/shutdown" == request.path
       shutdown
     elsif "/shutdown_restart" == request.path
       response_restart
     elsif "/word_search" == request.path
       word_search
     else
       root
     end

  end

  def body
    path_list
  end

end
