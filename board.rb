require_relative 'piece' #might not need this wedk

class Board

  attr_reader :rows

  def initialize
    @rows = Array.new(8) { Array.new(8) }
    #place pieces in their initial positions
  end

  def [](pos)
    self.rows[pos[0]][pos[1]]
  end

  def []=(pos, value)     #value is a terrible name change later
    self.rows[pos[0]][pos[1]] = value
  end

  def in_check?(player)
    #find king
    #position not in place of opp-color's potential moves
  end

  def move(start, end_pos)
    raise "No piece at that position." if self[start] == nil
    raise "Invalid move." unless self[start].moves.include?(end_pos)
    raise "Cannot take the king." if self[end_pos].is_a?(King) #make that a class ok?
    self[start], self[end_pos] = nil, self[start]
    #might want to implement a .taken for self[end_pos]
  end

end