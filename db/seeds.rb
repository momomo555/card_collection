# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
user = User.guest

25.times do |num|
  card_list = CardList.find_or_create_by(title: "BT-#{format("%03d", num + 1)}") do |card_list|
    card_list.card_type = 'ポケモンカード'
    card_list.user_id = user.id
  end
  if card_list.cards.blank?
    Card.create(
      name: 'ピチュー',
      number: 1,
      rarity: 'コモン',
      memo: 'かわいい',
      owned: true,
      favorite: true,
      card_list_id: card_list.id      
    )
    Card.create(
      name: 'ピカチュウ',
      number: 2,
      rarity: 'アンコモン',
      memo: 'たくさん持ってる',
      owned: true,
      favorite: false,
      card_list_id: card_list.id      
    )
    Card.create(
      name: 'ライチュウ',
      number: 3,
      rarity: 'レア',
      memo: 'いつか欲しい',
      owned: false,
      favorite: true,
      card_list_id: card_list.id      
    )
  end
end
