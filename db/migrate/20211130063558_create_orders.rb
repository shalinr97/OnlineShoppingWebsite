class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :orderid
      t.string :userid
      t.string :productName
      t.integer :quantity
      t.float :price

      t.timestamps
    end
  end
end
