class CreateCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :carts do |t|
      t.string :userId
      t.string :productName
      t.integer :quantity
      t.float :cost

      t.timestamps
    end
  end
end
