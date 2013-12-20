module OmCli::Processor
  class Activity < OmCli::Processor::Base
    DEFAULT_ATTRIBUTES = %w[id name]

    def new(global_options, options, args)
      workspace  = detect_workspace(options[:workspace])
      attributes = detect_attributes(options[:attributes])

      res = handle_error("Cannot create activity") do
        @client.create_activity(name: args.first)
      end

      if workspace
        handle_error("Cannot put activity on stack") do
          @client.workspace_inbox_add(
            workspace, item_type: "Activity", item_id: res.id
          )
        end
      end

      @io.display(res.pick(*attributes))
    end

    def list(global_options, options, args)
      workspace  = detect_workspace(options[:workspace])
      attributes = detect_attributes(options[:attributes])
      pagination = gimme_pagination(options)

      res = handle_error("Cannot display activities") do
        if workspace
          @client.workspace_items(workspace, pagination)
        else
          @client.activities(pagination)
        end
      end

      res = res.select do |i|
        i.keys.first == "activity"
      end if workspace

      @io.display(res.map do |i|
        workspace.nil? ? i.pick(*attributes) : i.activity.pick(*attributes)
      end)
    end

    %w[play pause finish delete reject approve accept decline take_back take_over].each do |action|
      define_method(action) do |global_options, options, args|
        attributes = detect_attributes(options[:attributes])

        res = handle_error("Cannot #{action} activity") do
          @client.send("#{action}_activity", args.first)
        end

        @io.display(res.pick(*attributes))
      end
    end

    def detect_workspace(id)
      id.is_a?(Integer) ? id : nil
    end
  end
end
