module OmCli
  class Client
    def initialize
      opts = {
        endpoint:      'http://localhost:3000/',
        client_id:     'add valid',
        client_secret: 'add valid',
        scopes:        %w[read write]
      }

      cfg = File.join(ENV['HOME'], '.omcli.rc.yaml')

      if File.exist?(cfg)
        opts_cfg = YAML.load_file(cfg)
        opts.merge!(opts_cfg)
      else
        File.open(cfg, 'w') { |f| YAML::dump(opts, f) }
        STDERR.puts "Initialized config file in #{cfg}. Please fill in your uid and secret"
        exit(0)
      end

      @client = OM::Api::Client.new(opts)
    end

    def method_missing(name, *args, &block)
      @client.send(name, *args, &block)
    end
  end
end
