class CreateFrames < ActiveRecord::Migration
  def change
    create_table :frames do |t|
      t.references :game, index: true, foreign_key: true
      t.integer :total, :default => 0
      t.boolean :strike
      t.boolean :spare

      t.timestamps null: false
    end
  end
end
