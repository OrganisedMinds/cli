module OmCli::Processor
  class Core
    attr_reader :client

    MAX_LIMIT = 250

    def initialize
    end

    def proceed(object, command, global_options, options, args)
      @client ||= OmCli::Client.new

      object = "OmCli::Processor::#{object.capitalize}"

      handler = Object.const_get(object).new(global_options)

      handler.instance_variable_set(:@client, client)

      class << handler
        self.send(:include, InstanceMethods)
      end

      handler.send(
        command, global_options, options, args
      )
    end

    module InstanceMethods
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
end
