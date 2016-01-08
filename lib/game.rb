class Game

  attr_reader :guess, :number, :guess_count, :turn_count

  def initialize(number)
    @number = number
    @guess_count = 0
    @guess = nil
    @turn_count = 0
  end

  def turn_counter
    @turn_count += 1
  end

  def status
    turn_counter
    if guess.nil?
      "You have not made any guesses!"
    elsif guess == number
      ("You've made #{guess_count} guess(es).\n" +
      "You win! OMG!!!!@@ CONGRATULATIONS!!!")
    elsif guess < number
      ("You've made #{guess_count} guess(es).\n" +
      "#{guess} is too low...")
    elsif guess > number
      ("You've made #{guess_count} guess(es).\n" +
      "#{guess} is too damn high!")
    end
  end

  def make_guess(input)
    turn_counter
    @guess = input
    @guess_count += 1 if !input.nil?
  end

end
