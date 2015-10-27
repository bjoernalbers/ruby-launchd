require 'spec_helper'

module Launchd
  describe Service do
    let(:service) do
      Service.new(label: 'com.example.service',
                  program_arguments: ['service'],
                  keep_alive: true)
    end

    before do
      allow(service).to receive(:system) # Stub any system calls
    end

    describe '#label' do
      it 'returns service label' do
        expect(service.label).to eq 'com.example.service'
      end
    end

    describe '#restart' do
      before do
        allow(service).to receive(:stop)
        allow(service).to receive(:running?)
        allow(service).to receive(:start)
        allow(service).to receive(:save)
      end

      context 'when not running' do
        before do
          allow(service).to receive(:running?).and_return(false)
          service.restart
        end

        it 'writes plist and starts' do
          expect(service).not_to have_received(:stop)
          expect(service).to have_received(:save).ordered
          expect(service).to have_received(:start).ordered
        end
      end

      context 'when running' do
        before do
          allow(service).to receive(:running?).and_return(true)
          service.restart
        end

        it 'stops, overwrites plist and starts ' do
          expect(service).to have_received(:stop).ordered
          expect(service).to have_received(:save).ordered
          expect(service).to have_received(:start).ordered
        end
      end
    end

    describe '#stop' do
      it 'unloads the service' do
        service.stop
        expect(service).to have_received(:system).
          with 'launchctl unload -w com.example.service'
      end
    end

    describe '#start' do
      it 'loads the service' do
        service.start
        expect(service).to have_received(:system).
          with 'launchctl load -w com.example.service'
      end
    end

    describe '#running?' do
      it 'queries the service status' do
        service.running?
        expect(service).to have_received(:system).
          with 'launchctl list com.example.service'
      end

      it 'returns true when service was loaded' do
        allow(service).to receive(:system).and_return(true)
        expect(service.running?).to be true
      end

      it 'returns false when service was not loaded' do
        allow(service).to receive(:system).and_return(nil)
        expect(service.running?).to be false
      end
    end

    describe '#save' do
      let(:tmp) do
        tmp = basedir.join('tmp')
        FileUtils.mkdir tmp unless File.directory? tmp
        tmp
      end

      before do
        allow(service).to receive(:plist_dir).and_return(tmp)
      end

      it 'creates valid property list' do
        expected_plist = <<EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
\t<key>KeepAlive</key>
\t<true/>
\t<key>Label</key>
\t<string>com.example.service</string>
\t<key>ProgramArguments</key>
\t<array>
\t\t<string>service</string>
\t</array>
</dict>
</plist>
EOS
        plist = tmp.join('com.example.service.plist')
        FileUtils.rm(plist) if File.exists?(plist)

        service.send(:save)

        actual_plist = File.read(plist)
        expect(actual_plist).to eq expected_plist
      end
    end

    describe '#plist_path' do
      it 'returns path to plist file' do
        allow(service).to receive(:plist_dir).and_return(Pathname.new '/tmp')
        expect(service.send(:plist_path)).
          to eq Pathname.new('/tmp/com.example.service.plist')
      end
    end

    describe '#plist_dir' do
      context 'when running as root' do
        before do
          allow(service).to receive(:root?).and_return(true)
        end

        it 'returns system-wide daemon directory' do
          expect(service.send(:plist_dir)).
            to eq Pathname.new('/Library/LaunchDaemons')
        end
      end

      context 'when not running as root' do
        before do
          allow(service).to receive(:root?).and_return(false)
        end

        it 'returns agent directory for current user' do
          expect(service.send(:plist_dir)).
            to eq Pathname.new('~/Library/LaunchAgents')
        end
      end
    end

    %i(options to_hash).each do |method|
      describe "##{method}" do
        it 'returns hash of service options' do
          expect(service.send(method)).to eq ({
            label:             'com.example.service',
            program_arguments: ['service'],
            keep_alive:        true
          })
        end
      end
    end

    describe '#properties' do
      it 'returns hash of service properties via CamelCase-Keys' do
        expect(service.send(:properties)).to eq(
          {
            'Label'            => 'com.example.service',
            'ProgramArguments' => ['service'],
            'KeepAlive'        => true
          })
      end
    end

    describe '#root?' do
      it 'returns true when running as root' do
        allow(Process).to receive(:euid).and_return(0)
        expect(service.send(:root?)).to be true
      end

      it 'returns false when not running as root' do
        allow(Process).to receive(:euid).and_return(42)
        expect(service.send(:root?)).to be false
      end
    end
  end
end
