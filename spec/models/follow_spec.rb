# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Followモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let!(:follower){ FactoryBot.create(:user)}
    let!(:followed){ FactoryBot.create(:user)}
    let!(:follow){ FactoryBot.create(:follow, follower: follower, followed: followed)}


    it '同じユーザーに重複してフォローできないこと' do
      duplication_follow = Follow.new(follower: follower, followed: followed)
      expect(duplication_follow).not_to be_valid
      expect(duplication_follow.errors[:follower_id][0]).to match("フォローしています")
    end
    it 'ほかのユーザーが同じユーザーをフォローできること' do
      another_follower = FactoryBot.create(:user)
      follow = Follow.new(follower: another_follower, followed: followed)
      expect(follow).to be_valid
    end
    it '同じユーザーがほかのユーザーをフォローできること' do
      another_followed = FactoryBot.create(:user)
      follow = Follow.new(follower: follower, followed: another_followed)
      expect(follow).to be_valid
    end
  end
end