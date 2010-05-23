module Uplift 
  
  class Engine < Shell::Run
    
    # @argv
    # @command
    # options
    
    def initialize argv
      super argv
      @command
      
      if Shell::Parser.is_option "help", @argv then
        help
        exit
      end
      
      run
      
    end
    
    def help
      true
    end
    
  end
  
end