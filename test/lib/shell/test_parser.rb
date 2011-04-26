require "test/unit"
require "shell/shell"

class TestShellParser < Test::Unit::TestCase
  
  def test_get_command
    assert_equal "push", Shell::Parser.get_command(["--test","push","--list", "other_pseudo_command"])
    assert_equal "push", Shell::Parser.get_command(["push","-list", "other_pseudo_command"])
    assert_equal "push", Shell::Parser.get_command(["-list","push", "other_pseudo_command"])
    assert_equal false, Shell::Parser.get_command()
  end
  
  def test_get_options
    assert_equal ["test", "list"], Shell::Parser.get_options( ["push","--test","--list"] )
    assert_equal ["test", "list", "test2"], Shell::Parser.get_options( ["--test", "-list", "push","--test2"] )
    assert_equal ["test"], Shell::Parser.get_options( ["--test", "--test", "push"] )
  end
  
  def test_is_option
    assert Shell::Parser.is_option( "test", ["push","--test","--list"] )
    assert Shell::Parser.is_option( "list", ["push","--test","--list"] )
    assert !Shell::Parser.is_option( "push", ["push","--test","--list"] )
    assert_equal false, Shell::Parser.is_option( "test" )
  end
  
end