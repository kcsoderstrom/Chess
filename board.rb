require_relative 'piece' #might not need this wedk
require_relative 'cursor'
require_relative 'chars_array'
require 'colorize'

class Board

  COLORS = [:white, :black]

  attr_reader :rows, :cursor, :prev_pos

  def initialize(cursor = Cursor.new)
    @rows = Array.new(8) { Array.new(8) }
    place_pieces
    @cursor = cursor
    @prev_pos = nil
  end

  def click(turn)
    pos = [cursor.row, cursor.col]
    if @prev_pos.nil?
      @prev_pos = pos unless self[pos].nil? || self[pos].color != turn
    else
      begin
        move(@prev_pos, pos, turn)
      rescue RuntimeError
        @prev_pos = nil
      end
      @prev_pos = nil
    end
  end

  def opposite(color)
    color == COLORS[0] ? COLORS[1] : COLORS[0]
  end

  def [](pos)
    self.rows[pos[0]][pos[1]]
  end

  def []=(pos, piece)
    self.rows[pos[0]][pos[1]] = piece
  end

  def king(color)
    king = all_pieces(color).select { |piece| piece.is_a?(King) }[0]
  end

  def in_check?(color)
    all_pieces(opposite(color)).any? do |piece|
      piece.moves.include?(king(color).pos)
    end
  end

  def check_mate?(color)
    all_pieces(color).all? do |piece|
      piece.valid_moves.empty?
    end && in_check?(color)  #need to test
  end

  def move(start, end_pos, color)

    raise "Move your own piece, cheater!" unless self[start].color == color
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
    if self[end_pos].is_a?(Pawn)
      self[end_pos].first_move = false
    end
    #might want to implement a .taken for self[end_pos]
  end

  def update_pos(piece, new_pos)
    piece.pos = new_pos           #that shouldn't be doable make some privates
  end

  def dup
    duped = Board.new
    8.times do |y|
      rows[y].each_with_index do |piece, x|
        duped[[y,x]] = nil
        unless self[[y,x]].nil?
          duped[[y,x]] = piece.class.new(duped,piece.color,[y, x])
        end
      end
    end
    duped
  end

  def all_pieces(color)
    self.rows.flatten.compact.select { |piece| piece.color == color }
  end

  def display(turn)
    puts render(turn)
  end

  protected
  attr_writer :rows

  private
  def place_pieces
    self[[0, 0]] = Rook.new(self, :black, [0, 0])
    self[[0, 7]] = Rook.new(self, :black, [0, 7])
    self[[0, 1]] = Knight.new(self, :black, [0, 1])
    self[[0, 6]] = Knight.new(self, :black, [0, 6])
    self[[0, 2]] = Bishop.new(self, :black, [0, 2])
    self[[0, 5]] = Bishop.new(self, :black, [0, 5])
    self[[0, 3]] = Queen.new(self, :black, [0, 3])
    self[[0, 4]] = King.new(self, :black, [0, 4])

    self[[7, 0]] = Rook.new(self, :white, [7, 0])
    self[[7, 7]] = Rook.new(self, :white, [7, 7])
    self[[7, 1]] = Knight.new(self, :white, [7, 1])
    self[[7, 6]] = Knight.new(self, :white, [7, 6])
    self[[7, 2]] = Bishop.new(self, :white, [7, 2])
    self[[7, 5]] = Bishop.new(self, :white, [7, 5])
    self[[7, 3]] = Queen.new(self, :white, [7, 3])
    self[[7, 4]] = King.new(self, :white, [7, 4])

    8.times do |col|
      rows[1][col] = Pawn.new(self, :black, [1, col])
      rows[6][col] = Pawn.new(self, :white, [6, col])
    end
  end

  def render(turn)
    characters_array = CharsArray.new(self, turn).rows

    str = ''
    characters_array.each do |row|
      row.each { |char| str << char }
      str << "\n"
    end
    str
  end

end