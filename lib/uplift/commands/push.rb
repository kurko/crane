module Uplift::Commands

  class Push < Uplift::Engine

    def run
      
      @local_files = get_files
      
      if @local_files.length == 0 then
        puts "No files were found."
        exit
      elsif @local_files.length == 1 then
        puts "Push 1 file to the server?"
      else
        puts "Push "+@local_files.length.to_s+" files to the server?"
      end
      

    end # run
    
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
          if is_option "list" then
            puts file
          end
          local_files.push file
        end
      end
      
      local_files
      
    end #get_files
    
    def help
      puts "Send files to the server."
    end
  
  end
end