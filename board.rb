require_relative 'piece' #might not need this wedk

class Board

  COLORS = [:white, :black]

  attr_reader :rows

  def initialize
    @rows = Array.new(8) { Array.new(8) }
    #place pieces in their initial positions
  end

  def opposite(color)
    color == COLORS[0] ? COLORS[1] : color
  end

  def [](pos)
    self.rows[pos[0]][pos[1]]
  end

  def []=(pos, piece)
    self.rows[pos[0]][pos[1]] = piece
  end

  def in_check?(color)
    king = all_pieces(color).select do |piece|
      piece.is_a?(King) && piece.color == color
    end[0]

    all_pieces(opposite(color)).any? { |piece| piece.moves.include?(king.pos) }
  end

  def check_mate?(color)
    all_pieces(color).all? { |piece| piece.valid_moves.empty? } &&
    in_check?(color)  #need to test #valid_moves not written
  end

  def move(start, end_pos)

    raise "No piece at that position." if self[start].nil?
    raise "Invalid move." unless self[start].moves.include?(end_pos)
    unless self[end_pos].nil?
      raise "Cannot take the king." if self[end_pos].is_a?(King)
      if self[end_pos].color == self[start].color
        raise "Cannot take a piece of your own color"
      end
    end

    self[start], self[end_pos] = nil, self[start]
    update_pos(self[end_pos], end_pos)      #this seems stupid
    #might want to implement a .taken for self[end_pos]
  end

  def update_pos(piece, new_pos)
    piece.pos = new_pos           #that shouldn't be doable make some privates
  end

  def dup
    duped = Board.new
    duped.rows = @rows.map(&:dup)
    duped
  end

  def all_pieces(color)
    self.rows.flatten.select { |piece| piece.color == color }
  end

  protected
  attr_writer :rows

end