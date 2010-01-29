class Deck < ActiveRecord::Base
  has_many :cards
  belongs_to :game
  belongs_to :last_card, :class_name => 'Card', :foreign_key => 'last_card_id'
  belongs_to :last_player, :class_name => 'Player', :foreign_key => 'last_player_id'

  after_create :generate

  def generate
    ranks = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
    suits = ["♠", "♥", "♦", "♣"]
    ranks.each do |rank|
      suits.each do |suit|
        card = Card.new :rank => rank, 
                        :suit => suit,
                        :in_deck => true, 
                        :discarded => false,
                        :player => nil
        cards << card
      end
    end
    save!
    cards
  end

  def cards_in_deck
    Card.find_all_by_deck_id_and_in_deck self.id, true
  end

  def deal player, num_cards = 1
    dealt_cards = []
    num_cards.times do
      deck_cards = self.cards_in_deck
      card = deck_cards[rand deck_cards.size]
      card.in_deck = false
      card.player = player
      card.save!
      dealt_cards << card
    end
    dealt_cards
  end
end
