module OmCli::Processor
  class Activity
    DEFAULT_ATTRIBUTES = %w[id name description created_at]

    def initialize
    end

    def new(global_options, options, args)
      io         = detect_io(global_options[:output])
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

      io.display(res.pick(*attributes))
    end

    def list(global_options, options, args)
      io         = detect_io(global_options[:output])
      workspace  = detect_workspace(options[:workspace])
      attributes = detect_attributes(options[:attributes])
      limit      = detect_limit(options)

      pagination = {
        per_page: limit,
        page:     options[:page]  || 1
      }

      res = if workspace
        @client.workspace_items(workspace, pagination)
      else
        @client.activities(pagination)
      end

      handle_error("Cannot display activities") do
        res = res.select do |i|
          i.keys.first == "activity"
        end if workspace
      end

      io.display(res.map do |i|
        workspace.nil? ? i.pick(*attributes) : i.activity.pick(*attributes)
      end)
    end

    def detect_workspace(id)
      id.is_a?(Integer) ? id : nil
    end

    def detect_attributes(attrs)
      attrs = attrs.split(',')
      attrs.any? ? attrs : DEFAULT_ATTRIBUTES
    end

    def detect_limit(opts)
      opts[:all] ? OMCli::Processor::MAX_LIMIT : (opts[:limit] || 10)
    end
  end
end
