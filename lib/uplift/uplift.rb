require "net/ftp"

module Uplift
  
  class Engine < Shell::Run
    
    # @argv
    # @command
    # options
    
    
    def initialize argv
      super argv
      @command
      @config = load_config
      
      if Shell::Parser.is_option "help", @argv then
        help
        exit
      end
      
      run
    end
    
    def load_config
      config = Hash.new
      
      if File.exists? ".uplift_config" then
        cfile = File.open '.uplift_config', 'r'
        section = ""
        all_properties = Hash.new
        cfile.each {
          |l|
          maybe_section = l.scan(/\[(.*)\]\n/)
          maybe_property = l.scan(/(.*)=(.*)\n/)
          
          unless maybe_section.empty? then
            unless (section.empty? and all_properties.empty? )
              config[section] = all_properties
              all_properties = ""
            end
            section = maybe_section.to_s
          else maybe_property.empty?
            l.scan(/(.*) = (.*)\n/) {
              |property, value|
              all_properties[property.to_s] = value.to_s
            }
          end
          
        }
        
        unless (section.empty? and all_properties.empty? )
          config[section] = all_properties
          all_properties = ""
        end
        
        cfile.close
      end
      
      @config = config
      @config
    end
    
    # saves configurations to file
    def save_config
      data = generates_config_syntax @config
      unless data.empty? then
        
        # deletes configuration file to recreate
        if File.exists? ".uplift_config"
          File.delete ".uplift_config"
        end
        
        cfile = File.open ".uplift_config", "w+"
        data.each_line {
          |l|
          cfile.puts l
        }
        cfile.close
        
      end
#      data
      
    end
    
    def generates_config_syntax config
      data = ""

      config.each {
        |key, value|
        
        # a new section
        if value.class.to_s == "Hash" then
          data << "[" + key.to_s + "]" + "\n"
          data << generates_config_syntax(value).to_s
        elsif value.class.to_s == "String"
          data << key.to_s + " = " +value.to_s + "\n"
        end
      }
      
      data
      
    end # generates_config_syntax
    
    def help
      true
    end
    
  end
  
end