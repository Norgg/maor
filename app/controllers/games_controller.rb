class GamesController < ApplicationController
  def index
    @games = Game.find :all, :order => 'created_at desc', :limit => 10
  end

  def show
    @game = Game.find params[:id], :include => {:players => :hand}
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
    @game = Game.find params[:id], :include => :deck

    return if params[:card_id] == 'deck'
    @card = Card.find params[:card_id]
    
    deck = @game.deck
    deck.last_player = @card.player if @card.player
    deck.discard_counter += 1
    deck.save!

    @card.discarded = deck.discard_counter
    @card.save!
    render :update do |page|
      page.remove "card_#{@card.id}"
      page.replace_html "discard", render(:partial => 'cards/show')
      page.replace_html "lastplayer", "Played by #{@card.player.name}."
    end
  end

  def drawcard
    @game = Game.find params[:id]

    if params[:card_id] == 'deck'
      @game.deck.deal current_player
      render :update do |page|
        page.replace_html "hand", render(:partial => 'players/hand')
      end
    else
      drawn_card = Card.find params[:card_id]
      drawn_card.player = current_player
      drawn_card.discarded = nil
      drawn_card.save!

      @card = @game.deck.discard_top

      render :update do |page|
        page.replace_html "discard", render(:partial => 'cards/show')
        page.replace_html "hand", render(:partial => 'players/hand')
        page.replace_html "lastplayer", "Played by #{@card.player.name}."
      end
    end
  end

  def refresh
    @game = Game.find params[:id], :include => {:players => :hand}
    deck = @game.deck
    @card = deck.discard_top

    render :update do |page|
      page.replace_html "players", render(:partial => 'players/index')
      page.replace_html "discard", render(:partial => 'cards/show')
      page.replace_html "lastplayer", "Played by #{@card.player.name}."
    end
  end
end
