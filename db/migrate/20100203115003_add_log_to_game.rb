class AddLogToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :log, :string, :default => ""
  end

  def self.down
    remove_column :games, :log
  end
end
