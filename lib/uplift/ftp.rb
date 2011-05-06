require "net/ftp"
require 'timeout'

module Uplift

  class Ftp
    
    attr_accessor :ftp, :connection_error
    
    def initialize c = false
      @ftp = nil
      unless c
        config = Config.load_config
        unless config.empty?
          c = {}
          c[:ftp] = config[:ftp] unless config[:ftp].empty?
        end
      end
      connect(c) if c
    end
    
    def connect c = {}
      port = c[:port] || 21
      c = c[:ftp] if c.include? :ftp
        
      @connection_error = false
      @ftp = Net::FTP.new
      @ftp.passive = true
      begin
        Timeout.timeout(10) do
          @ftp.connect c[:host], port
        end
      rescue Timeout::Error
        @connection_error = "Timeout on connection"
      rescue
        @connection_error = $!
      end
      
      begin
        Timeout.timeout(20) do
          @ftp.login c[:username], c[:password]
        end
      rescue Timeout::Error
        @connection_error = "Timeout on authentication (20 seconds)"
      rescue Net::FTPPermError
        @connection_error = "Invalid username/password"
      rescue 
        @connection_error = "Unknown error related to username/password"
      end

      return false if @connection_error
      @ftp      
    end

    def remote_dir_exists? remote_dir = false
      return nil if Config.load_config.empty?
      connect(Config.CONFIG[:ftp]) if @ftp.nil?
      
      begin
        Timeout.timeout(10) do
          @ftp.chdir(remote_dir || Config.CONFIG[:ftp][:remote_root_dir])
        end
      rescue 
        return false
      end
    
      true
    end
    
    def putbinaryfile f, f2
      @ftp.putbinaryfile f, f2
    end
    
    def chdir var
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