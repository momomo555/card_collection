require 'rails_helper'

RSpec.describe "CardLists", type: :system do
  let(:user) { create(:user) }
  let!(:card_list) { create(:card_list, user: user) }

  before do
    login_as user
  end

  describe '新規作成画面' do
    before do
      visit new_card_list_path
    end

    it '新規作成できること' do
      fill_in 'タイトル', with: 'BT-1'
      fill_in 'カード種類', with: 'テスモンカード'
      click_button '作成'
      expect(page).to have_content 'カードリストを作成しました。'
      expect(page).to have_content 'BT-1'
      expect(page).to have_content 'テスモンカード'
    end

    it '「カードリスト一覧へ戻る」押下でカードリスト一覧画面に遷移すること' do
      click_link 'カードリスト一覧へ戻る'
      expect(current_path).to eq card_lists_path
    end
  end

  describe '編集画面' do
    it '更新できること' do
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
      within 'header' do
        find('#accordion-menu').click
        click_link 'カードリスト作成'
      end
      expect(current_path).to eq new_card_list_path
    end

    it 'メニュー内「カードリスト一覧」リンク押下でカードリスト一覧画面に遷移すること' do
      within 'header' do
        find('#accordion-menu').click
        click_link 'カードリスト一覧'
      end
      expect(current_path).to eq card_lists_path
    end
  end

  describe 'カードリスト一覧画面' do
    before do
      visit card_lists_path
    end

    it '「新規作成」リンク押下でカードリスト新規作成画面に遷移すること' do
      click_link '新規作成'
      expect(current_path).to eq new_card_list_path
    end

    it 'カードリストタイトルのリンク押下でカード一覧画面に遷移すること' do
      click_link card_list.title
      expect(current_path).to eq card_list_cards_path(card_list.id)
    end

    it '「編集」リンク押下でカードリスト編集画面に遷移すること' do
      click_link '編集'
      expect(current_path).to eq edit_card_list_path(card_list.id)
    end

    it '「削除」ボタン押下でカードリストを削除できること' do
      click_button '削除'
      expect(page).to have_content 'カードリストを削除しました。'
      expect(page).not_to have_content 'ブースター第１弾'
    end

    describe 'ソート機能' do
      let!(:other_card_list) { create(:card_list, user: user, title: 'スターター第１弾', card_type: 'デジモンカード') }

      # 2つ目のカードリスト作成後、画面リロード
      before do
        visit current_path
      end

      it 'タイトルでソートできること' do
        # デフォルトでタイトルの昇順
        expect(page.text).to match /#{other_card_list.title}[\s\S]*#{card_list.title}/
        # 降順ソート
        within '#title-header' do
          click_link '▼'
        end
        expect(page.text).to match /#{card_list.title}[\s\S]*#{other_card_list.title}/
        # 昇順ソート
        within '#title-header' do
          click_link '▲'
        end
        expect(page.text).to match /#{other_card_list.title}[\s\S]*#{card_list.title}/
      end

      it 'カード種類でソートできること' do
        # 昇順ソート
        within '#card-type-header' do
          click_link '▲'
        end
        expect(page.text).to match /#{other_card_list.card_type}[\s\S]*#{card_list.card_type}/
        # 降順ソート
        within '#card-type-header' do
          click_link '▼'
        end
        expect(page.text).to match /#{card_list.card_type}[\s\S]*#{other_card_list.card_type}/
      end
    end

    describe 'ページネーション機能' do
      it '20件の場合、ページネーションが表示されないこと' do
        create_list(:card_list, 19, user: user)
        visit current_path
        expect(page).not_to have_selector '.pagination'
      end

      it '21件の場合、ページネーションが表示されページ遷移できること' do
        create_list(:card_list, 20, user: user)
        visit current_path
        expect(page).to have_selector '.pagination'
        click_link '次 ›'
        expect(current_path).to eq card_lists_path
        expect(page).to have_content '‹ 前'
      end
    end
  end
end
