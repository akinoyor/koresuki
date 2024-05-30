# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bookmarkモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post) }
    let!(:bookmark) { FactoryBot.create(:bookmark, user: user, post: post) }

    it '同じユーザーが同じポストをブックマークできないこと' do
      duplicate_bookmark = Bookmark.new(user: user, post: post)
      expect(duplicate_bookmark).to be_invalid
      expect(duplicate_bookmark.errors[:user_id][0]).to match("ブックマークしています")
    end

    it '異なるユーザーが同じポストをブックマークできること' do
      another_user = FactoryBot.create(:user)
      bookmark = Bookmark.new(user: another_user, post: post)
      expect(bookmark).to be_valid
    end

    it '同じユーザーが異なるポストをブックマークできること' do
      another_post = FactoryBot.create(:post)
      bookmark = Bookmark.new(user: user, post: another_post)
      expect(bookmark).to be_valid
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Bookmark.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Postモデルとの関係'do
      it 'N:1となっている' do
        expect(Bookmark.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
  end
end