class Game < ActiveRecord::Base
  has_many :frames
  # has_many :tries, through :frames


  def is_game_over?
    if self.frames.at(9) &&  self.frames.at(9).tries.count == 2 && self.frames.at(9).tries.pluck(:score).take(2).inject(:+) < 10
      return true
    elsif self.frames.at(9) &&  self.frames.at(9).tries.count == 3
      return true
    else
      return false
    end
  end

end
