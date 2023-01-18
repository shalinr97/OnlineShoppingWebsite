class Order < ApplicationRecord
  validates :orderid, presence: true
  validates :userid, presence: true
  validates :productName, presence: true
  validates :quantity, numericality: {greater_than_or_equal_to: 0}
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :name, presence: true
  validates :address, presence: true
  validates :creditCardNo, presence: true
end
