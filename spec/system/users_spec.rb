require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:user) { create(:user) }

  describe 'ログイン画面' do
    it 'ログインできること' do
      login_as user
      expect(page).to have_content 'ログインしました。'
    end
  end

  describe '新規登録画面' do
    it '新規登録できること' do
      visit new_user_registration_path
      fill_in 'Eメール', with: 'user@test.com'
      fill_in 'パスワード', with: 'testpass'
      fill_in 'パスワード（確認用）', with: 'testpass'
      click_button '新規登録'
      expect(page).to have_content 'アカウント登録が完了しました。'
      new_user = User.order(:id).last
      expect(new_user.email).to eq 'user@test.com'
    end
  end

  describe 'ヘッダーのユーザー関連アクション' do
    it '「ログイン」リンク押下でログイン画面に遷移すること' do
      visit top_index_path
      within "header" do
        click_link 'ログイン'
      end
      expect(current_path).to eq new_user_session_path
    end

    it '「ゲストログイン」リンク押下でゲストログインできること' do
      visit top_index_path
      within "header" do
        click_link 'ゲストログイン'
      end
      expect(page).to have_content 'ゲストユーザーとしてログインしました。'
    end

    it '「新規登録」リンク押下で新規登録画面に遷移すること' do
      visit top_index_path
      within "header" do
        click_link '新規登録'
      end
      expect(current_path).to eq new_user_registration_path
    end

    it '「ログアウト」リンク押下でログアウトできること' do
      login_as user
      within "header" do
        click_button 'ログアウト'
      end
      expect(page).to have_content 'ログアウトしました。'
    end
  end

  describe 'トップ画面のユーザー関連アクション' do
    it '「>新規登録してカードリストを作成する」リンクで新規登録画面に遷移すること' do
      visit top_index_path
      within '.top-main' do
        click_link '> 新規登録してカードリストを作成する'
      end
      expect(current_path).to eq new_user_registration_path
    end
  end
end
