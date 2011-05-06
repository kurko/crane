require "test/unit"
require "uplift/config"

class TestConfig < Test::Unit::TestCase

  def setup
    Config.PATH = File.expand_path("../../../resources/configurations/.uplift", __FILE__)
    
    @config = {}
    @config['ftp'] = {
      'host_address' => 'host_address',
      'username' => 'username',
      'password' => 'password',
      'remote_root_dir' => '/public_html'
    }
    
  end
  
  def test_ignore_files_as_array
    assert_equal "Array", Config.IGNORE_FILES.class.to_s
  end
  
  def test_has_ignore_files
    assert Config.IGNORE_FILES.include? "uplift"
    assert Config.IGNORE_FILES.include? ".git"
    assert Config.IGNORE_FILES.include? ".uplift_config"
    assert Config.IGNORE_FILES.include? ".project"
    assert Config.IGNORE_FILES.include? "nb_project"
    assert Config.IGNORE_FILES.include? ".loadpath"
    assert Config.IGNORE_FILES.include? ".gitignore"
    assert Config.IGNORE_FILES.include? ".gitmodules"
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
    assert syntax =~ /^host_address = host_address\n/
    assert syntax =~ /^username = username\n/
    assert syntax =~ /^password = password\n/
    assert syntax =~ /^remote_root_dir = \/public_html\n/
  end
  
  def test_save_config
    Config.PATH = File.expand_path("../../../resources/configurations/.uplift_temp", __FILE__)
    assert Config.save_config @config
    assert File.exists?(Config.PATH), "It seems the file was not saved"
    
    config = File.open(Config.PATH, "r").read
    assert config =~ /^\[ftp\]\n/
    assert config =~ /^host_address = host_address\n/
    assert config =~ /^username = username\n/
    assert config =~ /^password = password\n/
    assert config =~ /^remote_root_dir = \/public_html\n/

    assert !(config =~ /^\[\[ftp\]\]\n/)
    
#    File.delete Config.PATH
  end
  
  def test_load_config
    Config.PATH = File.expand_path("../../../resources/configurations/.uplift_temp", __FILE__)
    assert Config.save_config @config
    assert File.exists?(Config.PATH), "It seems the file was not saved"
    
    config = Config.load_config
    assert_equal Hash, config.class
    assert_equal "ftp", config.keys[0]
    assert_equal "host_address", config["ftp"]["host_address"]
    assert_equal "username", config["ftp"]["username"]
    assert_equal "password", config["ftp"]["password"]
    assert_equal "/public_html", config["ftp"]["remote_root_dir"]
  end

end
