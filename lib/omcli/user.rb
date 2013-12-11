module OmCli
  class User
    attr_accessor :id, :email, :personal_workspace

    def initialize(client)
      user = client.me
      @id = user.email
      @email = user.email

      @personal_workspace = client.workspaces.first
    rescue
      Formatador.display_line('[red]Cannot get info about you. Is your config valid?[/]')
    end
  end
end
