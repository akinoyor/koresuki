# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::UsersController, type: :controller do
  describe 'GET #show' do
    context '該当するユーザーがいるとき' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        get :show, params: { id: user.id }
      end
      it 'レスポンスコードが200である' do
        expect(response).to have_http_status(:ok)
      end
      it 'Showページが表示される' do
        expect(response).to render_template :show
      end
    end
    context '該当するユーザーがいないとき' do
      before do
        get :show, params: { id: 1 }
      end
      it 'レスポンスコードが404である' do
        expect(response).to have_http_status(404)
      end
    end
  end
  describe 'GET #show　戻り値チェック' do
    # users
    let!(:user) { FactoryBot.create(:user) }
    let!(:another_user1) { FactoryBot.create(:user) }
    let!(:another_user2) { FactoryBot.create(:user) }
    # posts
    let!(:self_post) { FactoryBot.create(:post, user:) }
    let!(:another_post) { FactoryBot.create(:post, user: another_user1) }
    # bookmarks
    let!(:self_bommkmark) { FactoryBot.create(:bookmark, user_id: user.id, post: another_post) }
    let!(:another_bommkmark) { FactoryBot.create(:bookmark, user: another_user1, post: self_post) }
    # follows
    let!(:follow) { FactoryBot.create(:follow, follower: user, followed: another_user1) }
    let!(:followed) { FactoryBot.create(:follow, follower: another_user2, followed: user) }

    before do
      get :show, params: { id: user.id }
    end
    it 'ユーザー投稿一覧' do
      expect(assigns :user_posts).to include self_post
      expect(assigns :user_posts).not_to include another_post
    end
    it 'Bookmark一覧' do
      expect(assigns :bookmark_posts).not_to include self_post
      expect(assigns :bookmark_posts).to include another_post
    end
    it 'フォロー一覧' do
      expect(assigns :followed_users).to include another_user1
      expect(assigns :followed_users).not_to include another_user2
    end
    it '新規投稿用のデータ' do
      expect(assigns :newpost).to be_a_new(Post)
    end
  end
end
