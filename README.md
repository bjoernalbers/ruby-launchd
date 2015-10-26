# Ruby-Launchd - Control Mac OS X services with Ruby

Ruby-Launchd is like launchctl (or the famous lunchy). It lets you easily
create, start and stop services on Mac OS X, but with Ruby. 


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

Deploy (install & restart) a service:

```Ruby
service = Launchd::Service.new 'com.example.chunkybacon', # Label of service
  program_arguments: %w(/usr/sbin/chunkyd --bacon), # command line as array
  keep_alive: true # Shall launchd keep it running?
service.deploy
```

**NOTE: All options are also required!**


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
