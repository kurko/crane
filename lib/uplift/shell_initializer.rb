require "shell/shell"
require "uplift"
require "uplift/uplift"

module Shell
  class Initializer

    def initialize argv
      @args = argv
      @command = Shell::Parser::get_command @args
    end
    
    def run

      unless command.empty?
        command_file = File.expand_path("../../lib/uplift/commands/" + command + ".rb", __FILE__)

        # checks if class file exists
        if File.exists? command_file then
          require command_file
          command = command.capitalize
          command_obj = Uplift::Commands.const_get(command).new(@args)
        end
      end
      
    end
    
    def should_exit?
      return true unless @command
      false
    end
    
  end
end