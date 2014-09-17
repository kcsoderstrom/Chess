class ChessClock

  def initialize
    @white_time = 0
    @black_time = 0
    @white_current_time = 0
    @black_current_time = 0
    @last_tick = Time.now
  end

  def change_time(color)
    if color == :white
      @black_time += @black_current_time
    else
      @white_time += @white_current_time
    end
    @white_current_time, @black_current_time = 0, 0
  end

  def tick(color)
    if color == :white
      @white_current_time += Time.now - @last_tick
    else
      @black_current_time += Time.now - @last_tick
    end

    @last_tick = Time.now
  end

  def convert_times
    [ Time.at(@white_current_time - 19*60*60).strftime("%H:%M:%S"),
      Time.at(@white_time - 19*60*60).strftime("%H:%M:%S"),
      Time.at(@black_current_time - 19*60*60).strftime("%H:%M:%S"),
      Time.at(@black_time - 19*60*60).strftime("%H:%M:%S") ]
  end

end