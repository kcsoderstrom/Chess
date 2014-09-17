class Symbol
  def convert_to_class
    Object.const_get(self.to_s)
  end
end