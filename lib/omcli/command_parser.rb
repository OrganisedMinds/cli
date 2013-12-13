module OmCli
  class CommandParser
    include GLI::App

    def initialize
      @processor = OmCli::Processor::Core.new
      init_gli
    end

    def init_gli
      program_desc 'OrganisedMinds CLI'

      version OmCli::VERSION

      subcommand_option_handling :normal

      desc "Output format. Possible values are #{OmCli::IO::OUTPUT_TYPES.join(', ')}"
      flag :output, default_value: "table", must_match: OmCli::IO::OUTPUT_TYPES

      init_activities
      init_workspaces

      pre do |global,command,options,args|
        # Pre logic here
        # Return true to proceed; false to abort and not call the
        # chosen command
        # Use skips_pre before a command to skip this block
        # on that command only
        true
      end

      post do |global,command,options,args|
        # Post logic here
        # Use skips_post before a command to skip this
        # block on that command only
      end

      on_error do |exception|
        # Error logic here
        # return false to skip default error handling
        # false
        # true
        puts "DEBUG: #{exception.inspect}"
        puts "DEBUG: #{exception.backtrace.join("\n")}"
      end

      exit run(ARGV)
    end

    def init_activities
      desc 'manage activities'
      command :activity do |c|
        c.desc 'list activities'
        c.command :list do |s|
          s.desc "Page to show"
          s.flag :page, default_value: 1, type: Integer

          s.desc "Limit of activities per page"
          s.flag :limit, default_value: 20, type: Integer

          # TODO: implement this
          # add user
          # allow list without workspace or stack
          #
          # s.desc "Id of a stack"
          # s.flag [:s, :stack], type: Integer

          s.desc "Id of a workspace"
          s.flag [:w, :workspace], type: Integer

          s.desc "Attributes to show"
          s.flag [:attributes], default_value: "id,name,description"

          s.desc "Don't paginate activities. It will ignore --page and --limit flags."
          s.switch [:A, :all]

          s.action do |global_options,options,args|
            @processor.proceed(c.name, s.name, global_options, options, args)
          end
        end

        c.desc 'create new activity'
        c.arg_name '<name_of_activity>'
        c.command :new do |s|
          s.desc "Id of a workspace to create an activity in"
          s.flag [:w, :workspace], type: Integer

          s.desc "Attributes to show for newly created activity"
          s.flag [:attributes], default_value: "id,name,description"

          s.action do |global_options, options, args|
            @processor.proceed(c.name, s.name, global_options, options, args)
          end
        end
      end
    end

    def init_workspaces
      desc 'manage workspaces'
      command :workspace do |c|
        c.desc 'list workspaces'
        c.command :list do |n|
          n.action do |global_options, options, args|
            @processor.proceed(c.name, n.name, global_options, options, args)
          end
        end

        c.desc 'delete workspace'
        c.arg_name 'id_of_workspace'
        c.command :destroy do |n|
          n.action do |global_options, options, args|
            @processor.proceed(c.name, n.name, global_options, options, args)
          end
        end
      end
    end
  end
end
