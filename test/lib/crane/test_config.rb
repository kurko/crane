require "test/unit"
require "crane/config"

class TestConfig < Test::Unit::TestCase

  def setup
    Config.PATH = File.expand_path("../../../resources/configurations/crane", __FILE__)
    
    @config = {}
    @config[:ftp] = {
      :host => 'host_address',
      :username => 'username',
      :password => 'password',
      :remote_root_dir => '/public_html'
    }
    
  end
  
  def test_ignore_files_as_array
    assert_equal "Array", Config.IGNORE_FILES.class.to_s
  end
  
  def test_has_ignore_files
    assert Config.IGNORE_FILES.include? "crane"
    assert Config.IGNORE_FILES.include? ".git"
    assert Config.IGNORE_FILES.include? ".DS_Store"
    assert Config.IGNORE_FILES.include? ".crane"
    assert Config.IGNORE_FILES.include? ".crane_config"
    assert Config.IGNORE_FILES.include? ".project"
    assert Config.IGNORE_FILES.include? "nb_project"
    assert Config.IGNORE_FILES.include? ".loadpath"
    assert Config.IGNORE_FILES.include? ".gitignore"
    assert Config.IGNORE_FILES.include? ".gitmodules"
  end
  
  def test_get_ignored_files_plus_gitignore
    files = Config.get_ignored_files
    assert files.include? ".crane"
  end
  
  def test_default_config_path
    Config.PATH = "./"
    assert_equal "./", Config.PATH
  end
  
  def test_has_config_file
    assert Config::has_config_file?
  end
  
  def test_make_config
    syntax = Config.make_config @config
    assert syntax =~ /^\[ftp\]\n/
    assert syntax =~ /^host = host_address\n/
    assert syntax =~ /^username = username\n/
    assert syntax =~ /^password = password\n/
    assert syntax =~ /^remote_root_dir = \/public_html\n/
  end
  
  def test_save_config
    Config.PATH = File.expand_path("../../../resources/configurations/.crane_temp", __FILE__)
    assert Config.save_config @config
    assert_equal Config.CONFIG, @config
    assert File.exists?(Config.PATH), "It seems the file was not saved"
    
    config = File.open(Config.PATH, "r").read
    assert config =~ /^\[ftp\]\n/
    assert config =~ /^host = host_address\n/
    assert config =~ /^username = username\n/
    assert config =~ /^password = password\n/
    assert config =~ /^remote_root_dir = \/public_html\n/

    assert !(config =~ /^\[\[ftp\]\]\n/)
    
    File.delete Config.PATH
  end
  
  def test_load_config
    Config.PATH = File.expand_path("../../../resources/configurations/.crane_temp", __FILE__)
    assert Config.save_config @config
    assert File.exists?(Config.PATH), "It seems the file was not saved"
    
    config = Config.load_config
    assert_equal Config.CONFIG, @config
    assert_equal Config.CONFIG, config
    assert_equal Hash, config.class
    assert_equal :ftp, config.keys[0]
    assert_equal "host_address", config[:ftp][:host]
    assert_equal "username", config[:ftp][:username]
    assert_equal "password", config[:ftp][:password]
    assert_equal "/public_html", config[:ftp][:remote_root_dir]

    File.delete Config.PATH
  end

  def test_load_config
    assert File.exists?(Config.PATH), "It seems the file doesn't exist"
    
    config = Config.load_config
    assert_equal Config.CONFIG, config
    assert_equal Hash, config.class
    assert_equal :ftp, config.keys[0]
    assert_equal "ftp.secureftp-test.com", config[:ftp][:host]
    assert_equal "test", config[:ftp][:username]
    assert_equal "test", config[:ftp][:password]
  end

end
