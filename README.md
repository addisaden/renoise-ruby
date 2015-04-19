# Renoise

Make Sound with programs you love. Renoise and Ruby.

This is not a final release.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'renoise'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install renoise

## REPL

    $ renoise-repl
    host: localhost
    port: 8000
    >> help

## Usage

    require "renoise"

    r = Renoise::Core.new('localhost', 8000)
    r.stop
    r.seq :drums, 36, 1, 1
    r.config :drums, beats: 1
    r.bpm = 120
    r.notes :drums, 0, -1, 1, -1, 0, 1, -1, 1
    r.play

## Contributing

1. Fork it ( https://github.com/addisaden/renoise-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
