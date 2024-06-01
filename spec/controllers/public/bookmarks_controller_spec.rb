# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::BookmarksController, type: :controller do
  describe 'POST #create' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:post_record){ FactoryBot.create(:post) }
    let!(:referer_url1){"http://test.host/posts"}
    let!(:referer_url2){"http://test.host/"}

      context 'ログイン時・Saveに成功したとき' do
        before do
          sign_in user
          request.env["HTTP_REFERER"] = referer_url1
          post :create, params:{ post_id: post_record.id }
        end
        it 'レスポンスコードが302である' do
          expect(response).to have_http_status(302)
        end
        it 'Bookmarkが作成される' do
          expect(Bookmark.where(user_id: user.id, post_id: post_record.id)).to exist
        end
        it '"ブックマークしました"のフラッシュメッセージが出る' do
          expect(flash[:notice]).to match("ブックマークしました")
        end
        it '直前のURLにリダイレクトを行う' do
          expect(response).to redirect_to(referer_url1)
          request.env["HTTP_REFERER"] = referer_url2
          post :create, params:{ post_id: post_record.id }
          expect(response).not_to redirect_to(referer_url1)
        end
      end

      context 'Saveに失敗した時' do
        before do
          sign_in user
          allow_any_instance_of(Bookmark).to receive(:save).and_return(false)
          request.env["HTTP_REFERER"] = referer_url1
          post :create, params: { post_id: post_record.id }
        end
        it '"ブックマークできませんでした"のフラッシュメッセージが出る' do
          expect(flash[:notice]).to match("ブックマークできませんでした")
        end
        it '直前のURLにリダイレクトを行う' do
          expect(response).to redirect_to(referer_url1)
          request.env["HTTP_REFERER"] = referer_url2
          post :create, params:{ post_id: post_record.id }
          expect(response).not_to redirect_to(referer_url1)
        end
      end
      context 'ログインをしていない時' do
        before do
          post :create, params:{ post_id: post_record.id }
        end
        it 'レスポンスコードが302である' do
          expect(response).to have_http_status(302)
        end
        it 'Bookmarkが作成されない' do
          expect(Bookmark.where(user_id: user.id, post_id: post_record.id)).not_to exist
        end
        it 'ログイン画面に遷移する' do
          expect(response).to redirect_to("http://test.host/users/sign_in")
        end
      end
  end

  describe 'DELETE #destroy' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:post_record){ FactoryBot.create(:post) }
    let!(:bookmark){ FactoryBot.create(:bookmark,user_id: user.id, post_id: post_record.id)}
    let!(:referer_url1){"http://test.host/posts"}
    let!(:referer_url2){"http://test.host/"}

      context 'ログイン時・destroyに成功したとき' do
        before do
          sign_in user
          request.env["HTTP_REFERER"] = referer_url1
          delete :destroy, params:{ post_id: post_record.id }
        end
        it 'レスポンスコードが302である' do
          expect(response).to have_http_status(302)
        end
        it 'Bookmarkが削除される' do
          expect(Bookmark.where(user_id: user.id, post_id: post_record.id)).not_to exist
        end
        it '"ブックマークを解除しました"のフラッシュメッセージが出る' do
          expect(flash[:notice]).to match("ブックマークを解除しました")
        end
        it '直前のURLにリダイレクトを行う' do
          expect(response).to redirect_to(referer_url1)
          request.env["HTTP_REFERER"] = referer_url2
          post :create, params:{ post_id: post_record.id }
          expect(response).not_to redirect_to(referer_url1)
        end
      end

      context 'Saveに失敗した時' do
        before do
          sign_in user
          allow_any_instance_of(Bookmark).to receive(:destroy).and_return(false)
          request.env["HTTP_REFERER"] = referer_url1
          delete :destroy, params: { post_id: post_record.id }
        end
        it '"ブックマークの解除に失敗しました"のフラッシュメッセージが出る' do
          expect(flash[:notice]).to match("ブックマークの解除に失敗しました")
        end
        it '直前のURLにリダイレクトを行う' do
          expect(response).to redirect_to(referer_url1)
          request.env["HTTP_REFERER"] = referer_url2
          post :create, params:{ post_id: post_record.id }
          expect(response).not_to redirect_to(referer_url1)
        end
      end
      context 'ログインをしていない時' do
        before do
          post :create, params:{ post_id: post_record.id }
        end
        it 'レスポンスコードが302である' do
          expect(response).to have_http_status(302)
        end
        it 'Bookmarkが削除されない' do
          expect(Bookmark.where(user_id: user.id, post_id: post_record.id)).to exist
        end
        it 'ログイン画面に遷移する' do
          expect(response).to redirect_to("http://test.host/users/sign_in")
        end
      end
  end
end