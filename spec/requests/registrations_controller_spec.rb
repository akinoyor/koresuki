# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::RegistrationsController, type: :request do
  describe '遷移先確認' do
    context '新規登録画面' do
      it '登録完了時は投稿一覧画面へ' do
        user = FactoryBot.build(:user)
        user_params = { name: user.name, email: user.email, password: user.password, password_confirmation: user.password }
        post user_registration_path, params: { user: user_params }
        expect(response).to redirect_to(posts_path)
      end
      it '登録失敗時はページ遷移無し' do
        user = FactoryBot.create(:user)
        user_params = { name: user.name, email: user.email, password: user.password, password_confirmation: user.password }
        post user_registration_path, params: { user: user_params }
        expect(response).to have_http_status(422)
        expect(response).to render_template('public/registrations/new')
      end
      it 'すでにログインしている時は投稿一覧画面へ' do
        user = FactoryBot.create(:user)
        sign_in user
        get new_user_registration_path
        expect(response).to redirect_to(posts_path)
      end
    end
    context 'ユーザー情報編集画面' do
      let(:user){ FactoryBot.create(:user) }
      let(:guest){ FactoryBot.create(:user, :guest) }
      it 'ゲストユーザーでアクセスした時は投稿一覧画面へ' do
        sign_in guest
        get edit_user_registration_path
        expect(response).to redirect_to(posts_path)
        expect(flash[:alert]).to match("アクセスできません")
      end
      it 'ログインしていない時はログイン画面へ' do
        get edit_user_registration_path
        expect(response).to redirect_to(new_user_session_path)
      end
      it '更新完了時は投稿一覧へ' do
        sign_in user
        user_params = { name: "test", email: user.email, current_password: user.password }
        patch user_registration_path, params: {user: user_params}
        expect(response).to redirect_to(posts_path)
        user.reload
        expect(user.name).to eq "test"
      end
      it '更新失敗時はページ遷移無し' do
        sign_in user
        user_params = { name: user.name, email: user.email, current_password: "aaaaaa" }
        patch user_registration_path, params: {user: user_params}
        # ↓FIX ME↓
        # expect(response).to have_http_status(422)
        expect(response).to render_template('public/registrations/edit')
      end
    end
  end
end