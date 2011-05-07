require File.expand_path("../../uplift.rb", __FILE__)
require File.expand_path("../../config.rb", __FILE__)
require 'uplift/ftp'

module Uplift
  module Commands
    class Init < Uplift::Engine

      def run
        @config = Config.load_config
        ask_ftp_info
        Config.save_config @config
      end
    
      def ask_ftp_info
        ftp = {}
      
        print "Your FTP host address (e.g. ftp.mysite.com.br): "
        ftp[:host_address] = Shell::Input.text
      
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