require 'yaml'
require_relative 'board'
require_relative 'title_screen'

class Game


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
                  :title_mode => self.title_screen}
    case chr
    when 'w'
      mode_hash[mode].cursor.up
    when 'a'
      mode_hash[mode].cursor.left
    when 's'
      mode_hash[mode].cursor.down
    when 'd'
      mode_hash[mode].cursor.right
    when 'q'
      exit        #maybe make that nicer later
    when 'r'
      board.reveal_tile if mode == :board_mode
    when 'f'
      board.switch_flagged if mode == :board_mode
    when 'o'
      self.options if mode == :board_mode
    when 'e'
      choose_option if mode == :title_mode
    end
  end

  def choose_option
    option = self.title_screen.current_option
    case option
    when :start
      new_game = Game.new
      new_game.play
    when :save
      save_data = self.to_yaml
      File.open('./ok.txt', 'w') { |file| file.puts(save_data) }
    when :load
      YAML::load(File.open('./ok.txt')).play
    when :return
      self.play
    when :exit
      exit
    end
  end

end