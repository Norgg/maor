class PlayersController < ApplicationController
  def create
    @player = Player.new params[:player]
    @player.save!
    session[:player_id] = @player.id
    @player.game.deck.deal @player, 5
    redirect_to @player.game
  end

  def leave
    player = current_player
    game = player.game
    player.game_id = nil
    player.save!
    session.delete :player_id
    redirect_to game
  end
end
