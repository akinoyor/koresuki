# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::FollowsController, type: :controller do
  describe 'POST #create' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:another_user1){ FactoryBot.create(:user) }
    let!(:another_user2){ FactoryBot.create(:user) }
    let!(:referer_url1){"http://test.host/posts"}
    let!(:referer_url2){"http://test.host/"}

      context 'ログイン時フォローしたとき' do
        before do
          sign_in user
          request.env["HTTP_REFERER"] = referer_url1
          post :create, params:{ user_id: another_user1.id }
        end
        it 'レスポンスコードが302である' do
          expect(response).to have_http_status(302)
        end
        it 'Followが作成される' do
          expect(Follow.where(follower_id: user.id, followed_id: another_user1.id )).to exist
        end
        it '"フォローしました"のフラッシュメッセージが出る' do
          expect(flash[:notice]).to match("フォローしました")
        end
        it '直前のURLにリダイレクトを行う' do
          expect(response).to redirect_to(referer_url1)
          request.env["HTTP_REFERER"] = referer_url2
          post :create, params:{ user_id: another_user2.id }
          expect(response).not_to redirect_to(referer_url1)
        end
      end

      context 'ログインをしていない時' do
        before do
          post :create, params:{ user_id: another_user1.id }
        end
        it 'レスポンスコードが302である' do
          expect(response).to have_http_status(302)
        end
        it 'Followが作成されない' do
          expect(Follow.where(follower_id: user.id, followed_id: another_user1.id)).not_to exist
        end
        it 'ログイン画面に遷移する' do
          expect(response).to redirect_to("http://test.host/users/sign_in")
        end
      end
  end

  describe 'DELETE #destroy' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:another_user1){ FactoryBot.create(:user) }
    let!(:another_user2){ FactoryBot.create(:user) }
    let!(:follow){ FactoryBot.create(:follow, follower_id: user.id, followed_id: another_user1.id )}
    let!(:another_follow){ FactoryBot.create(:follow, follower_id: user.id, followed_id: another_user2.id )}
    let!(:referer_url1){"http://test.host/posts"}
    let!(:referer_url2){"http://test.host/"}

      context 'ログイン時・destroyに成功したとき' do
        before do
          sign_in user
          request.env["HTTP_REFERER"] = referer_url1
          delete :destroy, params:{ user_id: another_user1 }
        end
        it 'レスポンスコードが302である' do
          expect(response).to have_http_status(302)
        end
        it 'Followが削除される' do
          expect(Follow.where(followed_id: another_user1.id)).not_to exist
        end
        it '"フォローを外しました"のフラッシュメッセージが出る' do
          expect(flash[:notice]).to match("フォローを外しました")
        end
        it '直前のURLにリダイレクトを行う' do
          expect(response).to redirect_to(referer_url1)
          request.env["HTTP_REFERER"] = referer_url2
          delete :destroy, params:{ user_id: another_user2.id }
          expect(response).not_to redirect_to(referer_url1)
        end
      end

      context 'ログインをしていない時' do
        before do
          delete :destroy, params:{ user_id: another_user1.id }
        end
        it 'レスポンスコードが302である' do
          expect(response).to have_http_status(302)
        end
        it 'Followが削除されない' do
          expect(Follow.where(id: follow.id)).to exist
        end
        it 'ログイン画面に遷移する' do
          expect(response).to redirect_to("http://test.host/users/sign_in")
        end
      end
  end
end