require "test/unit"
require "uplift/commands/test"
require File.expand_path("../../../../set_test_environment.rb", __FILE__)

class TestTestCommand < Test::Unit::TestCase
  
  def setup
    Config.PATH = File.expand_path("../../../resources/configurations/.uplift", __FILE__)
    @obj = Uplift::Commands::Test.new
  end
  
  def test_remote_dir
    @obj.ftp_remote_dir?
  end

end
