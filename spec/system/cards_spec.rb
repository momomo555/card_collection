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
      attach_file '画像', "#{Rails.root}/spec/fixtures/files/pikachu.png"
      click_button '登録'
      expect(page).to have_content 'カードを登録しました。'
      expect(page).to have_content 'SR'
      expect(page).to have_content 'BT1-01'
      expect(page).to have_content '所持'
      expect(page).to have_content '☆'
    end

    it 'パンくずリストが表示され、リンク先に遷移できること' do
      within '.breadcrumbs' do
        click_link 'Home'
      end
      expect(current_path).to eq root_path

      visit new_card_list_card_path(card_list.id)
      within '.breadcrumbs' do
        click_link 'カードリスト一覧'
      end
      expect(current_path).to eq card_lists_path

      visit new_card_list_card_path(card_list.id)
      within '.breadcrumbs' do
        click_link 'カード一覧'
      end
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
      attach_file '画像', "#{Rails.root}/spec/fixtures/files/pikachu.png"
      click_button '更新'
      expect(page).to have_content 'カード情報を更新しました。'
      expect(page).to have_content 'UR'
      expect(page).to have_content 'BT2-01'
      expect(page).to have_content '所持'
      expect(page).to have_content '☆'
    end

    it 'パンくずリストが表示され、リンク先に遷移できること' do
      within '.breadcrumbs' do
        click_link 'Home'
      end
      expect(current_path).to eq root_path

      visit edit_card_list_card_path(card_list.id, card.id)
      within '.breadcrumbs' do
        click_link 'カードリスト一覧'
      end
      expect(current_path).to eq card_lists_path

      visit edit_card_list_card_path(card_list.id, card.id)
      within '.breadcrumbs' do
        click_link 'カード一覧'
      end
      expect(current_path).to eq card_list_cards_path(card_list.id)

      visit edit_card_list_card_path(card_list.id, card.id)
      within '.breadcrumbs' do
        click_link 'カード詳細'
      end
      expect(current_path).to eq card_list_card_path(card_list.id, card.id)
    end
  end

  describe 'カード詳細画面' do
    before do
      card.image = fixture_file_upload('pikachu.png')
      card.save
      visit card_list_card_path(card_list.id, card.id)
    end

    it 'カード情報が表示されること' do
      expect(page).to have_content 'monster'
      expect(page).to have_content 'N'
      expect(page).to have_content 'BT1-1'
      expect(page).to have_content 'good'
      expect(page).to have_content '未所持'
      expect(page).not_to have_content '☆'
      # 投稿したファイル名文字列で終わるsrc属性を持つimgタグがあることを確認
      expect(page).to have_selector "img[src$='pikachu.png']"
    end

    it '「編集」リンク押下で編集画面に遷移し、「戻る」リンク押下で戻れること' do
      click_link '編集'
      expect(current_path).to eq edit_card_list_card_path(card_list.id, card.id)
      click_link '戻る'
      expect(current_path).to eq card_list_card_path(card_list.id, card.id)
    end

    it '「削除」ボタン押下でカードリストを削除できること' do
      click_button '削除'
      expect(current_path).to eq card_list_cards_path(card_list.id)
      expect(page).to have_content 'カードを削除しました。'
      expect(page).not_to have_content 'monster'
    end

    it 'パンくずリストが表示され、リンク先に遷移できること' do
      within '.breadcrumbs' do
        click_link 'Home'
      end
      expect(current_path).to eq root_path

      visit card_list_card_path(card_list.id, card.id)
      within '.breadcrumbs' do
        click_link 'カードリスト一覧'
      end
      expect(current_path).to eq card_lists_path

      visit card_list_card_path(card_list.id, card.id)
      within '.breadcrumbs' do
        click_link 'カード一覧'
      end
      expect(current_path).to eq card_list_cards_path(card_list.id)
    end
  end

  describe 'ヘッダーのカード関連アクション' do
    it 'メニュー内「カード検索」リンク押下でカード検索画面に遷移すること' do
      within 'header' do
        find('#accordion-menu').click
        click_link 'カード検索'
      end
      expect(current_path).to eq cards_search_path
    end
  end

  describe 'カード一覧画面' do
    before do
      visit card_list_cards_path(card_list.id)
    end

    it '「新規登録」リンク押下でカード登録画面に遷移し、「戻る」リンク押下で戻れること' do
      click_link '新規登録'
      expect(current_path).to eq new_card_list_card_path(card_list.id)
      click_link '戻る'
      expect(current_path).to eq card_list_cards_path(card_list.id)
    end

    it 'カード名のリンク押下でカード詳細画面に遷移し、「戻る」リンク押下で戻れること' do
      click_link card.name
      expect(current_path).to eq card_list_card_path(card_list.id, card.id)
      click_link '戻る'
      expect(current_path).to eq card_list_cards_path(card_list.id)
    end

    it 'パンくずリストが表示され、リンク先に遷移できること' do
      within '.breadcrumbs' do
        click_link 'Home'
      end
      expect(current_path).to eq root_path

      visit card_list_cards_path(card_list.id)
      within '.breadcrumbs' do
        click_link 'カードリスト一覧'
      end
      expect(current_path).to eq card_lists_path
    end

    describe 'ソート機能' do
      let!(:other_card) do
        create(:card, card_list: card_list, name: 'trainer', number: 'BT1-2',
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
        expect(page.text).to match /#{other_card.rarity}[\s\S]*#{card.rarity}/
      end

      it 'カード番号でソートできること' do
        # 昇順ソート
        within '#number-header' do
          click_link '▲'
        end
        expect(page.text).to match /#{card.number}[\s\S]*#{other_card.number}/
        # 降順ソート
        within '#number-header' do
          click_link '▼'
        end
        expect(page.text).to match /#{other_card.number}[\s\S]*#{card.number}/
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

  describe '検索画面' do
    let(:other_card_list) { create(:card_list, user: user, title: 'スターター第１弾') }
    let!(:other_card) do
      create(:card, card_list: other_card_list, name: 'trainer', number: 'BT1-2',
                    rarity: 'R', memo: 'nice', owned: true, favorite: true)
    end

    before do
      visit cards_search_path
    end

    it 'デフォルトで全てのカードが表示されること' do
      expect(page).to have_content '検索結果：2件'
      expect(page).to have_content 'monster'
      expect(page).to have_content 'ブースター第１弾'
      expect(page).to have_content 'trainer'
      expect(page).to have_content 'スターター第１弾'
    end

    it '検索にヒットしたものだけ表示されること' do
      fill_in 'search-form', with: 'monster'
      click_button '検索'
      expect(page).to have_content '検索結果：1件'
      expect(page).to have_content 'monster'
      expect(page).to have_content 'ブースター第１弾'
      expect(page).not_to have_content 'trainer'
      expect(page).not_to have_content 'スターター第１弾'
    end

    it '部分一致で検索されること' do
      fill_in 'search-form', with: 'onst'
      click_button '検索'
      expect(page).to have_content '検索結果：1件'
      expect(page).to have_content 'monster'
      expect(page).to have_content 'ブースター第１弾'
    end

    it 'パンくずリストが表示され、リンク先に遷移できること' do
      within '.breadcrumbs' do
        click_link 'Home'
      end
      expect(current_path).to eq root_path
    end

    describe 'ソート機能' do
      it 'カードの名前でソートできること' do
        # デフォルトでカードの名前の昇順
        expect(page.text).to match /#{card.name}[\s\S]*#{other_card.name}/
        # 降順ソート
        within '#card-name-header' do
          click_link '▼'
        end
        expect(page.text).to match /#{other_card.name}[\s\S]*#{card.name}/
        # 昇順ソート
        within '#card-name-header' do
          click_link '▲'
        end
        expect(page.text).to match /#{card.name}[\s\S]*#{other_card.name}/
      end

      it 'カードリストのタイトルでソートできること' do
        # 昇順ソート
        within '#card-list-title-header' do
          click_link '▲'
        end
        expect(page.text).to match /#{other_card_list.title}[\s\S]*#{card_list.title}/
        # 降順ソート
        within '#card-list-title-header' do
          click_link '▼'
        end
        expect(page.text).to match /#{card_list.title}[\s\S]*#{other_card_list.title}/
      end
    end

    describe 'ページネーション機能' do
      it '20件の場合、ページネーションが表示されないこと' do
        create_list(:card, 18, card_list: card_list)
        visit current_path
        expect(page).not_to have_selector '.pagination'
      end

      it '21件の場合、ページネーションが表示されページ遷移できること' do
        create_list(:card, 19, card_list: card_list)
        visit current_path
        expect(page).to have_selector '.pagination'
        click_link '次 ›'
        expect(current_path).to eq cards_search_path
        expect(page).to have_content '‹ 前'
      end
    end
  end
end
