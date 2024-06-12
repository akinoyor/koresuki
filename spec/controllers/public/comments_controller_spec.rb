# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::CommentsController, type: :controller do
  describe 'GET #show' do
    # users
    let!(:user) { FactoryBot.create(:user) }
    let!(:another_user) { FactoryBot.create(:user) }
    # posts
    let!(:post_record) { FactoryBot.create(:post, user_id: user.id) }
    # comments
    let!(:comment) { FactoryBot.create(:comment) }
    context '該当するCommentがあるとき' do
      before do
        get :show, params: { post_id: comment.post.id, id: comment.id }
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
        get :show, params: { post_id: 10, id: 10 }
      end
      it 'レスポンスコードが404である' do
        expect(response).to have_http_status(404)
      end
    end
    context '戻り値のチェック' do
      before do
        sign_in user
        get :show, params: { post_id: 10, id: comment.id }
      end
      it '新規Post投稿用のデータ' do
        expect(assigns :newpost).to be_a_new(Post)
      end
      it 'プロフィール用のユーザーデータがCurrentUser' do
        expect(assigns :user).to eq(user)
      end
      it '新規Comment投稿用のデータ' do
        expect(assigns :newcomment).to be_a_new(Comment)
        expect(assigns(:newcomment).parent_comment_id).to eq(comment.id)
      end
      it 'Commentが指定したものが返ってくる' do
        expect(assigns :comment).to match(comment)
      end
    end
  end

  describe 'POST #create' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:another_user) { FactoryBot.create(:user) }
    let!(:post_record) { FactoryBot.create(:post, id: 10) }
    let!(:comment) { FactoryBot.build(:comment) }
    let!(:parent_comment) { FactoryBot.create(:comment, id: 5) }

    context 'ログイン時・Saveに成功したとき' do
      before do
        sign_in user
        post :create, params: { post_id: post_record.id, comment: { body: comment.body } }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Commentが作成される' do
        expect(Comment.where(user_id: user.id, post_id: post_record.id, body: comment.body)).to exist
      end
      it '"コメントを投稿しました。"のフラッシュメッセージが出る' do
        expect(flash[:notice]).to match("投稿しました")
      end
      it '指定のURLにリダイレクトを行う' do
        expect(response).to redirect_to("/posts/10")
      end
      it '親コメントがあるとき指定のURLにリダイレクトを行う' do
        post :create, params: { post_id: 10, comment: { body: comment.body, parent_comment_id: parent_comment.id } }
        expect(response).to redirect_to("/posts/10/comments/5")
      end
    end

    context 'Saveに失敗した時' do
      before do
        sign_in user
        allow_any_instance_of(Comment).to receive(:save).and_return(false)
      end

      it 'レスポンスコードが200である' do
        expect(response).to have_http_status(200)
      end
      it 'Commentが作成されない' do
        expect(Comment.where(user_id: user.id, post_id: post_record.id, body: comment.body)).not_to exist
      end
      it '"コメントの投稿に失敗しました"のフラッシュメッセージが出る' do
        post :create, params: { post_id: post_record.id, comment: { body: comment.body } }
        expect(flash[:notice]).to match("コメントの投稿に失敗しました")
      end
      it '指定のURLにリダイレクトを行う' do
        post :create, params: { post_id: post_record.id, comment: { body: comment.body } }
        expect(response).to redirect_to("/posts/10")
      end
      it '親コメントがあるときに指定のURLにリダイレクトを行う' do
        post :create, params: { post_id: 10, comment: { body: comment.body, parent_comment_id: 5 } }
        expect(response).to redirect_to("/posts/10/comments/5")
      end
    end
    context 'ログインをしていない時' do
      before do
        post :create, params: { post_id: post_record.id, comment: { body: comment.body } }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Commentが作成されない' do
        expect(Comment.where(user_id: user.id, post_id: post_record.id, body: comment.body)).not_to exist
      end
      it 'ログイン画面に遷移する' do
        expect(response).to redirect_to("http://test.host/users/sign_in")
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:another_user) { FactoryBot.create(:user) }
    let!(:post_record) { FactoryBot.create(:post, id: 10) }
    let!(:comment) { FactoryBot.create(:comment, user_id: user.id, post_id: post_record.id) }
    let!(:parent_comment) { FactoryBot.create(:comment, post_id: post_record.id, id: 5) }

    context 'ログイン時・destroyに成功したとき' do
      before do
        sign_in user
      end
      it 'レスポンスコードが302である' do
        delete :destroy, params: { id: comment.id, post_id: post_record.id }
        expect(response).to have_http_status(302)
      end
      it 'Commentが削除される' do
        delete :destroy, params: { id: comment.id, post_id: post_record.id }
        expect(Comment.where(id: comment.id)).not_to exist
      end
      it '"コメントを削除しました"のフラッシュメッセージが出る' do
        delete :destroy, params: { id: comment.id, post_id: post_record.id }
        expect(flash[:notice]).to match("削除しました")
      end
      it '指定のURLにリダイレクトを行う' do
        delete :destroy, params: { id: comment.id, post_id: post_record.id }
        expect(response).to redirect_to("/posts/10")
      end
      it '親コメントがあるときに指定のURLにリダイレクトを行う' do
        comment.parent_comment_id = parent_comment.id
        comment.save
        delete :destroy, params: { post_id: 10, id: comment.id }
        expect(response).to redirect_to("/posts/10/comments/5")
      end
    end

    context 'destroyに失敗した時' do
      before do
        sign_in user
        allow_any_instance_of(Comment).to receive(:destroy).and_return(false)
        delete :destroy, params: { post_id: post_record.id, id: comment.id }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Commentが削除されない' do
        expect(Comment.where(id: comment.id)).to exist
      end
      it '"コメントの削除に失敗しました"のフラッシュメッセージが出る' do
        expect(flash[:notice]).to match("コメントの削除に失敗しました")
      end
      it '指定のURLにリダイレクトを行う' do
        expect(response).to redirect_to("/posts/10")
      end
      it '親コメントがあるとき指定のURLにリダイレクトを行う' do
        comment.parent_comment_id = parent_comment.id
        comment.save
        delete :destroy, params: { post_id: 10, id: comment.id, parent_comment_id: 5 }
        expect(response).to redirect_to("/posts/10/comments/5")
      end
    end
    context 'ログインをしていない時' do
      before do
        delete :destroy, params: { post_id: post_record.id, id: comment.id }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Commentが削除されない' do
        expect(Comment.where(id: comment.id)).to exist
      end
      it 'ログイン画面に遷移する' do
        expect(response).to redirect_to("http://test.host/users/sign_in")
      end
    end
  end
end
