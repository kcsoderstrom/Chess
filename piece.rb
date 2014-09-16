require_relative 'board'

class Piece

  attr_accessor :pos

  attr_reader :board, :color

  def initialize(board = Board.new, color = :white, pos = [0, 0])
    @color = color
    @pos = pos
    @board = board
    @board[pos] = self
  end

  def moves
    [[0,1]]
  end

  def move_into_check?(pos)
   test_board = self.board.dup
   test_board[self.pos] = nil
   test_board[pos] = self.class.new(test_board, self.color, pos )
   test_board.in_check?(self.color)
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }.select(&:legal?)
  end

  def legal?(new_pos)
    test_board = self.board.dup
    test_board[self.pos] = self.class.new(test_board, self.color, self.pos)
    begin
      test_board.move(self.pos, new_pos)
    rescue RuntimeError
      return false
    end
    true
  end

end

class SlidingPiece < Piece
  def moves
    #uses move_dirs
  end
end

class SteppingPiece < Piece

end

class King < SteppingPiece
end