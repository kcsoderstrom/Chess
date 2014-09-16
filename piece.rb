require_relative 'board'

class Piece

  attr_reader :pos, :board

  def initialize(pos, board = Board.new)
    @pos = pos
    @board = board
  end
  def moves
  end
end

class SlidingPiece < Piece
  def moves
    #uses move_dirs
  end
end

class SteppingPiece < Piece

end