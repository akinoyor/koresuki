# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::PostsController, type: :controller do
  describe 'POST #create' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:post_record){ FactoryBot.build(:post) }
    context 'ログインしている・投稿が成功した時' do
      before do
        sign_in user
        post :create, params:{ post:{body: post_record.body} }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Postが作成される' do
        expect(Post.where(body: post_record.body)).to exist
      end
      it '"投稿しました"とフラッシュメッセージが出る' do
        expect(flash[:notice]).to match("投稿しました")
      end
      it 'リダイレクト先が投稿一覧である' do
        expect(response).to redirect_to("/posts")
      end
    end
    context 'ログインしている・投稿が失敗した時' do
      before do
        sign_in user
        allow_any_instance_of(Post).to receive(:save).and_return(false)
        post :create, params: {post:{body: post_record.body}}
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Postが作成されない' do
        expect(Post.where(body: post_record.body)).not_to exist
      end
      it '"投稿に失敗しました"とフラッシュメッセージが出る' do
        expect(flash[:notice]).to match("投稿に失敗しました")
      end
      it 'リダイレクト先が投稿一覧である' do
        expect(response).to redirect_to("/posts")
      end
    end
    context 'ログインしていない時' do
      before do
        post :create, params:{ post:{body: post_record.body} }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Postが作成されない' do
        expect(Post.where(body: post_record.body)).not_to exist
      end
      it 'ログイン画面に遷移する' do
        expect(response).to redirect_to("http://test.host/users/sign_in")
      end
    end
  end

  describe 'GET #index' do
  # 検索機能はあとで
  before do
    get :index
  end
    it 'レスポンスコードが200である' do
      expect(response).to have_http_status(200)
    end
    it 'Indexページが表示される' do
      expect(response).to render_template :index
    end
  end
  describe 'GET #index 戻り値チェック' do
    # User
    let!(:user){ FactoryBot.create( :user )}
    let!(:another_user1){FactoryBot.create( :user )}
    let!(:another_user2){FactoryBot.create( :user )}
    # Post
    let!(:post_dog1){ FactoryBot.create( :post, user_id: another_user1.id, body:"dog" )}
    let!(:post_dog2){ FactoryBot.create( :post, user_id: another_user2.id, body:"dog" )}
    let!(:post_cat1){ FactoryBot.create( :post, user_id: another_user1.id, body:"cat" )}
    let!(:post_cat2){ FactoryBot.create( :post, user_id: another_user2.id, body:"cat" )}
    let!(:post_dog_cat1){ FactoryBot.create( :post, user_id: another_user1.id, body:"dogcat" )}
    let!(:post_dog_cat2){ FactoryBot.create( :post, user_id: another_user2.id, body:"catdog" )}
    let!(:post_record1){ FactoryBot.create( :post, user_id: another_user1.id )}
    let!(:post_record2){ FactoryBot.create( :post, user_id: another_user2.id )}
    # Follow
    let!(:follow){ FactoryBot.create( :follow, follower_id: user.id, followed_id: another_user1.id )}
    # Preset
    let!(:preset1){ FactoryBot.create( :preset, user_id: user.id, number: 1, words: "dog cat", option: 'katu' )}
    let!(:preset2){ FactoryBot.create( :preset, user_id: user.id, number: 2, words: "dog cat", option: 'oa' )}
    let!(:another_preset){ FactoryBot.create( :preset, user_id: another_user1.id )}
    before do
      get :index
    end

    it 'Post ALL' do
      expect(assigns :posts).to match_array([ post_dog1, post_dog2, post_cat1, post_cat2, post_dog_cat1, post_dog_cat2, post_record1, post_record2 ])
    end
    it '新規投稿用のデータ' do
      expect(assigns :newpost).to be_a_new(Post)
    end
    it '新規Preset用のデータ' do
      expect(assigns :newpreset).to be_a_new(Preset)
      end
      
    context 'ログインしていない時' do
      it 'Presetのデータ' do
        expect(assigns :presets).not_to exist
      end
    end
    context 'ログインしている時' do
      before do
        sign_in user
        get :index
      end
      it 'Presetのデータ' do
        expect(assigns :presets).to match_array([ preset1, preset2 ])
        expect(assigns :presets).not_to include( another_preset )
      end
    end
  end
end