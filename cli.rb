require 'thor'
require 'trello'
require "#{File.expand_path(File.dirname(__FILE__))}/src/configuration"

class CLI < Thor
  desc 'board NAME', 'Show board detail from board name'
  def board(name, attr = 'inspect')
    board = Trello::Board.all.find { |b| b.name.eql?(name) }
    puts board.__send__(attr)
  end
end

CLI.start(ARGV)
