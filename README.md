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

Initialize a service object:

```Ruby
service = Launchd::Service.new,
  label:             'com.example.chunkybacon',     # Required
  program_arguments: %w(/usr/sbin/chunkyd --bacon), # Required
  keep_alive:        true                           # Optional
```

Only *label* and *program_arguments* are required. See
[`man launchd.plist(5)`](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/launchd.plist.5.html)
for all possible properties.

Then stop, overwrite and start the service with the given properties (i.e. for
deployment):

```Ruby
service.restart
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
