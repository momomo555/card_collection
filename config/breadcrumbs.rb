crumb :root do
  link "Home", root_path
end

crumb :new_user do
  link "新規登録", new_user_registration_path
  parent :root
end

crumb :log_in do
  link "ログイン", new_user_session_path
  parent :root
end

crumb :new_cardlist do
  link "カードリスト新規作成", new_card_list_path
  parent :root
end

crumb :cardlists do
  link "カードリスト一覧", card_lists_path
  parent :root
end

crumb :search_cards do
  link "カード検索", cards_search_path
  parent :root
end

crumb :edit_cardlist do |card_list|
  link "カードリスト編集", edit_card_list_path(card_list.id)
  parent :cardlists
end

crumb :cards do |card_list|
  link "カード一覧", card_list_cards_path(card_list.id)
  parent :cardlists
end

crumb :show_card do |card_list, card|
  link "カード詳細", card_list_card_path(card_list.id, card.id)
  parent :cards, card_list
end

crumb :edit_card do |card_list, card|
  link "カード情報更新", edit_card_list_card_path(card_list.id, card.id)
  parent :show_card, [card_list, card]
end

crumb :new_card do |card_list|
  link "カード登録", new_card_list_card_path(card_list.id)
  parent :cards, card_list
end
