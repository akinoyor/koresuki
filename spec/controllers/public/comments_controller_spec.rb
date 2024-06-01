# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::CommentsController, type: :controller do
  describe 'GET #show' do
    # users
    let!(:user){ FactoryBot.create(:user) }
    let!(:another_user){ FactoryBot.create(:user) }
    # posts
    let!(:post_record){ FactoryBot.create(:post, user: user)}
    # comments
    let!(:comment){ FactoryBot.create(:comment) }
    context '該当するCommentがあるとき' do
      before do
        get :show, params:{ post_id: comment.post.id, id: comment.id }
      end
      it 'レスポンスコードが200である' do
        expect(response).to have_http_status(:ok)
      end
      it 'Showページが表示される' do
        expect(response).to render_template :show
      end
    end
    context '該当するCommentがないとき' do
      before do
        get :show, params:{post_id: 10, id: 10 }
      end
      it 'レスポンスコードが404である' do
        expect(response).to have_http_status(404)
      end
    end
    context '戻り値のチェック' do
      before do
        sign_in user
        get :show, params:{ post_id: 10, id: comment.id }
      end
      it '新規Post投稿用のデータ' do
        expect(assigns :newpost).to be_a_new(Post)
      end
      it 'プロフィール用のユーザーデータがCurrentUser' do
        expect(assigns :user).to eq(user)
      end
      it '新規Comment投稿用のデータ' do
        expect(assigns :newcomment).to be_a_new(Comment)
        expect(assigns(:newcomment).parent_comment_id).to eq( comment.id )
      end
      it 'Commentが指定したものが返ってくる' do
        expect(assigns :comment).to match(comment)
      end
    end
  end

  describe 'POST #create' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:another_user){ FactoryBot.create(:user) }
    let!(:post_record){ FactoryBot.create(:post, user_id: user.id) }
    let!(:comment){ FactoryBot.create(:comment, user_id: user.id, post_id: post_record.id) }

    context 'ログイン時・Saveに成功したとき' do
      before do
        sign_in user
        post :create, params:{ post_id: post_record.id }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
    end
  end
end