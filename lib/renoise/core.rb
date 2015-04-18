require "osc-ruby"
require "renoise/sequencer"

module Renoise
  class Core
    include Renoise::Sequencer

    def initialize(host, port)
      @renoise = OSC::Client.new(host, port)
      self.bpm = 120
      seq_init
    end

    def bpm=(bpm)
      send_msg "/renoise/song/bpm", bpm
      @bpm = bpm
    end

    def note_on(instr, track, note, val)
      send_msg "/renoise/trigger/note_on", instr, track, note, val
    end

    def note_off(instr, track, note)
      send_msg "/renoise/trigger/note_off", instr, track, note
    end

    private

    def send_msg(*args)
      @renoise.send(OSC::Message.new(*args))
    end
  end
end
