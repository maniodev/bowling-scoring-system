class GamesController < ApplicationController
  def index
  end

  def initialize_game
    @game = Game.create
    session[:game_id] = @game.id
    redirect_to :action => "play"
  end

  def play
    @try = Try.new
  end

  def update
    @try = Try.new(try_params)
    if current_game
      frame = Frame.where(:game_id => current_game.id).last
      if !frame.blank? && !frame.strike && !frame.spare && frame.tries.count !=2 || (current_game.frames.count == 10)
        @try.frame = frame
        @try.position = (frame.tries.last.try(:position) || 0) + 1
      else
        frame = Frame.create(:game_id => current_game.id)
        @try.frame = frame
        @try.position = 1
      end
    end

    respond_to do |format|
      if @try.save
        format.html { redirect_to :action => "play"}
      else
        format.html { render :play }
      end
    end
  end


  private

  def try_params
    params.require(:try).permit(:score)
  end

end
