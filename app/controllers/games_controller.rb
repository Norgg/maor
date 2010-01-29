class GamesController < ApplicationController
  def index
    @games = Game.find :all, :order => 'created_at desc', :limit => 10
  end

  def show
    @game = Game.find params[:id]
    @player = Player.new
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new params[:game]
    if @game.save
      redirect_to @game
    else
      render :new
    end
  end

  def playcard
    @game = Game.find params[:id]
    @card = Card.find params[:card_id]
    
    deck = @game.deck
    deck.last_card = @card
    deck.last_player = @card.player if @card.player
    deck.save!

    @card.discarded = true
    @card.player = nil
    @card.save!
    render :update do |page|
      page.remove "card_#{@card.id}"
      page.replace_html "discard", render(:partial => 'cards/show')
      page.replace_html "lastplayer", "Played by #{deck.last_player.name}."
    end
  end

  def refresh
    @game = Game.find params[:id]
    deck = @game.deck
    @card = deck.last_card

    render :update do |page|
      page.replace_html "players", render(:partial => 'players/index')
      page.replace_html "discard", render(:partial => 'cards/show')
      page.replace_html "lastplayer", "Played by #{deck.last_player.name}."
    end
  end
end
