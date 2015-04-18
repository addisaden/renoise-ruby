module Renoise
  module Sequencer
    def seq_init
      @sequencers = {}
      @sequencer = {
        position: 0,
        played: [], # [stop_position, instr, track, note]
        play: true
      }

      @sequencer_thread = Thread.new do
        loop do
          # stop notes
          @sequencer[:played].each_index do |i|
            n = @sequencer[:played][i]
            if n[0] <= @sequencer[:position] then
              note_off(n[1], n[2], n[3])
              @sequencer[:played].delete_at(i)
            end
          end

          # play notes
          notes_to_play = []

          if @sequencer[:play] then
            @sequencers.each do |name, config|
              if @sequencer[:position] % config[:beat] == 0 and config[:notes].length > 0 then
                note = config[:notes][(@sequencer[:position] / config[:beat]) % config[:notes].length]
                if note >= 0 then
                  note += config[:basenote]
                  notes_to_play << [config[:instrument], config[:track], note, config[:value], @sequencer[:position] + config[:length]]
                end
              end
            end

            notes_to_play.each do |n|
              note_on(n[0], n[1], n[2], n[3])
              @sequencer[:played] << [n[4], n[0], n[1], n[2]]
            end
          end

          # wait a tick
          sleep (60.0 / (@bpm * 4))

          @sequencer[:position] += 1
        end
      end
    end

    def seq_stop
      @sequencer[:play] = false
      @sequencer[:played].each do |n|
        note_off(n[1], n[2], n[3])
        @sequencer[:played].delete(n)
      end
    end

    def seq_reset
      seq_stop
      @sequencer[:position] = 0
    end

    def seq_play
      @sequencer[:play] = true
    end

    def seq_drop(name)
      if @sequencers.keys.include? name then
        @sequencers.delete[name]
      end
    end

    def seq_status
      { :sequencers => @sequencers, :play => @sequencer[:play], :position => @sequencer[:position] }
    end

    def seq(name, basenote, instr, track)
      @sequencers[name] = {
        instrument: instr,
        track: track,
        value: 100,
        basenote: basenote,
        beat: 4,
        length: 1,
        notes: []
      }
    end

    def config(name, **config)
      if @sequencers.keys.include? name then
        @sequencers[name].merge!(config)
      end
    end

    def notes(name, *notes)
      if @sequencers.keys.include? name then
        @sequencers[name][:notes] = notes
      end
    end
  end
end
