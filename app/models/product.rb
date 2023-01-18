class Product < ApplicationRecord
  has_one_attached :image
  validates :name, :description, :image, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :name, uniqueness: true
end
