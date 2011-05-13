require "net/ftp"
require 'timeout'

module Crane

  class Ftp
    
    attr_accessor :connection, :connection_error
    
    def initialize c = false
      @connection = nil
      @existent_dirs = []
      @nlst = {}
      unless c
        config = Config.load_config
        unless config.empty?
          c = {}
          c[:ftp] = config[:ftp] unless config[:ftp].empty?
        end
      end
      connect(c) if c
      self
    end
    
    def connect c = {}
      port = c[:port] || 21
      c = c[:ftp] if c.include? :ftp
      
      return false unless c.has_key? :host

      @connection = Net::FTP.new
      @connection_error = false
      @connection.passive = true
      begin
        Timeout.timeout(10) do
          @connection.connect c[:host], port
        end
      rescue Timeout::Error
        @connection_error = "Timeout on connection"
      rescue
        @connection_error = "Error on connection FTP"
      end
      
      begin
        Timeout.timeout(20) do
          @connection.login c[:username], c[:password]
        end
      rescue Timeout::Error
        @connection_error = "Timeout on authentication (20 seconds)"
      rescue Net::FTPPermError
        @connection_error = "Invalid username/password"
      rescue 
        @connection_error = "Unknown error related to username/password"
      end

      return false if @connection_error
      true  
    end

    def remote_dir_exists? remote_dir = false
      return nil if Config.load_config.empty?
      connect(Config.CONFIG[:ftp]) if @connection.nil?
      
      begin
        Timeout.timeout(10) do
          @connection.chdir(remote_dir || Config.CONFIG[:ftp][:remote_root_dir])
        end
      rescue 
        return false
      end
      @connection.close
      true
    end
    
    def close
      @connection.close
    end
    
    def putbinaryfile f, f2
      @connection.putbinaryfile f, f2
    end
    
    def chdir var
      @connection.chdir var
    end
    
    # Accepts deep directories as parameter
    def mkdir dir
      each_dir = dir.split("/")
      return false if dir.empty?
      last_dir = ""
      
      each_dir.each { |d|
        next if ["", ".", ".."].include? d
      
        slashed_d = "/" + d if d[0,1] != "/"
        current_dir = last_dir + slashed_d

        if @existent_dirs.include? current_dir
          last_dir << slashed_d
          next
        else
          @connection.chdir last_dir unless last_dir.empty?
          
          if @nlst.include? last_dir
            nlst = @nlst[last_dir]
          else
            nlst = @connection.nlst
          end
          @nlst[last_dir] = nlst
          if nlst.include? d
            @existent_dirs << current_dir
            last_dir << slashed_d
            next
          else
            @connection.mkdir d
            @connection.chdir current_dir
            last_dir << slashed_d
            @existent_dirs << current_dir
          end
        end
      }
      @connection.chdir pwd
    end
    
    def pwd
      @connection.pwd
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