# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/validations'

RSpec.describe Comment, 'モデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    context '投稿が親コメントの時' do
      let(:post){ FactoryBot.create(:comment)}
      it_behaves_like 'ポスト・コメントのバリデーション'
    end
    context '投稿が子コメントの時' do
      let(:post){ FactoryBot.create(:comment, :with_parent)}
      it_behaves_like 'ポスト・コメントのバリデーション'
    end
  end

  describe 'アソシエーション' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Postモデルとの関係'do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    context '親コメント・子コメントの関係' do
      it '親コメントが複数の子コメントを持つことができるようになっている' do
        expect(Comment.reflect_on_association(:child_comments).macro).to eq :has_many
      end
      it '子コメントに対して親コメントは1つになるようになっている' do
        expect(Comment.reflect_on_association(:parent_comment).macro).to eq :belongs_to
      end
    end

  end
end