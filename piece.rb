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
  end

  def on_board?(pos)
    pos[0].between?(0,7) && pos[1].between?(0,7)
  end

  def move_into_check?(pos)
   test_board = self.board.dup
   test_board[self.pos] = nil
   test_board[pos] = self.class.new(test_board, self.color, pos )
   test_board.in_check?(self.color)
  end

  def valid_moves
    moves.select do |move|
      legal?(move)
    end.reject do |move|
      move_into_check?(move)
    end
  end

  def legal?(new_pos)
    test_board = self.board.dup
    begin
      test_board.move(self.pos, new_pos, self.color)
    rescue RuntimeError
      return false
    end
    true
  end

end


class SlidingPiece < Piece
  def moves
    some_moves = []
    self.class.move_dirs.each do |delta|

      y, x = delta[0] + self.pos[0], delta[1] + self.pos[1]
      next unless on_board?([y, x])

      some_moves << [y,x]
      blocked = false

      until blocked == true
        blocked = true
        break unless self.board[some_moves.last].nil?

        y, x = delta[0] + some_moves.last[0], delta[1] + some_moves.last[1]
        break unless on_board?([y, x])

        some_moves << [y,x]
        blocked = false
      end

    end
    some_moves
  end
end

class SteppingPiece < Piece
  def moves
    self.class.deltas.map do |delta|
      y, x = delta[0] + self.pos[0], delta[1] + self.pos[1]
      [y,x] if on_board?([y, x])
    end.compact
  end
end

class Knight < SteppingPiece
  def self.deltas
    [[1, 2], [1, -2], [-1, 2], [-1, -2],
     [2, 1], [2, -1], [-2, 1], [-2, -1]]
  end
end

class King < SteppingPiece
  def self.deltas
    [[1, 0], [-1, 0], [0, 1], [0, -1],
     [1, 1], [-1, 1], [1, -1], [-1, -1]]
  end
end

class Bishop < SlidingPiece
  def self.move_dirs
    [ [1, 1], [1, -1], [-1, 1], [-1, -1] ]
  end
end

class Rook < SlidingPiece
  def self.move_dirs
    [ [0, 1], [1, 0], [0, -1], [-1, 0] ]
  end
end

class Queen < SlidingPiece
  def self.move_dirs
    [ [0, 1], [1, 0], [0, -1], [-1, 0],
      [1, 1], [1, -1], [-1, 1], [-1, -1] ]
  end
end

class Pawn < Piece

  COLOR_DIR = { :black => 1, :white => -1 }
  attr_accessor :first_move
  attr_reader :delta

  def initialize(board = Board.new, color = :white, pos = [0, 0])
    @first_move = true
    super(board, color, pos)
    @delta = COLOR_DIR[self.color]
  end

  def moves     # still kind of ugly
    moves = []
    y, x = self.pos[0] + delta, self.pos[1]
    moves << [y, x] if on_board?([y, x])
    moves << [y + delta, x] if on_board?([y + delta, x]) && self.first_move
    straight_moves = moves.select { |move| board[move].nil? }

    diag_moves = [ [y, x - 1], [y, x + 1] ]
    diag_moves.select! { |pos| on_board?(pos) && !self.board[pos].nil? }
    diag_moves.reject! { |pos| board[pos].nil? }

    straight_moves + diag_moves
  end

end