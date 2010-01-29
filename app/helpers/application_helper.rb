# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_player
    session[:player_id] and Player.find(session[:player_id])
  end
end
