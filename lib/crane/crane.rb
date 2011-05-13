require "net/ftp"
require "crane/config"
require File.expand_path("../../shell/shell.rb", __FILE__)

module Crane
  
  class Engine < Shell::Run
    
    include Config
    # @argv
    # @command
    # options
    
    def initialize argv = []
      return true if defined? TESTING
      require File.expand_path("../ftp.rb", __FILE__)
      
      super argv
      @ftp = nil
      @config = Config.load_config
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
      
      begin
        run unless defined? TESTING
      rescue Interrupt
        puts "\n"
      rescue
        
      end
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
    
    def get_ignored_files
      require File.expand_path("../config.rb", __FILE__);
      Config.IGNORE_FILES || []
    end
    
    def help
      true
    end
    
  end
  
end