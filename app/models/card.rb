class Card < ActiveRecord::Base
  belongs_to :deck
  belongs_to :player

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
