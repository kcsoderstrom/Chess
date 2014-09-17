# tools necessary for using the Cursor class effectively

module CursorScreen

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

end

# You will need something to process the character
# into a symbol that the cursor can use.