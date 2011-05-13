require "test/unit"
require "crane/commands/push"
require File.expand_path("../../../../set_test_environment.rb", __FILE__)

class TestPushCommand < Test::Unit::TestCase
  
  def setup
    unless File.exists?(File.expand_path("../../../../.crane", __FILE__))
      Config.PATH = File.expand_path("../../../resources/configurations/crane", __FILE__)
    end
    
    @lab_file = "test/resources/source_codes/today_file.rb"
    @lab_file_absolute = File.expand_path("../../../../resources/source_codes/today_file.rb", __FILE__)
    
    @obj = Crane::Commands::Push.new
  end
  
  def test_get_todays_files
    system "touch -mt " + Time.new.strftime("%Y%m%d%H%M") + " " + @lab_file_absolute
    assert @obj.within_defined_interval?(@lab_file, "today")
    assert !@obj.within_defined_interval?(@lab_file, "yesterday")
    assert @obj.within_defined_interval?(@lab_file, "1h")
    assert @obj.within_defined_interval?(@lab_file, "2h")
    assert @obj.within_defined_interval?(@lab_file, "3h")
  end
  
  def test_get_yesterdays_files
    system "touch -mt " + (Time.new - (60 * 60 * 24)).strftime("%Y%m%d%H%M") + " " + @lab_file_absolute

    assert @obj.within_defined_interval?(@lab_file, "yesterday")
    assert !@obj.within_defined_interval?(@lab_file, "today")
  end
  
  def test_list_has_today_file
    system "touch -mt " + Time.new.strftime("%Y%m%d%H%M") + " " + @lab_file_absolute
    list_of_files = @obj.get_files "today"
    assert list_of_files.to_s =~ /resources\/source_codes\/today_file\.rb/
  end

  def test_list_has_yesterdays_file
    system "touch -mt " + (Time.new - (60 * 60 * 24)).strftime("%Y%m%d%H%M") + " " + @lab_file_absolute
    list_of_files = @obj.get_files "yesterday"
    assert list_of_files.to_s =~ /resources\/source_codes\/today_file\.rb/
  end

end
