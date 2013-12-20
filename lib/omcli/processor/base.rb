module OmCli::Processor
  class Base
    def initialize(global_options)
      @io = detect_io(global_options[:output])
      @client ||= OmCli::Client.new
    end

    def detect_io(mode)
      OmCli::IO.new(mode)
    end

    def detect_attributes(attrs)
      attrs = attrs.split(',')
      attrs.any? ? attrs : DEFAULT_ATTRIBUTES
    end

    def handle_error(msg="Error")
      res = yield
      unless @client.last_response.status == 200
        @io.error(res && res.respond_to?(:message) ? res.message : msg)
        exit(1)
      end

      return res
    end

    def gimme_pagination(opts)
      {
        per_page: opts[:all] ? OMCli::Processor::MAX_LIMIT : (opts[:limit] || 10),
        page:     opts[:page] || 1
      }
    end
  end
end
