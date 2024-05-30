# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/validations'

RSpec.describe 'Postモデルのテスト', type: :model do
    describe 'バリデーションのテスト' do
        let(:post) { FactoryBot.create(:post)}
        it_behaves_like 'ポスト・コメントのバリデーション'
    end

    describe 'アソシエーションテスト' do
        context 'Userモデルとの関係' do
            it 'N:1となっている' do
                expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
            end
        end
        context 'commentモデルとの関係' do
            it '1:Nとなっている' do
                expect(Post.reflect_on_association(:comments).macro).to eq :has_many
            end
        end
        context 'bookmarkモデルとの関係' do
            it '1:Nとなっている' do
                expect(Post.reflect_on_association(:bookmarks).macro).to eq :has_many
            end
        end
    end

end