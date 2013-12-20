module OmCli::Processor
  class User < OmCli::Processor::Base
    DEFAULT_ATTRIBUTES = %w[id email first_name last_name]

    def initialize(*args)
      super(*args)
    end

    def me(global_options, options, args)
      attributes = detect_attributes(options[:attributes])

      res = handle_error("Cannot gen info about current user") do
        @client.me
      end

      @io.display(res.pick(*attributes))
    end

    def list(global_options, options, args)
      attributes = detect_attributes(options[:attributes])
      pagination = gimme_pagination(options)

      res = handle_error("Cannot get your connections") do
        @client.users(pagination)
      end

      @io.display(res.map do |u|
        u.pick(*attributes)
      end)
    end

    def show(global_options, options, args)
      attributes = detect_attributes(options[:attributes])

      res = handle_errors("Cannot get single user") do
        @client.user(args.first)
      end

      @io.display(res.pick(*attributes))
    end

    def detect_attributes(attrs)
      attrs = attrs.split(',')
      attrs.any? ? attrs : DEFAULT_ATTRIBUTES
    end
  end
end
