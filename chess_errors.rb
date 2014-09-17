# Should we really have different names for all these errors?
# I don't know.

module ChessErrors

  class WrongColor < ArgumentError
  end
  class EmptySquare < ArgumentError
  end
  class IllegalMove < ArgumentError
  end
  class KingTaken < ArgumentError
  end
  class SuicideError < ArgumentError
  end

  def raise_move_errors(start, end_pos, color)
    raise WrongColor unless self[start].color == color
    raise EmptySquare if self[start].nil?
    raise IllegalMove unless self[start].moves.include?(end_pos)
    raise KingTaken if self[end_pos].is_a?(King)

    unless self[end_pos].nil?
      raise SuicideError if self[end_pos].color == self[start].color
    end

  end

end