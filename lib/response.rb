require 'time'
require 'game'

class Response
  attr_accessor :request, :hello_count, :response_count, :circuitbreaker, :the_game, :the_body

  DICT = File.readlines("/usr/share/dict/words")

  def initialize(request = nil)
    @request = request
    @hello_count = -1
    @response_count = -1
    @circuitbreaker = -1
    @the_game = nil
    @response_counter = 0
  end

  def path_finder
    response_counter
    formatted_request = request.path.gsub("/","")
    if respond_to?(formatted_request.to_sym)
      send(formatted_request)
    else
      root
    end
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

  def shutdown_restart
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

  def body
    @the_body = "<html><head></head><body><pre>#{path_finder}</pre></body></html>"
  end

  def output_length
    the_body.length
  end

  def start_game
    if request.verb == 'GET' && the_game.turn_count == 1
      the_game.turn_counter
      "Good luck!"
    elsif request.verb == 'POST' && the_game.nil?
      @the_game = Game.new(34)
    else
      ""
    end
  end

  def game
    if request.verb == "GET"
      if the_game.class == Game
        the_game.status?
      else
        "You haven't started a game yet!"
      end
    elsif request.verb == "POST"
      if the_game.class == Game
        number = request.body[:guess].to_i if !request.body.nil?
        the_game.make_guess(number ||= nil)
      else
        "You haven't started a game yet!"
      end
    end
  end

  def force_error
    raise RuntimeError
  end

  def error_back_trace(input = nil)
    if input.nil?
      @back_trace
    else
      @back_trace ||= input
    end
  end

end
