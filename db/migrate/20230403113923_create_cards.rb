class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.references :card_list, null: false, foreign_key: true
      t.string :name, null: false
      t.string :number
      t.string :rarity
      t.text :memo
      t.boolean :owned
      t.boolean :favorite

      t.timestamps
    end
  end
end
