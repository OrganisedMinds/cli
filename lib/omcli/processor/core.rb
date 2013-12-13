module OmCli::Processor
  class Core
    attr_reader :client, :user

    def initialize
    end

    def proceed(object, command, global_options, options, args)
      @client ||= OmCli::Client.new
      @user   ||= OmCli::User.new(client)

      object = "OmCli::Processor::#{object.capitalize}"

      handler = Object.const_get(object).new

      handler.instance_variable_set(:@client, client)
      handler.instance_variable_set(:@user,   user)

      handler.send(
        command, global_options, options, args
      )
    end
  end
end
