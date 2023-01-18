class AddCreditcardToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :creditCardNo, :string
  end
end
