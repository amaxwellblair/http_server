require 'time'
require 'game'

class Response
  attr_accessor :request, :hello_count, :response_count, :circuitbreaker, :the_game

  DICT = File.readlines("/usr/share/dict/words")

  def initialize(request = nil)
    @request = request
    @hello_count = -1
    @response_count = -1
    @circuitbreaker = -1
    @the_game = nil
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
    path_finder
  end

  def start_game
    if request.verb == 'POST'
      @the_game = Game.new(34)
      "Good luck!"
    elsif request.verb == 'GET'
      root
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
        the_game.make_guess(request.param[:guess].to_i)
      else
        "You haven't started a game yet!"
      end
    end
  end

end
