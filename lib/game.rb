class Game

  attr_reader :guess, :number, :guess_count

  def initialize(number)
    @number = number
    @guess_count = 0
    @guess = nil
  end

  def status?
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
    @guess = input
    @guess_count += 1
  end

end
