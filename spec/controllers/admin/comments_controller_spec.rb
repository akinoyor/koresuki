# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::CommentsController, type: :controller do
  describe "Admin Delete #destroy" do
    let!(:admin) { FactoryBot.create(:admin) }
    let!(:user) { FactoryBot.create(:user) }
    let(:post_record) { FactoryBot.create(:post, id: 5) }
    let(:parent_comment) { FactoryBot.create(:comment, id: 10, post_id: post_record.id) }
    let!(:comment) { FactoryBot.create(:comment, user_id: user.id, post_id: post_record.id, parent_comment_id: 0) }

    context "adminログイン時　destroyが成功した時" do
      before do
        sign_in admin
      end
      it "レスポンスコードが302である" do
        delete :destroy, params: { id: comment.id }
        expect(response).to have_http_status(302)
      end
      it "Commentが削除される" do
        delete :destroy, params: { id: comment.id }
        expect(Comment.where(id: comment.id)).not_to exist
      end
      it '"コメントを削除しました"のフラッシュメッセージが出る' do
        delete :destroy, params: { id: comment.id }
        expect(flash[:notice]).to match("コメントを削除しました")
      end
      it "指定のURLにリダイレクトを行う" do
        delete :destroy, params: { id: comment.id }
        expect(response).to redirect_to("/posts/5")
      end
      it "親コメントがあるとき指定のURLにリダイレクトを行う" do
        comment.parent_comment_id = parent_comment.id
        comment.save
        delete :destroy, params: { id: comment.id }
        expect(response).to redirect_to("/posts/5/comments/10")
      end
    end
    context "admin以外のログインの時" do
      before do
        sign_in user
      end
      it "レスポンスコードが302である" do
        delete :destroy, params: { id: comment.id }
        expect(response).to have_http_status(302)
      end
      it "Commentが削除されない" do
        delete :destroy, params: { id: comment.id }
        expect(Comment.where(id: comment.id)).to exist
      end
      it "Admin ログイン画面にリダイレクトを行う" do
        delete :destroy, params: { id: comment.id }
        expect(response).to redirect_to("/admin/sign_in")
      end
    end
    context "ログインしていない時" do
      it "レスポンスコードが302である" do
        delete :destroy, params: { id: comment.id }
        expect(response).to have_http_status(302)
      end
      it "Commentが削除されない" do
        delete :destroy, params: { id: comment.id }
        expect(Comment.where(id: comment.id)).to exist
      end
      it "Admin ログイン画面にリダイレクトを行う" do
        delete :destroy, params: { id: comment.id }
        expect(response).to redirect_to("/admin/sign_in")
      end
    end
  end
end
