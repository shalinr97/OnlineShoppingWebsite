class Admin < ApplicationRecord
  validates :userid, uniqueness: true, presence: true
  validates :password, presence: true
end
