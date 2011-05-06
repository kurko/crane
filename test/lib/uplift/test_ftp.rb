require "test/unit"
require "uplift/ftp"
require "uplift/config"

class TestFtp < Test::Unit::TestCase

  def setup
    Config.PATH = "./.uplift"
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
    @obj = Uplift::Ftp.new
    assert_equal Uplift::Ftp, @obj.class
    assert @obj.ftp.nil?
  end

  def test_connect_on_instantiation
    @obj = Uplift::Ftp.new @ftp_auth
    assert @obj.ftp.kind_of?(Net::FTP)
  end

  def test_connect
    @obj = Uplift::Ftp.new
    connection = @obj.connect(@ftp_auth)
    assert connection
    assert @obj.ftp.kind_of?(Net::FTP)
  end

  def test_connect_autoloading_config_info
    Config.PATH = File.expand_path("../../../resources/configurations/.uplift", __FILE__)
    @obj = Uplift::Ftp.new
    connection = @obj.ftp
    assert connection
    assert @obj.ftp.kind_of?(Net::FTP)
    
    assert @obj.connect(Config.load_config)
  end

  def test_connect_with_wrong_password
    @obj = Uplift::Ftp.new
    assert !@obj.connect(@ftp_auth_wrong_password)
    assert_equal @obj.connection_error, "Invalid username/password"
  end
  
  def test_remote_dir
    Config.PATH = File.expand_path("../../../resources/configurations/.uplift", __FILE__)
    @obj = Uplift::Ftp.new
    assert @obj.remote_dir_exists?
  end

  def test_inexistent_remote_dir
    Config.PATH = File.expand_path("../../../resources/configurations/.uplift", __FILE__)
    @obj = Uplift::Ftp.new
    assert !@obj.remote_dir_exists?("harhar")
  end

end
