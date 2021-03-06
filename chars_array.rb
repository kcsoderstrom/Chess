require_relative 'board'
require_relative 'plane_like'

class CharsArray

  include PlaneLike

  WHITE_CHARS = { :King => '♔',
            :Queen => '♕',
            :Bishop => '♗',
            :Knight => '♘',
            :Rook => '♖',
            :Pawn => '♙' }

  BLACK_CHARS = { :King => '♚',
            :Queen => '♛',
            :Bishop => '♝',
            :Knight => '♞',
            :Rook => '♜',
            :Pawn => '♟' }

  BG_COLORS = [:light_white, :light_black]

  attr_accessor :board, :turn

  def initialize(board, turn)
    @rows = Array.new(8) { Array.new(8) }
    @board = board
    @turn = turn
    @bg_color = :light_black
  end

  # Converts the board to characters, then highlights.
  # Don't use this on the taken pieces.
  def characters_array    # That's a terrible name.
    convert_to_chars
    highlight_squares
    self.rows
  end

  def highlight_squares
    unless self.board.prev_pos.nil?
      selected_piece = self.board[self.board.prev_pos]
      hold_highlight_on_selected_piece
      highlight_available_moves(selected_piece)
    end

    highlight_cursor
    self
  end

  def highlight_available_moves(selected_piece)
    unless selected_piece.nil? || selected_piece.color != turn
      selected_piece.valid_moves.each do |move|
        self[move] = self[move].colorize(:background => :green)
      end
    end
  end

  def hold_highlight_on_selected_piece
    pos = board.prev_pos
    self[pos] = self[pos].colorize(:background => :cyan)
  end

  def highlight_cursor
    pos = board.cursor.pos
    self[pos] = self[pos].colorize(:background => :cyan)
  end


  def convert_to_chars
    self.rows = Array.new (8) { Array.new (8) }

    8.times do |y|
      board.rows[y].each_with_index do |piece, x|
        unless piece.nil?
          if piece.color == :white
            char = WHITE_CHARS[piece.class.to_s.to_sym]
          else
            char = BLACK_CHARS[piece.class.to_s.to_sym]
          end
          char = char.colorize( :background => background_color_swap )
          self.rows[y][x] = char
        else
          self.rows[y][x] = ' '.colorize(:background => background_color_swap)
        end
      end

      background_color_swap
    end
    self
  end

  def background_color_swap
    @bg_color =  ( BG_COLORS - [@bg_color] )[0] # hacky ew
    @bg_color
  end

  def upgrade_char
    piece_index = board.upgrade_cursor.col
    color = :white  #get that from cursor
    char_hash = (color == :white ? WHITE_CHARS : BLACK_CHARS )
    piece_types = char_hash.keys

    char_hash[ piece_types[piece_index] ]
  end

  def convert_taken_to_chars(color)
    takens = ( color == :white ? board.takens[0] : board.takens[1])
    num_pieces = takens.count
    self.rows = []
    color = takens[0].color unless takens.empty?
    char_hash = (color == :white ? WHITE_CHARS : BLACK_CHARS)

    num_pieces.times do |i|
      piece = takens[i]
      self.rows << char_hash[piece.class.to_s.to_sym]
    end
    self.rows
  end

end
