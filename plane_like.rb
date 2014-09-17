module PlaneLike
  attr_reader :rows

  def [](pos)
    self.rows[pos[0]][pos[1]]
  end

  def []=(pos, value)
    self.rows[pos[0]][pos[1]] = value
  end

  protected
  attr_writer :rows

end