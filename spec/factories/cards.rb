FactoryBot.define do
  factory :card do
    card_list { nil }
    name { "MyString" }
    number { "MyString" }
    rarity { "MyString" }
    memo { "MyText" }
    owned { false }
    favorite { false }
  end
end
