module SaveLoad

  def load
    save_files = Dir.entries("./save_files/").drop(2) #first 2 are '.' and '..'

    save_files = save_files.map do |entry|
      "\n\t" + entry.to_s
    end.join

    puts ''
    puts "Save Files: #{save_files}"
    puts ''
    print "Load file:\n"
    begin
      print "\t"
      file_name = gets.chomp
      load_game = YAML::load(File.open("./save_files/#{file_name}"))
      load_game.board.clock.set_last_tick
      load_game.play
    rescue Errno::ENOENT
      puts "File not found."
      retry
    rescue Errno::EISDIR
      puts "Ok, return to menu"
    end
  end

  def save
    save_data = self.to_yaml
    puts ''
    print "Save as: "
    file_name = gets.chomp
    File.open("./save_files/#{file_name}", 'w') {|file| file.puts(save_data)}
  end

end