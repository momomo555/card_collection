class Card < ApplicationRecord
  has_one_attached :image
  belongs_to :card_list
  validates :name, presence: true
end
