require File.expand_path("../../crane.rb", __FILE__)
require File.expand_path("../../config.rb", __FILE__)
require 'crane/ftp'

module Crane
  module Commands
    class Test < Crane::Engine
      
      include Configuration

      def run
        puts "Starting tests:"
      
        # has configuration file?
        if Configuration.has_config_file?
          puts "\tConfiguration file: ok."
        else
          puts "\tConfiguration file: failed."
          exit
        end
      
        # has connection?
        if has_ftp_connection?
          puts "\tFTP connection: ok."
        else
          puts "\tFTP connection: failed"
          exit
        end
      
        # can change dir?
        if ftp_remote_dir?
          puts "\tFTP remote dir: ok."
        else
          puts "\tFTP remote dir: failed => inexistent remote dir"
        end
      
        puts "Everything's ok." if @errors == false
      end
    
      def has_ftp_connection?
        @ftp = Crane::Ftp.new
        return false if @ftp.connection.nil?
        if @ftp.connection.respond_to?("closed?")
          !@ftp.connection.closed?
        end
      end
    
      def ftp_remote_dir?
        @ftp = Crane::Ftp.new if @ftp.nil?
        @ftp.remote_dir_exists?
      end
  
      def help
        puts "Tests environment."
      end
  
    end
  end
end