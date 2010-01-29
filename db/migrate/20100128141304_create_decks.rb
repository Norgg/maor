class CreateDecks < ActiveRecord::Migration
  def self.up
    create_table :decks do |t|
      t.references :game
      t.integer :discard_counter

      t.timestamps
    end
  end

  def self.down
    drop_table :decks
  end
end
