require "test/unit"
require "crane/ftp"
require "crane/config"

class TestFtp < Test::Unit::TestCase

  def setup
    Configuration.PATH = "./.inexistent_crane"
    @obj = nil
    @ftp_auth = { 
      :host => "ftp.secureftp-test.com", 
      :username => "test", 
      :password => "test"
    }
    @ftp_auth_wrong_password = { 
      :host => "ftp.secureftp-test.com", 
      :username => "wrong", 
      :password => "wrong"
    }
  end

  def test_new_ftp
    @obj = Crane::Ftp.new
    assert_equal Crane::Ftp, @obj.class
    assert @obj.connection.nil?, @obj.connection.inspect
  end

  def test_connect_on_instantiation
    @obj = Crane::Ftp.new @ftp_auth
    assert @obj.connection.kind_of?(Net::FTP)
  end

  def test_connect
    @obj = Crane::Ftp.new
    connection = @obj.connect(@ftp_auth)
    assert connection
    assert @obj.connection.kind_of?(Net::FTP)
  end

  def test_connect_autoloading_config_info
    Configuration.PATH = File.expand_path("../../../resources/configurations/crane", __FILE__)
    @obj = Crane::Ftp.new
    connection = @obj.connection
    assert connection
    assert @obj.connection.kind_of?(Net::FTP)
    
    assert @obj.connect(Configuration.load_config)
  end

  def test_connect_with_wrong_password
    @obj = Crane::Ftp.new
    assert !@obj.connect(@ftp_auth_wrong_password)
    assert_equal @obj.connection_error, "Invalid username/password"
  end
  
  def test_remote_dir
    Configuration.PATH = File.expand_path("../../../resources/configurations/crane", __FILE__)
    @obj = Crane::Ftp.new
    assert @obj.remote_dir_exists?
  end

  def test_inexistent_remote_dir
    Configuration.PATH = File.expand_path("../../../resources/configurations/crane", __FILE__)
    @obj = Crane::Ftp.new
    assert !@obj.remote_dir_exists?("harhar")
  end
  
end
