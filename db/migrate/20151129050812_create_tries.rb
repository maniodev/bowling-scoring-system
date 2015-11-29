class CreateTries < ActiveRecord::Migration
  def change
    create_table :tries do |t|
      t.references :frame, index: true, foreign_key: true
      t.integer :position
      t.integer :score

      t.timestamps null: false
    end
  end
end
