module OmCli
  class Client
    def initialize
      opts = {
        endpoint:      'http://localhost:3000/',
        client_id:     '<add-yours>',
        client_secret: '<add-yours>',
        scopes:        %w[read write]
      }

      om_dir = "#{ENV['HOME']}/.organisedminds"

      unless  File.directory?(om_dir)
        Dir.mkdir(om_dir)
      end

      cfg = File.join(om_dir, 'config.yaml')

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
      rescue => e
        Formatador.display_line("[red]#{e.message}[/]")
        Formatador.display_line("[red]Error occured while processing `#{name}` method. Is your config valid?[/]")
        exit(1)
      end
    end
  end
end
