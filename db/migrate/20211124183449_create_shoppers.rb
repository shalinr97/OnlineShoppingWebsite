class CreateShoppers < ActiveRecord::Migration[6.1]
  def change
    create_table :shoppers do |t|
      t.string :name
      t.string :userid
      t.string :password
      t.string :email

      t.timestamps
    end
  end
end
