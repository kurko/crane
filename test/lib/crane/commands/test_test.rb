require "test/unit"
require "crane/commands/test"
require File.expand_path("../../../../set_test_environment.rb", __FILE__)

class TestTestCommand < Test::Unit::TestCase
  
  def setup
    Configuration.PATH = File.expand_path("../../../resources/configurations/crane", __FILE__)
    @obj = Crane::Commands::Test.new
  end
  
  def test_remote_dir
    @obj.ftp_remote_dir?
  end
  
  def test_has_connection
    Configuration.PATH = File.expand_path("../../../../resources/configurations/crane", __FILE__)
    assert @obj.has_ftp_connection?
  end
  
  def test_whole_test_process_right_ftp
    Configuration.PATH = File.expand_path("../../../../resources/configurations/crane", __FILE__)
    assert Configuration.has_config_file?
    assert @obj.has_ftp_connection?
    assert @obj.ftp_remote_dir?
  end

  def test_whole_test_process_right_ftp_wrong_remote_dir
    Configuration.PATH = File.expand_path("../../../../resources/configurations/crane_wrong_remote_dir", __FILE__)
    assert Configuration.has_config_file?
    assert @obj.has_ftp_connection?
    assert !@obj.ftp_remote_dir?
  end

  

end
