require "net/ftp"
require 'timeout'

module Uplift

  class Ftp
    
    def initialize *c
      
      c = map_args *c
      
      result = true
      
      if @ftp.nil? then
        host = c[:host]
        username = c[:username]
        password = c[:password]
        @ftp = Net::FTP.new
        @ftp.passive = true
        begin
          Timeout.timeout(7) do
            @ftp.connect host, 21
          end
        rescue
          @connection_error = "couldn't connect to host"
          result = false
        end
        
        begin
          Timeout.timeout(4) do
            @ftp.login username, password
          end
        rescue
          @connection_error = "invalid username/password"
          result = false
        end
      end
      
      if result == false
        @ftp = false
      end
        
      @ftp
      
    end
    
    def method_missing name_symbol, *params
    #  @ftp.name_symbol(params)
    end
    
    def putbinaryfile f, f2
      @ftp.putbinaryfile f, f2
    end
    
    def chdir var
      #puts var
      @ftp.chdir var
    end
    
    # creates a directory. Accepts deep dir as parameter
    def mkdir dir
      each_dir = dir.split("/")
      
      if dir.empty? then
        return false
      end
      
      
      pwd = @ftp.pwd
      #puts pwd
      last_dir = ""
      each_dir.each {
        |d|
        next if d == "" or d == "." or d == ".."
        
        is_dir = @ftp.nlst.include? d
        
        if d[0,1] != "/" then
          d = "/" + d
        end
        
        #puts "\t\t"+is_dir.inspect+ " -- " + d
        
        if is_dir then
          @ftp.chdir last_dir+d
          last_dir << d
        else
          @ftp.mkdir last_dir+d
          last_dir << d
        end
        
      }
      @ftp.chdir pwd
      
    end
    
    def pwd
      @ftp.pwd
    end
    
    private
    def map_args args
      
      result = Hash.new
      args.each {
        |k,v|
        result[k] = v
      }
      
      result
    end #map_args
    
  end


end