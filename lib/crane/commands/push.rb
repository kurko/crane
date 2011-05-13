require File.expand_path("../../crane.rb", __FILE__)
require File.expand_path("../../config.rb", __FILE__)
require 'crane/ftp'

module Crane
  module Commands

    class Push < Crane::Engine
      
      @ignored_files = []
      
      def run
        time_frame = Shell::Parser.get_arguments(@argv).first
        @local_files = get_files time_frame

        if @local_files.length == 0
          puts "No files were found."
          exit
        elsif @local_files.length == 1
          do_push_files = Shell::Input.yesno "Push 1 file to the server? [Y/n]"
        else
          do_push_files = Shell::Input.yesno "Push "+@local_files.length.to_s+" files to the server? [Y/n]"
        end

        exit unless do_push_files
  
        print "\nConnecting to host... "
  
        ftp = Crane::Ftp.new
        if ftp == false then
          puts "ops, an error ocurred."
          exit
        else
          puts "connected. Started sending files..."
        end

        push_files ftp
      end
    
      def push_files ftp
        
        prefix_dir = @config[:ftp][:remote_root_dir]
        prefix_dir << "/" unless prefix_dir[ prefix_dir.length-1,1 ] == "/"
        
        @local_files.each { |f|
          st_mk = Time.new
        
          dir = prefix_dir
          unless [".", ".."].include? File.dirname(f)
            dir = prefix_dir + File.dirname(f)
            ftp.mkdir dir
          end
          
          st_end = Time.new
          t = st_end-st_mk
          print ">> mkdir: "+ '%.2f' % t.inspect
        
          pwd = ftp.connection.pwd
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
          ftp.connection.chdir pwd
        }
        puts "Done!"
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
        elsif time_frame == "all"
          return true
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