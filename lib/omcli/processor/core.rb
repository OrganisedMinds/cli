module OmCli::Processor
  class Core
    attr_reader :client

    MAX_LIMIT = 250

    def initialize
    end

    def proceed(object, command, global_options, options, args)
      object = "OmCli::Processor::#{object.capitalize}"

      handler = Object.const_get(object).new(global_options)

      handler.send(
        command, global_options, options, args
      )
    end
  end
end
