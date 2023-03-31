class CreateCardLists < ActiveRecord::Migration[7.0]
  def change
    create_table :card_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :card_type

      t.timestamps
    end
  end
end
