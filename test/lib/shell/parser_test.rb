require "test/unit"
require THIS_TO_ROOT_PATH + "lib/shell/shell.rb"

class TC_Shell_Parser < Test::Unit::TestCase
  
  def teardown
    @obj = nil
  end
  
  def test_get_command
    assert_equal "push", Shell::Parser.get_command(["--test","push","--list", "other_pseudo_command"])
    assert_equal false, Shell::Parser.get_command()
  end
  
  def test_get_options
    assert_equal ["test","list"], Shell::Parser.get_options( ["push","--test","--list"] )
  end
  
  def test_is_option
    assert Shell::Parser.is_option( "test", ["push","--test","--list"] )
    assert_equal false, Shell::Parser.is_option( "test" )
  end
  
end