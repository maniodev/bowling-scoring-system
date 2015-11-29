class Try < ActiveRecord::Base
  belongs_to :frame
  after_save :cumulate_score
  validates :score, presence: true
  validates :score, :numericality => true
  validates :score, :inclusion => { :in => 1..10, :message => "The score can only be between 0 and 10" }

  def prev
    Try.joins(:frame).where("frames.game_id = ? and tries.id < ?", self.frame.game_id, self.id).last
  end

  def cumulate_score

    puts "position #{self.position}"
    parent = self.frame
    # check whether strike or spare

    if self.score  == 10 && self.position == 1 && self.frame.game.frames.count != 10
      parent.strike = true
    elsif self.position == 2 && (self.prev.score + self.score) == 10 && self.frame.game.frames.count != 10
        parent.spare = true
    end


    if self.position == 2
      puts "position 2"
      if self.prev && self.prev.prev && self.prev.prev.score == 10
        puts "second score after strike"
        self.prev.prev.frame.update_spare (self.score + self.prev.score)
      end
      if (self.prev.score + self.score) != 10
        puts "its not a spare"
        parent.update_spare 0
      end
    elsif self.position == 1
      if parent.prev.try(:spare)
        parent.prev.update_spare self.score
      elsif self.prev && self.prev.prev && self.prev.prev.score == 10 #time to update
        self.prev.prev.frame.update_spare (self.score + self.prev.score)
      elsif self.frame.game.frames.count == 10
        parent.prev.update_spare 0
      end
      # parent.update_total self.score
      # if self.prev.prev.strike == 10
      #   self.prev.prev.frame.update_total self.prev.score + self.score
      #   parent.update_total self.score
      # end
    else
      parent.update_spare 0
    end


    parent.save

  end




end
