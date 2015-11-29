class Try < ActiveRecord::Base
  belongs_to :frame
  after_save :cumulate_score
  validates :score, presence: true
  validates :score, :numericality => true
  validates :score, :inclusion => { :in => 0..10, :message => "The score can only be between 0 and 10" }

  def prev
    Try.joins(:frame).where("frames.game_id = ? and tries.id < ?", self.frame.game_id, self.id).last
  end

  def cumulate_score


    currrent_framce = self.frame

    if self.score  == 10 && self.position == 1 && self.frame.game.frames.count != 10
      currrent_framce.strike = true # if its a strike we save the information
    elsif self.position == 2 && (self.prev.score + self.score) == 10 && self.frame.game.frames.count != 10
        currrent_framce.spare = true # if it's a spare, we save the information
    end


    if self.position == 2 # if its the second try
      if self.prev && self.prev.prev && self.prev.prev.score == 10 # if 2 tries are passed, so that we give the nobus
        self.prev.prev.frame.update_spare (self.score + self.prev.score)
      end
      if (self.prev.score + self.score) != 10 # if its not a spare, we simply update the total score of the frame
        currrent_framce.update_spare 0
      end
    elsif self.position == 1  # if it's the first try
      if currrent_framce.prev.try(:spare)  # if the previuos is a spare, we add the nobus to previous score
        currrent_framce.prev.update_spare self.score
      elsif self.prev && self.prev.prev && self.prev.prev.score == 10 #time to update
        self.prev.prev.frame.update_spare (self.score + self.prev.score)
      elsif self.frame.game.frames.count == 10 # if it's the last frame, we simply cumulate the score
        currrent_framce.prev.update_spare 0
      end
    else
      currrent_framce.update_spare 0
    end

    currrent_framce.save

  end


end
