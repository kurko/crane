require "shell/shell"
require "uplift"
require "uplift/uplift"

module Shell
  class Initializer

    attr_accessor :command
    
    def initialize argv
      @args = argv
      get_command
      run if @command
    end
    
    def run
      if @command
        if command_exist?
          require get_command_file
          return run_command @command
        end
      end
      false
    end
    
    def should_exit?
      return false || true unless @command
    end
    
    def get_command
      @command = Shell::Parser::get_command @args
    end

    def command_exist? command = false
      File.exists? get_command_file(command)
    end
    
    def get_command_file command = false
      command = @command unless command
      File.expand_path("../commands/" + command + ".rb", __FILE__)
    end
    
    def run_command command, args = []
      command = @command unless command
      require get_command_file(command)
      command.capitalize!
      @command_obj = Uplift::Commands.const_get(command).new(@args)
    end
  end
end