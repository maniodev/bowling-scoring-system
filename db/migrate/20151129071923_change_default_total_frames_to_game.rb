class ChangeDefaultTotalFramesToGame < ActiveRecord::Migration
  def change
    change_column_default(:games, :frames_count, 0)
    add_column :games, :score, :integer, :default => 0
  end
end
