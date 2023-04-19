require 'rails_helper'

RSpec.describe CardList, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let!(:card_list) { create(:card_list, user: user) }

    context 'titleが存在する場合' do
      it '登録できること' do
        expect(card_list).to be_valid
      end
    end

    context 'titleが存在しない場合' do
      it '登録できないこと' do
        card_list.title = nil
        expect(card_list).not_to be_valid
      end
    end
  end
end
