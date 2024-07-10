class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :unit_price, default: 0.0

      t.timestamps
    end
  end
end
