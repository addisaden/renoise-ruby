require "renoise/core"
require "readline"

module Renoise
  class Repl
    def initialize
      puts "Renoise Repl ... Bootup"
      puts "Please be aware to Start Renoise-OSC Server in UDP-Mode"
      @host = Readline.readline("Host: ", true)
      @port = Readline.readline("Port: ", true).to_i

      print "Setup connection ... "
      @renoise = Renoise::Core.new(@host, @port)
      puts "Done"
      print "Setup BPM to 120 ... "
      @renoise.bpm = 120
      puts "Done"
    end
  end
end
