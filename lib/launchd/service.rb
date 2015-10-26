module Launchd
  class Service
    attr_reader :label

    def initialize(label, opts = {})
      @label = label
      @opts = opts
    end

    # Deploy (install & restart) the service.
    #
    # If running as root, it will get installed as system-wide daemon,
    # otherwise as agent.
    #
    def deploy
      stop if running?
      write_plist
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

    private

    # Save actual plist to disk.
    def write_plist
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

    # Returns hash of plist properties.
    def properties
      {
        'Label' => label,
        'ProgramArguments' => @opts[:program_arguments],
        'KeepAlive' => @opts[:keep_alive]
      }
    end
  end
end
