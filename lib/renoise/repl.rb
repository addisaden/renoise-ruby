require "renoise/core"
require "readline"

# seq_play, seq_pause, seq_stop
#
# seq_drop(name)
# seq_status
# seq(name, basenote, instr, track)
# config(name, **config)
#   instrument: instr,
#   track: track,
#   value: 100,
#   basenote: basenote,
#   beat: 4,
#   length: 1,
#   notes: []
# notes(name, *notes)

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

      repl
    end

    def repl
      loop do
        @input = Readline.readline(">> ", true)
        
        if @input =~ /exit/i then
          break
        end
      end

      puts "Good Bye :)"
    end
  end
end
