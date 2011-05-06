require "net/ftp"
require File.expand_path("../../shell/shell.rb", __FILE__)

module Uplift
  
  UPLIFT_FOLDER = "uplifting/"
  
  class Engine < Shell::Run
    
    # @argv
    # @command
    # options
    
    def initialize argv = []
      return true if TESTING
      require File.expand_path("../ftp.rb", __FILE__)
      
      super argv
      @config = load_config
      @ignored_files = get_ignored_files
      @local_files = []
      
      @errors = []
      
      # has_compulsory_config?
      
      @connection = nil
      
      # shows help whenever it's called for
      if Shell::Parser.is_option "help", @argv then
        help
        exit
      end
      
      run unless TESTING
    end
    
    # return an instance of a FTP connection
    def connect_ftp
      require "net/ftp"
      require 'timeout'
      result = true
      
      if @connection.nil? then
        host = @config['ftp']['host_address']
        username = @config['ftp']['username']
        password = @config['ftp']['password']
        @connection = Net::FTP.new
        @connection.passive = true
        begin
          Timeout.timeout(7) do
            @connection.connect host, 21
          end
        rescue
          @connection_error = "couldn't connect to host"
          result = false
        end
        
        begin
          Timeout.timeout(4) do
            @connection.login username, password
          end
        rescue
          @connection_error = "invalid username/password"
          result = false
        end
      end
      
      if result == false
        @connection = false
      end
        
      @connection
      
    end # connect_ftp
    
    # if there was typed any argument on ARGV starting with either -- or -
    def is_option option
      Shell::Parser.is_option option, @argv
    end
    
    # loads the config file and returns
    def load_config
      config = {}
      
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
    end #load_config
    
    def get_ignored_files
      require File.expand_path("../config.rb", __FILE__);
      Config::IGNORE_FILES || []
    end
    
    def help
      true
    end
    
  end
  
end