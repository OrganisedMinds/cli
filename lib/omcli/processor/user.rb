module OmCli::Processor
  class User
    DEFAULT_ATTRIBUTES = %w[id email first_name last_name]

    def initialize
    end

    def me(global_options, options, args)
      io         = detect_io(global_options[:output])
      attributes = detect_attributes(options[:attributes])

      res = handle_error("Cannot gen info about current user") do
        @client.me
      end

      io.display(res.pick(*attributes))
    end

    def detect_attributes(attrs)
      attrs = attrs.split(',')
      attrs.any? ? attrs : DEFAULT_ATTRIBUTES
    end
  end
end
