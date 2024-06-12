# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, 'モデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { FactoryBot.create(:user) }
    context '名前' do
      it '2文字以上であること' do
        user.name = Faker::Lorem.characters(number: 1)
        expect(user).to be_invalid
        expect(user.errors[:name][0]).to match("2")
        user.name = Faker::Lorem.characters(number: 2)
        expect(user).to be_valid
      end
      it '20文字以内であること' do
        user.name = Faker::Lorem.characters(number: 21)
        expect(user).to be_invalid
        expect(user.errors[:name][0]).to match("20")
        user.name = Faker::Lorem.characters(number: 20)
        expect(user).to be_valid
      end
      it '空欄でない' do
        user.name = nil
        expect(user).to be_invalid
      end
    end
    context 'メールアドレス' do
      it '有効なメールアドレスであること' do
        user.email = Faker::Lorem.characters(number: 10)
        expect(user).to be_invalid
      end
      it '重複していないこと' do
          another_user = FactoryBot.build(:user, email: user.email)
          expect(another_user).to be_invalid
          expect(another_user.errors[:email][0]).to match('すでに存在します')
        end
    end
    context 'パスワード' do
      it '6文字以上であること' do
        user.password = user.password_confirmation = Faker::Lorem.characters(number: 5)
        expect(user).to be_invalid
        expect(user.errors[:password][0]).to match('は6文字以上で入力してください')
        user.password = user.password_confirmation = Faker::Lorem.characters(number: 6)
        expect(user).to be_valid
      end
      it 'パスワードと確認が一致しない場合は無効' do
        user.password_confirmation = Faker::Lorem.characters(number: 8)
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation][0]).to match('とパスワードの入力が一致しません')
      end
    end
    context 'プロフィール' do
      it '50文字以内であること' do
        user.profile = Faker::Lorem.characters(number: 51)
        expect(user).to be_invalid
        expect(user.errors[:profile][0]).to match('50文字')
        user.profile = Faker::Lorem.characters(number: 50)
        expect(user).to be_valid
      end
    end
  end
end
