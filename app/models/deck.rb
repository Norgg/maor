class Deck < ActiveRecord::Base
  has_many :cards
  belongs_to :game

  after_create :generate

  def generate
    self.discard_counter = 1
    ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
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

  def discard_top
    Card.find_last_by_deck_id self.id, :order => :discarded, :conditions => ['discarded >= 0']
  end

  def discards
    Card.find_all_by_deck_id self.id, :order => :discarded, :conditions => ['discarded >= 0']
  end

  def deal player, num_cards = 1
    dealt_cards = []
    num_cards.times do
      deck_cards = self.cards_in_deck
      
      if deck_cards.empty?
        top = discard_top
        discards.each do |card|
          next if card == top
          card.in_deck = true
          card.player = nil
          card.discarded = nil
          card.save!
        end
        deck_cards = self.cards_in_deck
      end

      card = deck_cards[rand deck_cards.size]
      card.in_deck = false
      card.player = player
      card.save!
      dealt_cards << card
    end
    dealt_cards
  end
end
