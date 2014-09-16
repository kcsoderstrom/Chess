require_relative 'board'

class Piece

  attr_reader :pos, :board, :color

  def initialize(board = Board.new, color = :white, pos = [0, 0])
    @color = color
    @pos = pos
    @board = board
  end

  def moves
  end

  def move_into_check?(pos)
   test_board = self.board.dup
   test_board[self.pos] = nil
   test_board[pos] = self.class.new(self.color, pos, test_board)
   test_board.in_check?(self.color)
  end

end

class SlidingPiece < Piece
  def moves
    #uses move_dirs
  end
end

class SteppingPiece < Piece

end