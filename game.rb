require 'yaml'
require_relative 'board'
require_relative 'title_screen'
require_relative 'save_load'

class Game
  include SaveLoad

  attr_reader :title_screen, :board

  def initialize(board = Board.new, title_screen = TitleScreen.new)
    @board = board
    @title_screen = title_screen
    @turn = :white
  end

  def options       #timer should be paused on options screen
    loop do
      clear_screen
      title_screen.display
      process_action(get_chr, :title_mode)
    end
  end

  def play

    until won?
      board.clock.change_time(@turn)
      self.board.end_of_turn = false
      until self.board.end_of_turn
        play_turn
      end
      swap_turns
    end

    end_game
  end

  def play_turn
    clear_screen
    board.display(@turn)
    process_action(get_chr, :board_mode)
    board.clock.tick(@turn)
  end

  def end_game
    clear_screen
    board.display(@turn)
    puts "#{@turn.to_s.capitalize} won!"
    play_again
  end

  def play_again
    puts "Would you like to play again?"
    print '≽ '
    reply = gets.chomp[0].downcase
    if reply == 'y'
      new_game = Game.new
      new_game.play
    else
      puts "Oh OK that's cool. Thanks for playing I guess."
    end
  end



  def won?
    self.board.check_mate?(:black) || self.board.check_mate?(:white)
  end

  def swap_turns
    p @turn
    @turn == :white ? @turn = :black : @turn = :white
  end

  # Cursor, clearing the screen, making the title screen work, etc.

  def clear_screen
    puts "\e[H\e[2J"
  end

  def get_chr
    begin
      system("stty raw -echo")
      str = STDIN.getc
    ensure
      system("stty -raw echo")
    end
  end

  def process_action(chr, mode)
    mode_hash = {:board_mode => self.board,
                       :title_mode => self.title_screen }
    unless chr == 'o' || chr == 'r'
      mode_hash[mode].cursor_move(chr.to_sym, @turn)
    end

    if chr == 'r'
      board.cursor_move(:r, @turn) if mode == :board_mode
      choose_option if mode == :title_mode
    elsif chr == 'o'
      self.options if mode == :board_mode
    end

  end

  def choose_option
    option = self.title_screen.current_option
    case option
    when :start
      new_game = Game.new
      new_game.play
    when :save
      save
    when :load
      load
    when :return
      self.play
    when :exit
      exit
    end
  end

end