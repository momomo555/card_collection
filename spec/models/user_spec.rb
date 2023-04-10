require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    let!(:user) { create(:user) }

    context 'email、passwordとpassword_confirmationが存在する場合' do
      it '登録できること' do
        expect(user).to be_valid
      end
    end

    context 'emailが存在しない場合' do
      it '登録できないこと' do
        user.email = nil
        expect(user).not_to be_valid
      end
    end

    context 'passwordが存在しない場合' do
      it '登録できないこと' do
        user.password = nil
        expect(user).not_to be_valid
      end
    end

    context 'passwordとpassword_confirmationが一致しない場合' do
      it '登録できないこと' do
        user.password_confirmation = 'pass'
        expect(user).not_to be_valid
      end
    end

    context 'passwordが6文字未満の場合' do
      it '登録できないこと' do
        user.password = 'abcde'
        user.password_confirmation = 'abcde'
        expect(user).not_to be_valid
      end
    end
  end
end
