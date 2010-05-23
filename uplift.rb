#!/usr/bin/ruby

require "lib/shell/shell.rb"
require "lib/uplift/uplift.rb"


command = Shell::Parser::get_command ARGV
#puts command

unless command.empty? then
  command_file = "lib/uplift/commands/" + command + ".rb"
  
  # checks if class file exists
  if File.exists? command_file then
    require command_file
    command = command.capitalize
    command_obj = Uplift::Commands.const_get(command).new(ARGV)
    
  end
end