# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe 'Admin Delete #destroy' do
    let!(:admin){ FactoryBot.create(:admin) }
    let!(:user){ FactoryBot.create(:user) }
    let!(:another_user){ FactoryBot.create(:user) }

    context 'adminログイン時　destroyが成功した時' do
      before do
        sign_in admin
        delete :destroy, params: { id: another_user.id }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Userが削除される' do
        expect(User.where(id: another_user.id)).not_to exist
      end
      it '"ユーザーを削除しました"のフラッシュメッセージが出る' do
        expect(flash[:notice]).to match("ユーザーを削除しました")
      end
      it '投稿一覧にリダイレクトを行う' do
        expect(response).to redirect_to("/admin/dashboards")
      end
    end
    context 'admin以外のログインの時' do
      before do
        sign_in user
        delete :destroy, params: { id: another_user.id }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Userが削除されない' do
        expect(User.where(id: another_user.id)).to exist
      end
      it 'Admin ログイン画面にリダイレクトを行う' do
        expect(response).to redirect_to("/admin/sign_in")
      end
    end
    context 'ログインしていない時' do
      before do
        delete :destroy, params: { id: another_user.id }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Userが削除されない' do
        expect(User.where(id: another_user.id)).to exist
      end
      it 'Admin ログイン画面にリダイレクトを行う' do
        expect(response).to redirect_to("/admin/sign_in")
      end
    end
  end
end