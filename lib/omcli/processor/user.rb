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

    def list(global_options, options, args)
      io         = detect_io(global_options[:output])
      attributes = detect_attributes(options[:attributes])
      pagination = gimme_pagination(options)

      res = handle_error("Cannot get your connections") do
        @client.users(pagination)
      end

      io.display(res.map do |u|
        u.pick(*attributes)
      end)
    end

    def detect_attributes(attrs)
      attrs = attrs.split(',')
      attrs.any? ? attrs : DEFAULT_ATTRIBUTES
    end
  end
end
