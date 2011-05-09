require "test/unit"
require "uplift/commands/test"
require File.expand_path("../../../../set_test_environment.rb", __FILE__)

class TestTestCommand < Test::Unit::TestCase
  
  def setup
    Config.PATH = File.expand_path("../../../resources/configurations/uplift", __FILE__)
    @obj = Uplift::Commands::Test.new
  end
  
  def test_remote_dir
    @obj.ftp_remote_dir?
  end
  
  def test_has_connection
    Config.PATH = File.expand_path("../../../../resources/configurations/uplift", __FILE__)
    assert @obj.has_ftp_connection?
  end
  
  def test_whole_test_process_right_ftp
    Config.PATH = File.expand_path("../../../../resources/configurations/uplift", __FILE__)
    assert Config.has_config_file?
    assert @obj.has_ftp_connection?
    assert @obj.ftp_remote_dir?
  end

  def test_whole_test_process_right_ftp_wrong_remote_dir
    Config.PATH = File.expand_path("../../../../resources/configurations/uplift_wrong_remote_dir", __FILE__)
    assert Config.has_config_file?
    assert @obj.has_ftp_connection?
    assert !@obj.ftp_remote_dir?
  end

  

end
