class Game < ActiveRecord::Base
  validates_presence_of :name

  has_many :players
  has_one :deck
  
  after_create :create_deck
  before_save :trim_log

  def create_deck
    self.deck = Deck.new
  end

  def trim_log
    self.log = self.log.split("\n").last(10).join("\n") + "\n"
  end
end
