class Card < ApplicationRecord
  belongs_to :card_list
  validates :name, presence: true
end
