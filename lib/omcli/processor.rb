module OmCli::Processor
  class Core
    attr_reader :client, :user

    def initialize
      @client = OmCli::Client.new
      @user   = OmCli::User.new(@client)
    end
  end

  autoload :Activity,   'omcli/processor/activity'
  autoload :Workspace,  'omcli/processor/workspace'
end
