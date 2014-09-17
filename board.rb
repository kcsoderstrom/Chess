require_relative "game"
require_relative 'piece' #might not need this wedk
require_relative 'cursor'
require_relative 'chars_array'
require_relative 'plane_like'
require_relative 'chess_clock'
require_relative 'chess_errors'
require_relative 'symbol'
require 'colorize'

class Board

  include PlaneLike
  include ChessErrors

  COLORS = [:white, :black]
  UPGRADES = [ :Queen, :Bishop, :Knight, :Rook ]

  attr_reader :cursor, :prev_pos, :clock, :upgrade_cursor
  attr_accessor :end_of_turn, :takens

  def initialize
    @rows = Array.new(8) { Array.new(8) }
    place_pieces
    @cursor, @upgrade_cursor = Cursor.new, Cursor.new(UPGRADES.count, 1)
    @prev_pos = nil
    @end_of_turn = false
    @clock = ChessClock.new
    @takens = [[],[]]
    @mode = :normal
  end

  def click(turn)
    pos = cursor.pos

    if self.prev_pos.nil?
      self.prev_pos = pos unless self[pos].nil? || self[pos].color != turn
    else
      begin
        move(self.prev_pos, pos, turn)
        self.end_of_turn = true
      rescue ArgumentError
        self.prev_pos = nil   # clicked in a bad spot so resets
      end
      self.prev_pos = nil
    end
  end

  def opposite(color)
    color == COLORS[0] ? COLORS[1] : COLORS[0]
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
    end && in_check?(color)
  end

  def move(start, end_pos, color)
    raise_move_errors(start, end_pos, color)

    taken_piece = self[end_pos]
    self[start], self[end_pos] = nil, self[start]

    unless taken_piece.nil?
      (taken_piece.color == :white ? takens[0] : takens[1]) << taken_piece
    end

    moved_piece = self[end_pos]
    moved_piece.update_pos(end_pos)      #this seems stupid
    moved_piece.first_move = false

    @mode = :upgrade if moved_piece.is_a?(Pawn) && moved_piece.at_end?
  end

  def scroll_upgrade(pos)
    piece_index = self.upgrade_cursor.col
    piece_type = UPGRADES[piece_index].convert_to_class
    self[pos] = piece_type.new(self, self[pos].color, pos)
  end

  def cursor_move(sym,turn)
    if sym == :r
      @mode = :normal
      self.click(turn)
    elsif sym == :o
      return :title_mode
    else
      if @mode == :upgrade
        upgrade_cursor.cursor_move(sym)
        scroll_upgrade(cursor.pos)
      else
        cursor.cursor_move(sym)
      end
    end
    :board_mode
  end

  def dup
    duped = Board.new
    8.times do |y|
      rows[y].each_with_index do |piece, x|
        duped[[y,x]] = nil                   # Have to do this bc place_pieces
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
  attr_writer :prev_pos

  private
  attr_accessor :mode
  def taken_pieces(color)
    color == :white ? takens[0] : takens[1]
  end

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
    characters_array = CharsArray.new(self, turn).characters_array
    white_chars = CharsArray.new(self, turn).convert_taken_to_chars(:white)
    black_chars = CharsArray.new(self, turn).convert_taken_to_chars(:black)
    white_chars.sort!
    black_chars.sort!       #should probably sort the pieces really

    str = ''
    str << white_chars.drop(8).join << "\n"
    str << white_chars.take(8).join << "\n"
    characters_array.each do |row|
      row.each { |char| str << char }
      str << "\n"
    end
    str << black_chars.take(8).join << "\n"
    str << black_chars.drop(8).join << "\n"

    str << "White Current Time: #{clock.convert_times[0]} \t" <<
           "White Total Time: #{clock.convert_times[1]}\n" <<
           "Black Current Time: #{clock.convert_times[2]} \t" <<
           "Black Total Time: #{clock.convert_times[3]}"
    str

  end

end