class Player < ActiveRecord::Base
  belongs_to :game
  has_many :cards
  has_many :hand, :class_name => 'Card', :foreign_key => :player_id, :conditions => {:discarded => nil}
end
