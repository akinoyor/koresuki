# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::BookmarksController, type: :controller do
  describe 'POST #create' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:post_record){ FactoryBot.create(:post) }
      context 'ログイン時・対象のポストがあるとき' do
        before do
          sign_in user
          post :create, params:{ post_id: post_record.id }
        end
        it '正常なレスポンスがあること' do
          # FIXME 302が返るはずが　500が返りエラーになる
          expect(response).to have_http_status(:redirect)
        end
        it 'Bookmarkが作成されるか' do
          expect(Bookmark.where(user_id: user.id, post_id: post_record.id)).to exist
        end
      end
  end
end