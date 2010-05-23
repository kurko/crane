module Uplift::Commands

  class Test < Uplift::Engine

    def run
      puts "Starting tests:"
      puts ""
      
      # has configuration file?
      if config_has_file? then
        puts "\tConfiguration file: ok."
      else
        puts "\tConfiguration file: failed."
      end
      
      # has connection?
      if has_ftp_connection? then
        puts "\tFTP Connection: ok."
      else
        puts "\tFTP Connection: failed."
      end
      
      # has connection
      
      
    end
    
    def config_has_file?
      File.exists? ".uplift_config"
    end
  
    def has_ftp_connection?
      require "net/ftp"
      host = @config['ftp']['host_address']
      username = @config['ftp']['username']
      password = @config['ftp']['password']
      ftp = Net::FTP.new
      ftp.connect host, 21
      ftp.login username, password
      ftp.chdir('/public_html')
      puts ftp.nlst
      ftp.gettextfile('TMP2ipjw18ox8.htm')
      ftp.close
      
      true
      
    end # has_ftp_connection
  
    def help
      puts "Tests environment."
    end
  
  end
end