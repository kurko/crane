module Shell
  
  class Run
    
    # all arguments passed
    @argv
    
    def initialize argv
      @argv = argv
      
      @options = Shell::Parser.get_options @argv
      @command = Shell::Parser.get_command @argv
      @arguments = Shell::Parser.get_arguments @argv
    end
    
  end
  
  class Input
    
    def self.text
      STDOUT.flush
      STDIN.gets.strip
    end
    
    def self.yesno message
      STDOUT.flush
      has_result = false
      while has_result == false
        print message.strip + " "
        input = STDIN.gets.strip
        
        if input == "yes" or input == "y" then
          final_input = "yes"
        elsif input == "no" or input == "n" then
          final_input = "no"
        end
        
        if ( final_input == "yes" or final_input == "no" )
          has_result = true
        end
      end
      
      if final_input == "yes"
        result = true
      else
        result = false
      end
      result
    end
    
  end
  
  class Parser
    
    # defines the command of the application (e.g. 'push' in uplift push)
    def self.get_command argv = []
      command = String.new
      
      argv.each {
        |e|
        e_length = e.length
        if (e[0,2] != "--" and e[0,1] != "-") then
            command = e
            break
        end
      }
      
      if command.empty? then
        command = ""
      end
      
      command
      
    end # get_command
    
    # get only options in ARGV (arguments starting with _ or __)
    def self.get_options argv
      @options = Array.new
      
      argv.each {
        |e|
        e_length = e.length
        if e[0,2] == "--" 
          @options.push e[2,e_length]
        elsif e[0,1] == "-"
            @options.push e[1,e_length]
        end
      }
      @options
    end # get_options
    
    # get arguments. arguments are anything written besides the command and options.
    # in 'push today --list', 'today' is the argument
    def self.get_arguments argv
      @arguments = Array.new
      i = 0
      argv.each {
        |e|
        
        i+= 1
        next if i == 1
        
        e_length = e.length
        if e[0,2] != "--" and e[0,1] != "-"
          
          @arguments.push e[0,e_length]
        end
        
      }
      @arguments
    end # get_options
    
    def self.is_option option, argv = Array.new
      argv_options = self.get_options argv
      argv_options.include?(option)
    end # is_option
    
  end
  
end