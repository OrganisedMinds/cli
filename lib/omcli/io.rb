module OmCli
  class IO
    OUTPUT_TYPES = ["table", "list", "json"]

    def initialize(mode)
      @mode = OUTPUT_TYPES.include?(mode) ? mode : "table"
    end

    def display(data)
      self.send("display_#{@mode}", data)
    end

    def display_table(data)
      (data && data.any?) ? Formatador.display_table(data) :
        warning("No data available")
    end

    def display_list(data)
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
