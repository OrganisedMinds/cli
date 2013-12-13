module OmCli::Processor
  class Activity
    ALLOWED_ATTRIBUTES = %w[id name description state created_at updated_at
      target_date alarm priority size progress assignee creator]

    DEFAULT_ATTRIBUTES = %w[id name description created_at]

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
      io         = detect_io(global_options[:output])
      workspace  = detect_workspace(options[:workspace])
      attributes = detect_attributes(options[:attributes])

      res = @client.workspace_items(workspace)

      if @client.last_response.status == 200
        res = res.select do |i|
          i.keys.first == "activity"
        end
      else
        io.error(res.message ? res.message : "Cannot display activities :(.")
        exit(1)
      end

      io.display(res.map do |i|
        i.activity.pick(*attributes)
      end)
    end

    def detect_workspace(id)
      id.nil? ? @user.personal_workspace : id
    end

    def detect_attributes(attrs)
      attrs = attrs.split(',')
      attrs.each do |attr|
        ALLOWED_ATTRIBUTES.include?(attr) ? next :
          raise(GLI::UnknownCommandArgument, "Attributes must be comma separated")
      end
      attrs.any? ? attrs : DEFAULT_ATTRIBUTES
    end

    def detect_io(mode)
      OmCli::IO.new(mode)
    end
  end
end
