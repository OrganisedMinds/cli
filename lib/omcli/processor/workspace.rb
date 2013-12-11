module OmCli::Processor
  class Workspace < OmCli::Processor::Core
    def list(global_options, options, args)
      res = client.workspaces
      Formatador.display_table(res.map { |w| w.pick("id", "name", "description") })
    end

    def destroy(global_options, options, args)
      res = client.destroy_workspace(args)
      Formatador.display_line("[green]Success[/]")
    end
  end
end
