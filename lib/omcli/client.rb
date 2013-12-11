module OmCli
  class Client
    def initialize
      opts = {
        endpoint:      'http://localhost:3000/',
        client_id:     '<add-yours>',
        client_secret: '<add-yours>',
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
      begin
        @client.send(name, *args, &block)
      rescue
        unless name == :me
          Formatador.display_line("[red]Error occured while processing #{name}. Make sure your config is valid!")
          exit(1)
        end
      end
    end
  end
end
