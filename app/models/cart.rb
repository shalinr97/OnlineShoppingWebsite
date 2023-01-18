class Cart < ApplicationRecord
  validates :userId, :productName, presence: true
  validates :quantity, numericality: {greater_than_or_equal_to: 0}
  validates :cost, numericality: {greater_than_or_equal_to: 0.01}
end
