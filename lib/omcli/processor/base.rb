module OmCli::Processor
  class Base
    def initialize(global_options)
      @io = detect_io(global_options[:output])
    end

    def detect_io(mode)
      OmCli::IO.new(mode)
    end
  end
end
