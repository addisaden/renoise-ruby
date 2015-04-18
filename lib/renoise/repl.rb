require "renoise/core"
require "readline"

# seq_play, seq_pause, seq_stop, panic
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
    RESERVED = ["rm", "config", "notes", "ls", "play", "pause", "stop", "panic", "bpm"]
    LS = /^\s*ls/i
    SEQUENCE = /^\s*([[:word:]]+)\s+(\d+)\s+(\d+)\s+(\d+)/i
    CONFIGURATION = /^\s*config\s+([[:word:]]+)\s+((\s*(\w+)\s+(\d+)){1,})/i
    NOTES = /^\s*notes\s+([[:word:]]+)((\s+-?\d+){1,})/i
    BPM = /^\s*bpm\s+(\d+)/i
    RM = /^\s*rm\s+([[:word:]]+)/i

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

      @renoise.seq_stop
      @renoise.panic
      puts "Good Bye :)"
    end

    def repl
      loop do
        begin
          input = Readline.readline(">> ", true)

          input = input.split(';').map { |s| s.strip }

          input.each do |iii|
            @input = iii
          
            if @input =~ /exit/i then
              return
            elsif @input =~ /^play/i then
              @renoise.seq_play
            elsif @input =~ /^pause/i then
              @renoise.seq_pause
            elsif @input =~ /^stop/i then
              @renoise.seq_stop
            elsif @input =~ /^panic/i then
              panic
            elsif @input =~ RM then
              rm
            elsif @input =~ BPM then
              bpm
            elsif @input =~ LS then
              list
            elsif @input =~ NOTES then
              notes
            elsif @input =~ CONFIGURATION then
              configuration
            elsif @input =~ SEQUENCE then
              sequence
            else
              puts "no command."
            end
          end
        rescue => e
          puts "err"
        end
      end
    end

    def panic
      @renoise.panic
    end

    def bpm
      i = @input.match(BPM)
      bpm = i[1].to_i
      @renoise.bpm = bpm
    end

    def rm
      i = @input.match(RM)
      name = i[1]
      unless @renoise.seq_status[:sequencers].include? name then
        puts "Sorry, sequence doesn't exist."
        return
      end
      @renoise.seq_drop name
      list
    end

    def notes
      # notes(name, *notes)
      i = @input.match(NOTES)
      name = i[1]
      unless @renoise.seq_status[:sequencers].include? name then
        puts "Sorry, sequence doesn't exist."
        return
      end
      notes = (i[2]).strip.split(/\s+/).map { |i| i.to_i }
      @renoise.notes name, *notes
      list
    end

    def sequence
      # seq(name, basenote, instr, track)
      i = @input.match(SEQUENCE)
      name = i[1]
      if RESERVED.include? name then
        puts "Sorry name is reserved."
        return
      end
      basenote = i[2].to_i
      instr = i[3].to_i
      track = i[4].to_i
      @renoise.seq name, basenote, instr, track
      list
    end

    def configuration
      i = @input.match(CONFIGURATION)
      name = i[1]
      unless @renoise.seq_status[:sequencers].include? name then
        puts "Sorry, sequence doesn't exist."
        return
      end
      config = i[2].split(/\s+/i).map { |c| c =~ /^\d+$/ ? c.to_i : c }
      (config.length / 2).times do |i|
        @renoise.config name, { config[i*2].to_sym => config[(i*2) + 1] }
      end
      list
    end

    def list
      status = @renoise.seq_status
      puts "\n#{ status[:play] ? 'PLAYING' : 'STOPPED' } Takt: #{ status[:position] / 4 + 1 } Note: #{ status[:position] % 4 + 1}"

      temp_show_seq = Class.new do
        def initialize(k, v)
          @name = k
          @instr = v[:instrument]
          @track = v[:track]
          @value = v[:value]
          @basenote = v[:basenote]
          @beat = v[:beat]
          @length = v[:length]
          @notes = v[:notes].map { |n| note_to_s(n) }
        end

        def note_to_s(note)
          if note < 0 then
            return "-"
          end
          b = %w{c c# d d# e f f# g g# a a# h}[note % 12]
          b += note / 12 < 1 ? '' : (note / 12).to_s
          return b
        end

        def to_s
          "\n-- #{ @name } --\ninstrument=#{ @instr } track=#{ @track }\nbeat=#{ @beat } basenote=#{ @basenote } value=#{ @value} length=#{ @length }\n#{ @notes.join(' ') }"
        end
      end

      status[:sequencers].each do |k, v|
        puts temp_show_seq.new(k, v)
      end
      puts
    end
  end
end
