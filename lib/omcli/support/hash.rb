class Hash
  def pick(*values)
    res = {}

    values.each do |value|
      res[value] = value.match(/(\w+)\.(\w+)/) ? self.send($1).send($2) : self.send(value)
    end

    res
  end
end
