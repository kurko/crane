require "net/ftp"
require 'timeout'

module Uplift

  class Ftp
    
    attr_accessor :ftp, :connection_error
    
    def initialize c = {}
      @ftp = nil
      connect(c) unless c.empty?
    end
    
    def connect c = {}
      port = c[:port] || 21

      @ftp = Net::FTP.new
      @ftp.passive = true
      begin
        Timeout.timeout(10) do
          @ftp.connect c[:host], port
        end
      rescue
        @connection_error = "Couldn't connect to host"
      end
      
      begin
        Timeout.timeout(10) do
          @ftp.login c[:username], c[:password]
        end
      rescue
        @connection_error = "Invalid username/password"
      end

      return false if @connection_error
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
      result = {}
      args.each { |k,v|
        result[k] = v
      }
      result
    end #map_args
    
  end


end