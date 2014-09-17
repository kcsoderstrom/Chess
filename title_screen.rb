require 'colorize'
require_relative 'cursor'
require_relative 'save_load'
require_relative 'board'
require_relative 'game'

class TitleScreen

  include SaveLoad
  attr_reader :options, :cursor, :message_hash, :title, :board

  def initialize(board, cursor = Cursor.new(1,5))
    @board = board
    @cursor = cursor
    @options = [ :start, :save, :load, :return, :exit ]
                  #it has to be this way for cursor
    @message_hash = { :start => "START NEW GAME",
                      :save => "SAVE",
                      :load => "LOAD SAVED GAME",
                      :return => "RETURN TO GAME",
                      :exit => "QUIT" }
  end

  def title
    "CHESS"
  end

  def cursor_move(sym, turn)
    unless sym == :r
      cursor.cursor_move(sym)
    else
      choose_option
    end
  end

  def current_option
    self.options[self.cursor.row]
  end

  def render
    str = self.title << "\n\n"
    syms_arr = self.options.flatten
    syms_arr.each_with_index do |sym, i|
      if i == self.cursor.row
        str << message_hash[sym].colorize(:light_black)
      else
        str << message_hash[sym]
      end
      str << "\n"
    end
    str
  end

  def display
    puts render
  end

  def choose_option
    case current_option
    when :start
      new_game = Game.new
      new_game.play
    when :save
      save
    when :load
      load
    when :return
      return :board_mode
    when :exit
      exit
    end

    :title_mode
  end

end