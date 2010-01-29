class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.string :suit
      t.string :rank
      t.references :deck
      t.references :player
      t.boolean :in_deck
      t.boolean :discarded

      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
