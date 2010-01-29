class Card < ActiveRecord::Base
  belongs_to :deck
  belongs_to :player
  
  before_create :set_discarded

  def set_discarded
    self.discarded = nil
  end

  def to_s
    rank + suit
  end

  def red?
    suit == '♥' or suit == '♦'
  end

  def black?
    not red?
  end
end
