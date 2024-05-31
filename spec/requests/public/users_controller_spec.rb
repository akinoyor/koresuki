# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Public::Users コントローラーのテスト', type: :request do
  describe 'GET #show' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:user2){ FactoryBot.create(:user) }
    let!(:post){ FactoryBot.create(:post, user: user) }
    let!(:bookmark){ FactoryBot.create(:bookmark, user_id: user.id, post_id: post.id) }
    let!(:follow){ FactoryBot.create(:follow, follower_id: user.id, followed_id: user2.id) }
    
    before do
      get user_path(user)
    end
    it 'レスポンスコードが200である' do
      expect(response).to have_http_status(:ok)
    end
  end
end