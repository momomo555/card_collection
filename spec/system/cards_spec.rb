require 'rails_helper'

RSpec.describe "Cards", type: :system do
  let(:user) { create(:user) }
  let(:card_list) { create(:card_list, user: user) }
  let!(:card) { create(:card, card_list: card_list) }

  describe '登録画面' do
    it '登録できること' do
      login_as user
      visit new_card_list_card_path(card_list.id)
      fill_in '名前', with: 'テストモン'
      fill_in 'レアリティ', with: 'SR'
      fill_in 'カード番号', with: 'BT1-01'
      fill_in 'メモ欄', with: '欲しい'
      check '所持済'
      check 'お気に入り'
      click_button '登録'
      expect(page).to have_content 'カードを登録しました。'
      expect(page).to have_content 'SR'
      expect(page).to have_content 'BT1-01'
      expect(page).to have_content '所持'
      expect(page).to have_content '☆'
    end

    it '「カード一覧へ戻る」リンク押下でカード一覧画面に遷移すること' do
      login_as user
      visit new_card_list_card_path(card_list.id)
      click_link 'カード一覧へ戻る'
      expect(current_path).to eq card_list_cards_path(card_list.id)
    end
  end

  describe '編集画面' do
    it '更新できること' do
      login_as user
      visit edit_card_list_card_path(card_list.id, card.id)
      fill_in '名前', with: '超テストモン'
      fill_in 'レアリティ', with: 'UR'
      fill_in 'カード番号', with: 'BT2-01'
      fill_in 'メモ欄', with: 'かっこいい'
      check '所持済'
      check 'お気に入り'
      click_button '更新'
      expect(page).to have_content 'カード情報を更新しました。'
      expect(page).to have_content 'UR'
      expect(page).to have_content 'BT2-01'
      expect(page).to have_content '所持'
      expect(page).to have_content '☆'
    end

    it '「カード一覧へ戻る」リンク押下でカード一覧画面に遷移すること' do
      login_as user
      visit edit_card_list_card_path(card_list.id, card.id)
      click_link 'カード一覧へ戻る'
      expect(current_path).to eq card_list_cards_path(card_list.id)
    end
  end

  describe 'カード詳細画面' do
    it '「カード一覧へ戻る」リンク押下でカード一覧画面に遷移すること' do
      login_as user
      visit card_list_card_path(card_list.id, card.id)
      click_link 'カード一覧へ戻る'
      expect(current_path).to eq card_list_cards_path(card_list.id)
    end
  end

  describe 'カード一覧画面' do
    it '「新規登録」リンク押下でカード登録画面に遷移すること' do
      login_as user
      visit card_list_cards_path(card_list.id)
      click_link '新規登録'
      expect(current_path).to eq new_card_list_card_path(card_list.id)
    end

    it 'カード名のリンク押下でカード詳細画面に遷移すること' do
      login_as user
      visit card_list_cards_path(card_list.id)
      click_link card.name
      expect(current_path).to eq card_list_card_path(card_list.id, card.id)
    end

    it '「編集」リンク押下でカード編集画面に遷移すること' do
      login_as user
      visit card_list_cards_path(card_list.id)
      click_link '編集'
      expect(current_path).to eq edit_card_list_card_path(card_list.id, card.id)
    end

    it '「削除」ボタン押下でカードリストを削除できること' do
      login_as user
      visit card_list_cards_path(card_list.id)
      click_button '削除'
      expect(page).to have_content 'カードを削除しました。'
      expect(page).not_to have_content 'monster'
    end
  end
end
