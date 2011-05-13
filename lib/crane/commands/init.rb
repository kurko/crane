require File.expand_path("../../crane.rb", __FILE__)
require File.expand_path("../../config.rb", __FILE__)
require 'crane/ftp'

module Crane
  module Commands
    class Init < Crane::Engine

      def run
        @config = Config.load_config
        ask_ftp_info
        Config.save_config @config
      end
    
      def ask_ftp_info
        ftp = {}
      
        print "Your FTP host address (e.g. ftp.mysite.com.br): "
        ftp[:host] = Shell::Input.text
      
        print "FTP username: "
        ftp[:username] = Shell::Input.text
      
        system "stty -echo"
        print "FTP password: "
        ftp[:password] = Shell::Input.text
        system "stty echo"
        print "\n"
      
        print "Type the path to the site's folder (e.g. /public_html ): "
        ftp[:remote_root_dir] = Shell::Input.text

        @config[:ftp] = ftp
      
      end
    
      def help
        puts "Initializes environment."
      end
    end
  end
end