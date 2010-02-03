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

    if params[:card_id] == 'deck'
      render :update do |page|
      end
    else
      @card = Card.find params[:card_id]

      @game.log += "#{current_player.name} played #@card.\n"
      @game.save!
      
      deck = @game.deck
      deck.discard_counter += 1
      deck.save!

      @card.discarded = deck.discard_counter
      @card.save!
      render :update do |page|
        page.remove "card_#{@card.id}"
        page.replace_html "discard", render(:partial => 'cards/show')
        page.replace_html "lastplayer", "Played by #{@card.player.name}."
        page.replace_html "log", render(:partial => 'games/log')
      end
    end
  end

  def drawcard
    @game = Game.find params[:id]
    @game.log += "#{current_player.name} drew a card.\n"
    @game.save!
    give_card_to current_player
  end

  def givecard
    @game = Game.find params[:id]
    player = Player.find params[:player_id]
    @game.log += "#{current_player.name} gave a card to #{player.name}.\n"
    @game.save!
    give_card_to player
  end

  def refresh
    @game = Game.find params[:id], :include => {:players => :hand}
    deck = @game.deck
    @card = deck.discard_top

    render :update do |page|
      page.replace_html "players", render(:partial => 'players/index')
      page.replace_html "log", render(:partial => 'games/log')

      if @card
        page.replace_html "discard", render(:partial => 'cards/show')
        page.replace_html "lastplayer", "Played by #{@card.player.name}."
      else
        page.replace_html "discard", ''
        page.replace_html "lastplayer", ''
      end
    end
  end

  def chat
    @game = Game.find params[:id]
    msg = "#{current_player.name}: #{params[:game][:message]}\n"
    @game.log += msg
    @game.save!
    render :update do |page|
      page.replace_html "chat", render(:partial => 'games/chat')
    end
  end

  private

  def give_card_to player
    @game = Game.find params[:id]

    if params[:card_id] == 'deck'
      @game.deck.deal player
      render :update do |page|
        page.replace_html "hand", render(:partial => 'players/hand')
      end
    else
      given_card = Card.find params[:card_id]
      given_card.player = player
      given_card.discarded = nil
      given_card.save!

      @card = @game.deck.discard_top

      @game.save!

      render :update do |page|
        page.replace_html "log", render(:partial => 'games/log')
        if @card
          page.replace_html "discard", render(:partial => 'cards/show')
          page.replace_html "lastplayer", "Played by #{@card.player.name}."
        else
          page.replace_html "discard", ''
          page.replace_html "lastplayer", ''
        end
        page.replace_html "hand", render(:partial => 'players/hand')
      end
    end
  end
end
