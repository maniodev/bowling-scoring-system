class Frame < ActiveRecord::Base
  belongs_to :game, :counter_cache => true
  has_many :tries
  after_save :update_total_score
  # after_create :initialize_total

  def prev
    Frame.where("id < ? and game_id = ?", id, game_id).last
  end

  def update_spare score
    if self.prev
      self.update_attributes(:total => self.prev.total + self.tries.pluck(:score).inject(:+) + score)
    else
      self.update_attributes(:total => self.tries.pluck(:score).inject(:+) + score)
    end
  end

  def update_total score
    # if self.tries.count == 0
    # if self.prev
        self.update_attributes(:total => self.total + score)

  end


  def update_total_score
    game = self.game
    game.score = game.frames.pluck(:total).inject(:+)
    game.save
  end

end
