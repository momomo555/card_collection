require 'rails_helper'

RSpec.describe "Cards", type: :system do
  let(:user) { create(:user) }
  let(:card_list) { create(:card_list, user: user) }
  let!(:card) { create(:card, card_list: card_list) }

  before do
    login_as user
  end

  describe '登録画面' do
    before do
      visit new_card_list_card_path(card_list.id)
    end

    it '登録できること' do
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
      click_link 'カード一覧へ戻る'
      expect(current_path).to eq card_list_cards_path(card_list.id)
    end
  end

  describe '編集画面' do
    before do
      visit edit_card_list_card_path(card_list.id, card.id)
    end

    it '更新できること' do
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
      click_link 'カード一覧へ戻る'
      expect(current_path).to eq card_list_cards_path(card_list.id)
    end
  end

  describe 'カード詳細画面' do
    it '「カード一覧へ戻る」リンク押下でカード一覧画面に遷移すること' do
      visit card_list_card_path(card_list.id, card.id)
      click_link 'カード一覧へ戻る'
      expect(current_path).to eq card_list_cards_path(card_list.id)
    end
  end

  describe 'カード一覧画面' do
    before do
      visit card_list_cards_path(card_list.id)
    end

    it '「新規登録」リンク押下でカード登録画面に遷移すること' do
      click_link '新規登録'
      expect(current_path).to eq new_card_list_card_path(card_list.id)
    end

    it 'カード名のリンク押下でカード詳細画面に遷移すること' do
      click_link card.name
      expect(current_path).to eq card_list_card_path(card_list.id, card.id)
    end

    it '「編集」リンク押下でカード編集画面に遷移すること' do
      click_link '編集'
      expect(current_path).to eq edit_card_list_card_path(card_list.id, card.id)
    end

    it '「削除」ボタン押下でカードリストを削除できること' do
      click_button '削除'
      expect(page).to have_content 'カードを削除しました。'
      expect(page).not_to have_content 'monster'
    end

    describe 'ソート機能' do
      let!(:other_card) do
        create(:card, card_list: card_list, name: 'trainer', number: 'ST1-2',
                      rarity: 'R', memo: 'nice', owned: true, favorite: true)
      end

      # 2つ目のカード作成後、画面リロード
      before do
        visit current_path
      end

      it '名前でソートできること' do
        # デフォルトで名前の昇順
        expect(page.text).to match /#{card.name}[\s\S]*#{other_card.name}/
        # 降順ソート
        within '#name-header' do
          click_link '▼'
        end
        expect(page.text).to match /#{other_card.name}[\s\S]*#{card.name}/
        # 昇順ソート
        within '#name-header' do
          click_link '▲'
        end
        expect(page.text).to match /#{card.name}[\s\S]*#{other_card.name}/
      end

      it 'レアリティでソートできること' do
        # 昇順ソート
        within '#rarity-header' do
          click_link '▲'
        end
        expect(page.text).to match /#{card.rarity}[\s\S]*#{other_card.rarity}/
        # 降順ソート
        within '#rarity-header' do
          click_link '▼'
        end
        expect(page.text).to match /#{other_card.name}[\s\S]*#{card.name}/
      end

      it 'カード番号でソートできること' do
        # 昇順ソート
        within '#number-header' do
          click_link '▲'
        end
        expect(page.text).to match /#{card.rarity}[\s\S]*#{other_card.rarity}/
        # 降順ソート
        within '#number-header' do
          click_link '▼'
        end
        expect(page.text).to match /#{other_card.name}[\s\S]*#{card.name}/
      end

      it '所持状態でソートできること' do
        # 昇順ソート
        within '#owned-header' do
          click_link '▲'
        end
        expect(page.text).to match /未所持[\s\S]*所持/
        # 降順ソート
        within '#owned-header' do
          click_link '▼'
        end
        expect(page.text).to match /所持[\s\S]*未所持/
      end

      it 'お気に入りでソートできること' do
        # 昇順ソート
        within '#favorite-header' do
          click_link '▲'
        end
        # favoriteがfalseの場合お気に入り欄の文言表示なしのため、カードの名前を用いて、favoriteがfalseのカードの名前→trueのカードの名前の順であることを確認する
        expect(page.text).to match /#{card.name}[\s\S]*#{other_card.name}/
        # 降順ソート
        within '#favorite-header' do
          click_link '▼'
        end
        # favoriteがfalseの場合お気に入り欄の文言表示なしのため、カードの名前を用いて、favoriteがtrueであるカードの名前→falseであるカードの名前の順であることを確認する
        expect(page.text).to match /#{other_card.name}[\s\S]*#{card.name}/
      end
    end

    describe 'ページネーション機能' do
      it '20件の場合、ページネーションが表示されないこと' do
        create_list(:card, 19, card_list: card_list)
        visit current_path
        expect(page).not_to have_selector '.pagination'
      end

      it '21件の場合、ページネーションが表示されページ遷移できること' do
        create_list(:card, 20, card_list: card_list)
        visit current_path
        expect(page).to have_selector '.pagination'
        click_link '次 ›'
        expect(current_path).to eq card_list_cards_path(card_list.id)
        expect(page).to have_content '‹ 前'
      end
    end
  end
end
