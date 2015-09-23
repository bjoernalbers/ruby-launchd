# Ruby-Launchd - Control Mac OS X services with Ruby

Ruby-Launchd is like launchctl (or the famous lunchy). It lets you easily
create, start and stop services on Mac OS X, but with Ruby. 

**NOTE: This is currently just the README without any code!**


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'launchd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install launchd

## Usage

A new service requires a label (in reverse-domain-notation) and the actual
command to run as array:

```Ruby
service = Launchd.new 'com.example.chunkybacon', %w(/usr/sbin/chunkyd --bacon)
```

Then start and stop it with...

```Ruby
service.start # Starts the service if not already running.
service.stop  # Stops the service unless already stopped.
```

Both return `true` on success or `false` otherwise, i.e. if a job was already running.

Use the bang-version to forcefully overwrite an already running service:

```Ruby
service.start! # Stops, updates and starts service, no matter if it's running or not.
```


## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on
[GitHub](https://github.com/bjoernalbers/ruby-launchd).
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the
[Contributor Covenant](contributor-covenant.org)
code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
