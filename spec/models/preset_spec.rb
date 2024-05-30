# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Presetモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let!(:preset){ FactoryBot.create(:preset) }
    context 'プリセット名' do
      it '空欄でない' do
        preset.name = nil
        expect(preset).to be_invalid
      end
      it '10文字以内である' do
        preset.name = Faker::Lorem.characters(number:11)
        expect(preset).to be_invalid
        expect(preset.errors[:name][0]).to match("10")
        preset.name = Faker::Lorem.characters(number:10)
        expect(preset).to be_valid
      end
    end
    context '検索ワード' do
      it '20文字以内' do
        preset.words = Faker::Lorem.characters(number:21)
        expect(preset).to be_invalid
        expect(preset.errors[:words][0]).to match("20")
        preset.words =Faker::Lorem.characters(number:20)
        expect(preset).to be_valid
      end
    end
  end
  describe 'アソシエーション' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Preset.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end