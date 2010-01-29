class Card < ActiveRecord::Base
  belongs_to :deck
  belongs_to :player

  def to_s
    rank + suit
  end
end
