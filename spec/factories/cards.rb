FactoryBot.define do
  factory :card do
    card_list { nil }
    name { "monster" }
    number { "BT1-1" }
    rarity { "N" }
    memo { "good" }
    owned { false }
    favorite { false }
  end
end
