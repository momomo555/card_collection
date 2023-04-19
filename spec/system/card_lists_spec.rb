require 'rails_helper'

RSpec.describe "CardLists", type: :system do
  let(:user) { create(:user) }
  let!(:card_list) { create(:card_list, user: user) }

  describe '新規作成画面' do
    it '新規作成できること' do
      login_as user
      visit new_card_list_path
      fill_in 'タイトル', with: 'BT-1'
      fill_in 'カード種類', with: 'テスモンカード'
      click_button '作成'
      expect(page).to have_content 'カードリストを作成しました。'
      expect(page).to have_content 'BT-1'
      expect(page).to have_content 'テスモンカード'
    end

    it '「カードリスト一覧へ戻る」押下でカードリスト一覧画面に遷移すること' do
      login_as user
      visit new_card_list_path
      click_link 'カードリスト一覧へ戻る'
      expect(current_path).to eq card_lists_path
    end
  end

  describe '編集画面' do
    it '更新できること' do
      login_as user
      visit edit_card_list_path(card_list.id)
      fill_in 'タイトル', with: 'BT-2'
      fill_in 'カード種類', with: 'テスカ'
      click_button '編集を完了'
      expect(page).to have_content 'カードリストを更新しました。'
      expect(page).to have_content 'BT-2'
      expect(page).to have_content 'テスカ'
    end
  end

  describe 'ヘッダーのカードリスト関連アクション' do
    it 'メニュー内「カードリスト作成」リンク押下でカードリスト新規作成画面に遷移すること' do
      login_as user
      within 'header' do
        find('#accordion-menu').click
        click_link 'カードリスト作成'
      end
      expect(current_path).to eq new_card_list_path
    end

    it 'メニュー内「カードリスト一覧」リンク押下でカードリスト一覧画面に遷移すること' do
      login_as user
      within 'header' do
        find('#accordion-menu').click
        click_link 'カードリスト一覧'
      end
      expect(current_path).to eq card_lists_path
    end
  end

  describe 'カードリスト一覧画面' do
    it '「新規作成」リンク押下でカードリスト新規作成画面に遷移すること' do
      login_as user
      visit card_lists_path
      click_link '新規作成'
      expect(current_path).to eq new_card_list_path
    end

    it 'カードリストタイトルのリンク押下でカード一覧画面に遷移すること' do
      login_as user
      visit card_lists_path
      click_link card_list.title
      expect(current_path).to eq card_list_cards_path(card_list.id)
    end

    it '「編集」リンク押下でカードリスト編集画面に遷移すること' do
      login_as user
      visit card_lists_path
      click_link '編集'
      expect(current_path).to eq edit_card_list_path(card_list.id)
    end

    it '「削除」ボタン押下でカードリストを削除できること' do
      login_as user
      visit card_lists_path
      click_button '削除'
      expect(page).to have_content 'カードリストを削除しました。'
      expect(page).not_to have_content 'MyString'
    end
  end
end
