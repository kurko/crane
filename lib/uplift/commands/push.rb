module Uplift::Commands

  class Push < Uplift::Engine

    def run
      
      @local_files = get_files
      
      if @local_files.length == 0 then
        puts "No files were found."
        exit
      elsif @local_files.length == 1 then
        do_push_files = Shell::Input.yesno "Push 1 file to the server? [yes or no]"
      else
        do_push_files = Shell::Input.yesno "Push "+@local_files.length.to_s+" files to the server? [yes or no]"
      end
      
      unless do_push_files
        exit
      end
      
      puts "Send"
      
      

    end # run
    
    # if user defines a time interval for the file, check if it complies
    def within_defined_interval? file
      result = false
      time = Time.new
      
      #puts Time.local(2000, 2, -1)
      
      #today's files
      if
        @arguments.include? "today" then
        
        file_time = Time.at File.stat(file).ctime
        if( file_time.year == time.year and
            file_time.month == time.month and
            file_time.day == time.day )
        then
          result = true
        end
        
      elsif
        @arguments.include? "yesterday" then
        
        yesterday = time - (60 * 60 * 24)
        file_time = Time.at File.stat(file).ctime
        if( file_time.year == yesterday.year and
            file_time.month == yesterday.month and
            file_time.day == yesterday.day )
        then
          result = true
        end
      
      else
        result = true
      end

      result
    end
    
    
    # defines what files are to be sent
    def get_files search_folder = ""
      
      local_files = Array.new
      
      if search_folder == "" then
        search_folder = "*"
      else
        search_folder << "*"
      end
      
      Dir.glob(search_folder, File::FNM_DOTMATCH).each do |file|
        filename = File.basename file
        
        # puts @ignored_files.include? file
        next if (filename == "." or filename == "..")
        next if @ignored_files.include?(file) == true
        
        if File.stat(file).directory? then
          local_files += get_files(file+"/").flatten
        else
          
          if within_defined_interval? file then
          
            if is_option "list" then
              puts file
            end
          
            local_files.push file
          end
        end
      end
      local_files
    end #get_files
    
    def help
      puts "Send files to the server."
    end
  
  end
  
end