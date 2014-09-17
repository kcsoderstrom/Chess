require_relative 'board'
require_relative 'plane_like'

class CharsArray

  include PlaneLike

  WHITE_CHARS = { :King => '♕',
            :Queen => '♔',
            :Bishop => '♗',
            :Knight => '♘',
            :Rook => '♖',
            :Pawn => '♙' }

  BLACK_CHARS = { :King => '♛',
            :Queen => '♚',
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
    convert_to_chars
    highlight_squares
  end

  def highlight_squares
    unless self.board.prev_pos.nil?
      selected_piece = self.board[self.board.prev_pos]
      hold_highlight_on_selected_piece
      highlight_available_moves(selected_piece)
    end

    highlight_cursor
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
    self.rows = board.rows.map(&:dup)

    8.times do |y|
      board.rows[y].each_with_index do |piece, x|
        unless piece.nil?
          if piece.color == :white
            char = WHITE_CHARS[piece.class.to_s.to_sym]
          else
            char = BLACK_CHARS[piece.class.to_s.to_sym]
          end
          char = char.colorize(piece.color)
          char = char.colorize( :background => background_color_swap )
          self.rows[y][x] = char
        else
          self.rows[y][x] = ' '.colorize(:background => background_color_swap)
        end
      end
      background_color_swap
    end
  end

  def background_color_swap
    @bg_color =  ( BG_COLORS - [@bg_color] )[0] # hacky ew
    @bg_color
  end
end
