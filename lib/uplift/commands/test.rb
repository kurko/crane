require File.expand_path("../../uplift.rb", __FILE__)
require File.expand_path("../../config.rb", __FILE__)
require 'uplift/ftp'

module Uplift
  module Commands
    class Test < Uplift::Engine
      
      include Config

      def run
        puts "Starting tests:"
      
        # has configuration file?
        if Config.has_config_file? then
          puts "\tConfiguration file: ok."
        else
          puts "\tConfiguration file: failed."
          exit
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
      
        if @errors == false then
          puts "Everything's ok."
        end
      
      end
    
      def has_ftp_connection?
        Uplift::Ftp.new
      end
    
      def ftp_remote_dir?
        Uplift::Ftp.new.remote_dir_exists?
      end
  
      def help
        puts "Tests environment."
      end
  
    end
  end
end