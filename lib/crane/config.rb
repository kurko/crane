module Config

  @CONFIG = {}
  
  @PATH = "./.crane"

  @IGNORE_FILES = [
    "crane",
    ".git",
    ".crane_config",
    ".project",
    "nb_project",
    ".loadpath",
    ".gitignore",
    ".gitmodules"
  ]
  
  class << self
    attr_accessor :PATH, :FILENAME, :IGNORE_FILES, :CONFIG
  end
  
  def self.get_ignored_files
    if File.exists? ".gitignore"
      IO.readlines(".gitignore").each { |e|
        @IGNORE_FILES.push e.gsub(/\n/, "")
      }
    end
    @IGNORE_FILES
  end
  
  def self.has_config_file?
    File.exists? @PATH
  end
  
  def self.make_config config
    data = ""
    
    config.each { |key, value|
      # a new section
      if value.class.to_s == "Hash" then
        data << "[" + key.to_s + "]" + "\n"
        data << self.make_config(value).to_s
      elsif ["String", "Symbol"].include? value.class.to_s
        data << key.to_s + " = " +value.to_s + "\n"
      end
    }
    
    data
  end
  
  def self.save_config config
    @CONFIG = config
    data = self.make_config config
    unless data.empty?
      # deletes configuration file to recreate
      File.delete self.PATH if File.exists? self.PATH
      
      File.open(self.PATH, "w+") { |cfile|
        File.chmod(0777, self.PATH)
        data.each_line { |l|
          cfile.puts l
        }
      }
      return true
    end
    false
  end
  
  def self.load_config
    config = {}
    
    if File.exists? Config.PATH
      cfile = File.open Config.PATH, 'r'
      
      section = ""
      
      all_properties = {}
      cfile.each { |l|
        maybe_section = l.scan(/\[(.*)\]\n/)
        maybe_property = l.scan(/(.*)=(.*)\n/)
        
        maybe_section = maybe_section[0][0] if maybe_section[0]
        
        unless maybe_section.empty? then
          unless (section.empty? and all_properties.empty? )
            config[section.to_sym] = all_properties
            all_properties = ""
          end
          section = maybe_section
        else maybe_property.empty?
          l.scan(/(.*) = (.*)\n/) {
            |property, value|
            all_properties[property.to_sym] = value.to_s
          }
        end
        
      }
      
      unless (section.empty? and all_properties.empty? )
        config[section.to_sym] = all_properties
        all_properties = ""
      end
      
      cfile.close
    end
    @CONFIG = config
    config
  end
  
end