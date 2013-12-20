module OmCli::Processor
  class Workspace < OmCli::Processor::Base
    def list(global_options, options, args)
      attributes = detect_attributes(options[:attributes])
      pagination = gimme_pagination(options)

      res = handle_error("Cannot display activities") do
        @client.workspaces
      end

      @io.display(res.map do |w|
        w.pick(*attributes)
      end)
    end

    def destroy(global_options, options, args)
      res = handle_error("Cannot display activities") do
        @client.destroy_worksapce(args.first)
      end

      @io.display("Success")
    end
  end
end
