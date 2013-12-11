module OmCli
  class User
    attr_accessor :id, :email, :personal_workspace

    def initialize(client)
      user = client.me
      @id = user.email
      @email = user.email

      @personal_workspace = client.workspaces.first
    end
  end
end
