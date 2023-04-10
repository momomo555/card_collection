require 'rails_helper'

RSpec.describe Card, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:card_list) { create(:card_list, user: user) }
    let!(:card) { create(:card, card_list: card_list) }

    context 'nameが存在する場合' do
      it '登録できること' do
        expect(card).to be_valid
      end
    end

    context 'nameが存在しない場合' do
      it '登録できないこと' do
        card.name = nil
        expect(card).not_to be_valid
      end
    end
  end
end
