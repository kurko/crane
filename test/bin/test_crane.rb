require "test/unit"
$:.unshift File.expand_path('../../../lib/', __FILE__)
require "crane/shell_initializer"

class TestCrane < Test::Unit::TestCase
  
  def test_push_listing_files
    
    today_file = File.expand_path('../../resources/source_codes/today_file.rb', __FILE__)
    `touch #{today_file}`
    begin
      output = `echo "n" | ruby bin/crane push today -list`
    rescue SystemExit
    end

    assert output =~ /today_file/
    assert output =~ /Push (.*) files to the server\? \[Y\/n\]/

    `touch -mt 200002202020 #{today_file}`
  end

end