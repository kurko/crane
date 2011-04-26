require "test/unit"
require "uplift/shell_initializer"

class TestShellInitializer < Test::Unit::TestCase
  
  def test_should_exit?
    @obj = Shell::Initializer.new([])
    assert @obj.should_exit?
  end

  def test_get_command
    @obj = Shell::Initializer.new(["my_command"])
    assert !@obj.should_exit?
    assert_equal "my_command", @obj.get_command
  end
  
  def test_command_exist
    @obj = Shell::Initializer.new(["init"])
    assert @obj.command_exist?
  end

  def test_command_does_no_exist
    @obj = Shell::Initializer.new(["zomg"])
    assert !@obj.command_exist?
  end
  
  def test_load_command
    @obj = Shell::Initializer.new(["init"])
    assert_equal @obj.load_command.class, "Init"
  end
end
