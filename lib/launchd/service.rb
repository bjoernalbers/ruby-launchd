module Launchd
  class Service
    attr_reader :options, :label

    # NOTE: Only *label* and *program_arguments* are required.
    # See `man launchd.plist` for all possible properties.
    #
    def initialize(opts = {})
      @options = opts
      @label = opts.fetch(:label)
    end

    # restart (install & restart) the service.
    #
    # If running as root, it will get installed as system-wide daemon,
    # otherwise as agent.
    #
    def restart
      stop if running?
      save
      start
    end

    # Stops the service.
    def stop
      system("launchctl unload -w #{label}")
    end

    # Starts the service.
    def start
      system("launchctl load -w #{label}")
    end

    # Returns true, when this service is runnung (loaded), otherwise false.
    def running?
      !!system("launchctl list #{label}")
    end

    alias_method :to_hash, :options

    private

    # Save actual plist to disk.
    def save
      File.open(plist_path, 'w') do |file|
        file.puts properties.to_plist
      end
    end

    # Returns path to plist.
    def plist_path
      plist_dir.join "#{label}.plist"
    end

    # Returns directory where plist is stored.
    def plist_dir
      Pathname.new(
        root? ? '/Library/LaunchDaemons' : '~/Library/LaunchAgents')
    end

    # Returns true, when running as root, otherwise false.
    def root?
      Process.euid.zero?
    end

    # Returns hash of properties with CamelCase-keys.
    def properties
      options.inject({}) do |memo, (k,v)|
        camel_cased_key = k.to_s.split('_').map(&:capitalize).join
        memo[camel_cased_key] = v
        memo
      end
    end
  end
end
