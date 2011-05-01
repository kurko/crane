require File.expand_path("../../uplift.rb", __FILE__)

module Uplift
  module Commands
    class Test < Uplift::Engine

      def run
        puts "Starting tests:"
      
        # has configuration file?
        if config_has_file? then
          puts "\tConfiguration file: ok."
        else
          puts "\tConfiguration file: failed."
        end
      
        # has connection?
        if has_ftp_connection? then
          puts "\tFTP connection: ok."
        else
          puts "\tFTP connection: failed => " + @connection_error
          exit
        end
      
        # can change dir?
        if ftp_remote_dir? then
          puts "\tFTP remote dir: ok."
        else
          puts "\tFTP remote dir: failed => inexistent remote dir"
        end
      
        puts
        if @errors == false then
          puts "Everything's ok."
        end
      
        # can change dir?
      
      
      end
    
      def config_has_file?
        File.exists? ".uplift_config"
      end
  
      def has_ftp_connection?
        require "net/ftp"
        require 'timeout'
        result = true
      
        if @connection.nil? then
          host = @config['ftp']['host_address']
          username = @config['ftp']['username']
          password = @config['ftp']['password']
          @connection = Net::FTP.new
          begin
            Timeout.timeout(4) do
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
      
        if @connection.nil?
          result = false
        end
      
        result
        
      end # has_ftp_connection
    
      # Tries out the remote dir
      def ftp_remote_dir?
        result = true
        require "net/ftp"
        require "timeout"
      
        if @connection.nil? then
          has_ftp_connection?
        end
      
        begin
          Timeout.timeout(10) do
            @connection.chdir @config['ftp']['remote_root_dir']
          end
        rescue Timeout::Error
          result = false
        rescue Exception=>e
          result = false
        end
      
        result
      end
  
      def help
        puts "Tests environment."
      end
  
    end
  end
end