#basic cursor implementation

class Cursor

  attr_reader :row, :col, :width, :height

  def initialize(width = 9, height = 9)
    @width = width
    @height = height
    @row = 0
    @col = 0
  end

  def left
    @col = (col - 1) % self.width
  end

  def right
    @col = (col + 1) % self.width
  end

  def up
    @row = (row - 1) % self.height
  end

  def down
    @row = (row + 1) % self.height
  end

  def pos
    [self.row, self.col]
  end

end
