# Hackrf
This is a major work-in-progress. Still usable in its current form, but feel free to contribute!


## Installation

Before you can start using this gem, you'll need to install `libhackrf`:
```
$ sudo apt install libhackrf-dev
```

Add this line to your application's Gemfile:

```ruby
gem 'hackrf'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hackrf

## Usage

Basic usage is simple:

```ruby
require 'hackrf'

HackRF::Device::Radio.open do |hackrf|
  info = HackRF::Device::Info.new(hackrf)
  puts info.board_id
  hackrf.frequency = 433.0 * (10 ** 6)
  hackrf.sample_rate = 44.8 * (10 ** 3)

  hackrf.rx do |transfer|
      puts transfer.buffer.dump
  end
end
```

This library makes use of FFI bindings to the libhackrf API, so the [official documentation](https://github.com/dodgymike/hackrf-wiki/blob/master/libHackRF-API.md) should prove useful.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby-hackrf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/ruby-hackrf/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby::Hackrf project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ruby-hackrf/blob/master/CODE_OF_CONDUCT.md).
