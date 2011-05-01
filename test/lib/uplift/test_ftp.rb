require "test/unit"
require "uplift/ftp"

class TestFtp < Test::Unit::TestCase

  def setup
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
    assert @obj.connect(@ftp_auth).kind_of?(Net::FTP)
    assert @obj.ftp.kind_of?(Net::FTP)
  end

  def test_connect_with_wrong_password
    @obj = Uplift::Ftp.new
    assert !@obj.connect(@ftp_auth_wrong_password)
    assert_equal @obj.connection_error, "Invalid username/password"
  end

end
