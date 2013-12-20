module OmCli
  class IO
    OUTPUT_TYPES = ["table", "list", "json"]
    # TODO: it should be optionable
    SPLITTER = ', '

    def initialize(mode)
      @mode = OUTPUT_TYPES.include?(mode) ? mode : "table"
    end

    def display(data)
      self.send("display_#{@mode}", data)
    end

    def display_table(data)
      case data
      when Array
        data.any? ? Formatador.display_table(data) :
          warning("No data available")
      when Hash
        data.any? ? Formatador.display_table([data]) :
          warning("No data available")
      end
    end

    def display_list(data)
      case data
      when Array
        # TODO: line.values will work only for array of hashes
        data.each { |line| self.puts(line.values.join(SPLITTER)) }
      when Hash
        self.puts(data.values.join(SPLITTER))
      when String
        self.puts(data)
      end
    end

    def display_json(data)
      self.puts(JSON.pretty_generate(JSON.parse(data.to_json)).gsub("{\n", '{').gsub(/\{\s+/, '{ '))
    end

    [
      ["warning", "yellow"],
      ["success", "green"],
      ["error",   "red"],
      ["puts",    "normal"]
    ].each do |type|
      define_method(type[0]) do |msg|
        Formatador.display_line("[#{type[1]}]#{msg}[/]")
      end
    end
  end
end
