require "test/unit"
require "uplift/config"

class TestConfig < Test::Unit::TestCase
  
  def test_config_is_array
    assert_equal "Array", Config::IGNORE_FILES.class.to_s
  end
  
  def test_has_ignore_files
    assert Config::IGNORE_FILES.include? "uplift"
    assert Config::IGNORE_FILES.include? ".git"
    assert Config::IGNORE_FILES.include? ".uplift_config"
    assert Config::IGNORE_FILES.include? ".project"
    assert Config::IGNORE_FILES.include? "nb_project"
    assert Config::IGNORE_FILES.include? ".loadpath"
    assert Config::IGNORE_FILES.include? ".gitignore"
    assert Config::IGNORE_FILES.include? ".gitmodules"
  end

end
