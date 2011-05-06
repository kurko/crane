require "test/unit"
require "uplift/commands/test"
require File.expand_path("../../../../set_test_environment.rb", __FILE__)

class TestTestCommand < Test::Unit::TestCase
  
  def setup
    @obj = Uplift::Commands::Test.new
  end
  
  def test_has_config_file
    Config.PATH = File.expand_path("../../../../resources/configurations/.uplift", __FILE__)
    assert @obj.has_config_file?
  end
  
  def test_has_ignore_files

  end

end
