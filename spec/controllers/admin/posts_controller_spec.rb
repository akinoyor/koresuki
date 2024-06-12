# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PostsController, type: :controller do
  describe "Admin Delete #destroy" do
    let!(:admin) { FactoryBot.create(:admin) }
    let!(:user) { FactoryBot.create(:user) }
    let(:post_record) { FactoryBot.create(:post, id: 5) }

    context "adminログイン時　destroyが成功した時" do
      before do
        sign_in admin
        delete :destroy, params: { id: post_record.id }
      end
      it "レスポンスコードが302である" do
        expect(response).to have_http_status(302)
      end
      it "Postが削除される" do
        expect(Post.where(id: post_record.id)).not_to exist
      end
      it '"投稿を削除しました"のフラッシュメッセージが出る' do
        expect(flash[:notice]).to match("投稿を削除しました")
      end
      it "投稿一覧にリダイレクトを行う" do
        expect(response).to redirect_to("/posts")
      end
    end
    context "admin以外のログインの時" do
      before do
        sign_in user
        delete :destroy, params: { id: post_record.id }
      end
      it "レスポンスコードが302である" do
        expect(response).to have_http_status(302)
      end
      it "Postが削除されない" do
        expect(Post.where(id: post_record.id)).to exist
      end
      it "Admin ログイン画面にリダイレクトを行う" do
        expect(response).to redirect_to("/admin/sign_in")
      end
    end
    context "ログインしていない時" do
      before do
        delete :destroy, params: { id: post_record.id }
      end
      it "レスポンスコードが302である" do
        expect(response).to have_http_status(302)
      end
      it "Postが削除されない" do
        expect(Post.where(id: post_record.id)).to exist
      end
      it "Admin ログイン画面にリダイレクトを行う" do
        expect(response).to redirect_to("/admin/sign_in")
      end
    end
  end
end
