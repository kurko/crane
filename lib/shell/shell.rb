module Shell
  
  class Run
    
    # all arguments passed
    @argv
    
    def initialize argv
      @argv = argv
      
      @options = Shell::Parser.get_options @argv
      @command = Shell::Parser.get_command @argv
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
    
    def self.is_option option, argv = Array.new
      argv_options = self.get_options argv
      argv_options.include?(option)
    end # is_option
    
  end
  
end