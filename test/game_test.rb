require 'minitest/autorun'
require 'minitest/pride'
require 'game'


class GameTest < Minitest::Test

  def test_make_guess
    game = Game.new(35)
    game.make_guess(32)
    assert_equal 32, game.guess
    assert_equal 1, game.guess_count
  end

  def test_status
    game = Game.new(35)

    game.make_guess(32)
    assert_equal "You've made 1 guess(es).\n" +
    "32 is too low...", game.status

    game.make_guess(38)
    assert_equal "You've made 2 guess(es).\n" +
    "38 is too damn high!", game.status

    game.make_guess(35)
    assert_equal "You've made 3 guess(es).\n" +
    "You win! OMG!!!!@@ CONGRATULATIONS!!!", game.status
  end

  def test_turn_counter
    game = Game.new(35)
    assert_equal 0, game.turn_count
    game.make_guess(37)
    assert_equal 1, game.turn_count
  end

end
