class Game < ActiveRecord::Base
  validates_presence_of :name

  has_many :players
  has_one :deck
  
  after_create :create_deck

  def create_deck
    self.deck = Deck.new
  end
end
