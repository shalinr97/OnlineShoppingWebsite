class Shopper < ApplicationRecord
  validates :userid, uniqueness: true, presence: true
  validates :name, presence: true
  validates :password, presence: true
  validates :email, presence: true
end
