require "shell/shell"
require "crane"
require "crane/crane"

module Shell
  class Initializer

    attr_accessor :command
    
    def initialize argv
      @args = argv
      get_command
      run
    end
    
    def run
      if @command
        if command_exist?
          require get_command_file
          return run_command @command
        end
      end
      inexistent_command
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
      return inexistent_command unless command_exist?(command)
      require get_command_file(command) 
      command = command.capitalize
      @command_obj = Crane::Commands.const_get(command).new(@args)
    end
    
    def inexistent_command
      @command_obj = Crane::Engine.new(@args)
    end
  end
end