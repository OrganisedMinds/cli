module OmCli::Processor
  class Activity
    def initialize
    end

    def new(global_options, options, args)
      res = @client.create_activity(name: args.first)
      @client.workspace_inbox_add(
        @user.personal_workspace.id, item_type: "Activity", item_id: res.id
      )
      puts "Activity #{res.name} was successfully created in your personal workspace."
    end

    def list(global_options, options, args)
      ws = @user.personal_workspace.id unless options[:workspace]

      res = @client.workspace_items(ws).select { |i| i.keys.first == "activity" }
      Formatador.display_table(res.map { |i| i.activity.pick("id", "name", "description") })
    end
  end
end
