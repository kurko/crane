module Uplift::Commands

  class Init < Uplift::Engine

    def run
      ask_ftp_info
      
      save_config
    end
    
    def ask_ftp_info
      ftp = Hash.new
      
      print "Type in your FTP (e.g. ftp.mysite.com.br): "
      ftp['host_address'] = Shell::Input.text
      
      print "Now FTP username: "
      ftp['username'] = Shell::Input.text
      
      system "stty -echo"
      print "FTP password: "
      ftp['password'] = Shell::Input.text
      system "stty echo"
      print "\n"
      
      print "Type the complete path to the site's folder (e.g. /home/user/public_html ): "
      ftp['username'] = Shell::Input.text

      @config = { "ftp" => ftp }
      
    end # ask_ftp_info
    
    def help
      puts "Initializes environment."
    end
  
  end
end