require File.expand_path("../../uplift.rb", __FILE__)
require File.expand_path("../../config.rb", __FILE__)
require 'uplift/ftp'

module Uplift
  module Commands

    class Push < Uplift::Engine
      
      @ignored_files = []
      
      def run
      
        @local_files = get_files
      
        if @local_files.length == 0 then
          puts "No files were found."
          exit
        elsif @local_files.length == 1 then
          do_push_files = Shell::Input.yesno "Push 1 file to the server? [Y/n]"
        else
          do_push_files = Shell::Input.yesno "Push "+@local_files.length.to_s+" files to the server? [Y/n]"
        end
        puts @local_files
        unless do_push_files
          exit
        end
      
        print "Connecting to host... "
      
        ftp = connect_ftp
        if ftp == false then
          puts "ops, an error ocurred."
          exit
        else
          puts "connected. Started sending files..."
        end
      
#        push_files ftp
      
      end # run
    
      def push_files ftp
      
        ftp = Uplift::Ftp.new :host => @config['ftp']['host_address'],
                             :username => @config['ftp']['username'],
                             :password => @config['ftp']['password']
      
        prefix_dir = @config['ftp']['remote_root_dir']
        unless prefix_dir[ prefix_dir.length-1,1 ] == "/" then
          prefix_dir << "/"
        end
      
        @local_files.each { |f|
          st_mk = Time.new
        
          dir = prefix_dir+File.dirname(f)
          ftp.mkdir dir
        
          st_end = Time.new
          t = st_end-st_mk
          print ">> mkdir: "+ '%.2f' % t.inspect
        
          pwd = ftp.pwd
          ftp.chdir dir
          st_put = Time.new
        
          begin
            result = ftp.putbinaryfile f, File.basename(f)
          rescue
          
          end
          st_putend = Time.new
          t = st_putend-st_put
          print " >> putfile: "+ '%.2f' % t.inspect
          print "\n"
        
          STDOUT.flush
          ftp.chdir pwd
        }
        puts ""

      end
    
      # if user defines a time interval for the file, check if it complies
      def within_defined_interval? file, time_frame = ""
        time = Time.new
        file_time = Time.at File.stat(file).mtime
        yesterday = time - (60 * 60 * 24)
      
        if time_frame == "today"
          return true if file_time.year+file_time.month+file_time.day == time.year+time.month+time.day
        elsif time_frame == "yesterday"
          return true if file_time.year+file_time.month+file_time.day == yesterday.year+yesterday.month+yesterday.day
        elsif time_frame =~ /^[1-9]h$/
          seconds = time_frame[/[1-9]/].to_i * (60 * 60)
          return true if file_time > (time - seconds)
        end
        false
      end
    
      def get_files time_frame = "", search_folder = ""
      
        @ignored_files = get_ignored_files
        local_files = []
      
        if search_folder == ""
          search_folder = "*"
        else
          search_folder << "*"
        end
      
        Dir.glob(search_folder, File::FNM_DOTMATCH).each { |file|
          filename = File.basename file
        
          next if [".", ".."].include? filename
          next if @ignored_files.include? file
        
          if File.stat(file).directory? then
            local_files += get_files(time_frame, file+"/").flatten
          elsif within_defined_interval? file, time_frame
            puts file if is_option "list"
            local_files.push file
          end
        }
        local_files
      end
    
      def help
        puts "Send files to the server."
      end
  
    end
  end
end