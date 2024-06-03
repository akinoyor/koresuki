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
    let!(:preset1){ FactoryBot.create( :preset, id: 3, user_id: user.id, number: 1, words: "dog cat", option: 'katu' )}
    let!(:preset2){ FactoryBot.create( :preset, id: 4, user_id: user.id, number: 2, words: "dog cat", option: 'oa' )}
    let!(:another_preset){ FactoryBot.create( :preset, user_id: another_user1.id )}
    before do
      get :index
    end

    it 'Post ALLのデータ' do
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
      it 'タイムラインの結果が任意のものが返ってくる' do
        expect(assigns :results3).to match_array([ post_dog_cat1, post_dog_cat2 ])
        expect(assigns :results3).not_to include( post_dog1, post_dog2, post_cat1, post_cat2, post_record1, post_record2 )
        expect(assigns :results4).to match_array([ post_dog1, post_dog2, post_cat1, post_cat2, post_dog_cat1, post_dog_cat2 ])
        expect(assigns :results4).not_to include( post_record1, post_record2 )
        preset1.target = "following_user"
        preset1.save
        preset2.target = "following_user"
        preset2.save
        get :index
        expect(assigns :results3).to match_array([ post_dog_cat1 ])
        expect(assigns :results3).not_to include( post_dog1, post_dog2, post_cat1, post_cat2, post_record1, post_record2, post_dog_cat2 )
        expect(assigns :results4).to match_array([ post_dog1, post_cat1, post_dog_cat1 ])
        expect(assigns :results4).not_to include( post_dog2, post_cat2, post_dog_cat2, post_record1, post_record2 )
      end
    end
  end

  describe 'GET #partial_ajax' do
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
    let!(:preset1){ FactoryBot.create( :preset, id: 3, user_id: user.id, number: 1, words: "dog cat", option: 'katu' )}
    let!(:preset2){ FactoryBot.create( :preset, id: 4, user_id: user.id, number: 2, words: "dog cat", option: 'oa' )}
    let!(:another_preset){ FactoryBot.create( :preset, user_id: another_user1.id )}
    before do
      sign_in user
    end
     it 'レスポンスコードが200である' do
      get :partial_ajax, params:{ id: preset1.id }
      expect(response).to have_http_status(200)
    end
    it 'Partial_ajaxページが表示される また　ヘッダーが内部に表示されない' do
      get :partial_ajax, params:{ id: preset1.id }
      expect(response).to render_template :partial_ajax
    end
    it 'タイムラインの結果が任意のものが返ってくる' do
        get :partial_ajax, params:{ id: preset1.id }
        expect(assigns :posts).to match_array([ post_dog_cat1, post_dog_cat2 ])
        expect(assigns :posts).not_to include( post_dog1, post_dog2, post_cat1, post_cat2, post_record1, post_record2 )
        get :partial_ajax, params:{ id: preset2.id }
        expect(assigns :posts).to match_array([ post_dog1, post_dog2, post_cat1, post_cat2, post_dog_cat1, post_dog_cat2 ])
        expect(assigns :posts).not_to include( post_record1, post_record2 )
        preset1.target = "following_user"
        preset1.save
        preset2.target = "following_user"
        preset2.save
        get :partial_ajax, params:{ id: preset1.id }
        expect(assigns :posts).to match_array([ post_dog_cat1 ])
        expect(assigns :posts).not_to include( post_dog1, post_dog2, post_cat1, post_cat2, post_record1, post_record2, post_dog_cat2 )
        get :partial_ajax, params:{ id: preset2.id }
        expect(assigns :posts).to match_array([ post_dog1, post_cat1, post_dog_cat1 ])
        expect(assigns :posts).not_to include( post_dog2, post_cat2, post_dog_cat2, post_record1, post_record2 )
      end
  end

  describe 'GET #Show' do
    let!(:post_record){ FactoryBot.create(:post) }
    before do
      get :show, params:{ id: post_record.id }
    end
    it 'レスポンスコードが200である' do
      expect(response).to have_http_status(200)
    end
    it 'Showページが表示される' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #Edit' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:another_user){ FactoryBot.create(:user) }
    let!(:post_record){ FactoryBot.create(:post, user_id: user.id) }

    context 'ログインしており、自身の投稿にアクセスする時' do
      before do
        sign_in user
        get :edit, params:{ id: post_record.id }
      end
      it 'レスポンスコードが200である' do
        expect(response).to have_http_status(200)
      end
      it 'Editページが表示される' do
        expect(response).to render_template :edit
      end
    end
    context 'ログインしているが、ほかのユーザーの投稿にアクセスする時' do
      before do
        sign_in another_user
        get :edit, params:{ id: post_record.id }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it '投稿一覧ページが表示される' do
        expect(response).to redirect_to("/posts")
      end
      it '”投稿者のみ編集可能です”とフラッシュメッセージが出る' do
        expect(flash[:alert]).to match("投稿者のみ編集可能です")
      end
    end
    context 'ログインしていない時' do
      before do
        get :edit, params:{ id: post_record.id }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'ログイン画面が表示される' do
        expect(response).to redirect_to("/users/sign_in")
      end
      it '”ログインもしくはアカウント登録してください"とフラッシュメッセージが出る' do
        expect(flash[:alert]).to match("ログインもしくはアカウント登録してください")
      end
    end
  end

  describe 'Patch #Update' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:another_user){ FactoryBot.create(:user) }
    let!(:post_record){ FactoryBot.create(:post, user_id: user.id) }

    context 'ログインしており更新されたとき' do
      before do
        sign_in user
        post_record_params = FactoryBot.attributes_for(:post, body: "test")
        patch :update, params:{ id: post_record.id, post: post_record_params }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'データが更新される' do
        post_record.reload
        expect(post_record.body).to eq('test')
      end
    end
    context 'ログインしていたが更新できなかったとき' do
      before do
        sign_in user
        allow_any_instance_of(Post).to receive(:update).and_return(false)
        post_record_params = FactoryBot.attributes_for(:post, body: "test")
        patch :update, params:{ id: post_record.id, post: post_record_params }
      end
       it 'レスポンスコードが200である' do
        expect(response).to have_http_status(200)
      end
      it 'データが更新されない' do
        post_record.reload
        expect(post_record.body).not_to eq('test')
      end
      it 'Editが表示される' do
        expect(response).to render_template :edit
      end
      it '”投稿の更新ができませんでした”とフラッシュメッセージが出る' do
        expect(flash[:notice]).to match("投稿の更新ができませんでした")
      end
    end
    context 'ログインしているがほかのユーザーの時' do
      before do
        sign_in another_user
        post_record_params = FactoryBot.attributes_for(:post, body: "test")
        patch :update, params:{ id: post_record.id, post: post_record_params }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'データが更新されない' do
        post_record.reload
        expect(post_record.body).not_to eq('test')
      end
      it '投稿一覧ページが表示される' do
        expect(response).to redirect_to("/posts")
      end
      it '”投稿者のみ編集可能です”とフラッシュメッセージが出る' do
        expect(flash[:alert]).to match("投稿者のみ編集可能です")
      end

    end
    context 'ログインしていない時' do
      before do
        post_record_params = FactoryBot.attributes_for(:post, body: "test")
        patch :update, params:{ id: post_record.id, post: post_record_params }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'ログイン画面が表示される' do
        expect(response).to redirect_to("/users/sign_in")
      end
      it '”ログインもしくはアカウント登録してください"とフラッシュメッセージが出る' do
        expect(flash[:alert]).to match("ログインもしくはアカウント登録してください")
      end
    end

  end

  describe 'DELETE #destroy' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:another_user){ FactoryBot.create(:user) }
    let!(:post_record){FactoryBot.create(:post, id: 10, user_id: user.id)}

    context 'ログイン時・destroyに成功したとき' do
      before do
        sign_in user
        delete :destroy, params: { id: 10 }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Postが削除される' do
        expect(Post.where(id: post_record.id)).not_to exist
      end
      it '"投稿を削除しました"のフラッシュメッセージが出る' do
        expect(flash[:notice]).to match("削除しました")
      end
      it '投稿一覧にリダイレクトを行う' do
        expect(response).to redirect_to("/posts")
      end
    end
    context 'ログインしているがほかのユーザーの時' do
      before do
        sign_in another_user
        delete :destroy, params:{ id: post_record.id }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it '投稿が削除されない' do
        expect(Post.where(id: post_record)).to exist
      end
      it '投稿一覧ページが表示される' do
        expect(response).to redirect_to("/posts")
      end
      it '”投稿者のみ編集可能です”とフラッシュメッセージが出る' do
        expect(flash[:alert]).to match("投稿者のみ編集可能です")
      end
    end
    context 'ログインをしていない時' do
      before do
        delete :destroy, params:{ id: post_record.id }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it '投稿が削除されない' do
        expect(Post.where(id: post_record.id)).to exist
      end
      it 'ログイン画面に遷移する' do
        expect(response).to redirect_to("http://test.host/users/sign_in")
      end
    end
  end

  describe 'GET #Search' do
    let!(:user){ FactoryBot.create(:user)}
    let!(:post_record1){ FactoryBot.create(:post) }
    let!(:post_record2){ FactoryBot.create(:post) }
    let!(:post_record3){ FactoryBot.create(:post) }

    before do
      sign_in user
      get :search
    end
    it 'レスポンスコードが200である' do
      expect(response).to have_http_status(200)
    end
    it 'Searchが表示される' do
      expect(response).to render_template :search
    end
    it '新規投稿用のデータ' do
      expect(assigns :newpost).to be_a_new(Post)
    end
    it '検索結果一覧初期値のデータ' do
      expect(assigns :posts_results).to match_array([post_record1, post_record2, post_record3 ])
    end
  end

  describe 'GET #search_words' do
    before do
      get :search_words,params:{keywords: '', type: 'AND' }
    end
    it 'レスポンスコードが200である' do
      expect(response).to have_http_status(200)
    end
    it 'Searchが表示される' do
      expect(response).to render_template :search
    end
  end

  describe 'GET #search_words 戻り値チェック' do
    # User
    let!(:user_tanaka){ FactoryBot.create( :user, name: "田中" )}
    let!(:user_hanada){ FactoryBot.create( :user, name: "花田" )}
    let!(:user_nakamura){ FactoryBot.create( :user, name: "中村" )}
    let!(:another_user){ FactoryBot.create( :user )}
    # Post
    let!(:post_dog){ FactoryBot.create( :post, body:"dog" )}
    let!(:post_cat){ FactoryBot.create( :post, body:"cat" )}
    let!(:post_dog_cat){ FactoryBot.create( :post, body:"dogcat" )}
    let!(:post_record){ FactoryBot.create( :post )}

    it '新規投稿用のデータ' do
      get :search_words,params:{ keywords: '', type: 'AND' }
      expect(assigns :newpost).to be_a_new(Post)
    end

    context '検索ワードが空欄の時' do
      before do
        get :search_words,params:{ keywords: '', type: 'AND' }
      end
      it 'Postは全てが表示される' do
        expect(assigns :posts_results).to match_array([post_dog, post_cat, post_dog_cat, post_record])
      end
      it 'Userは誰も表示されない' do
        expect(assigns :users_results).not_to include(user_tanaka, user_hanada, user_nakamura, another_user)
      end
    end

    context '検索ワードが一致するときの時' do
      it 'Post typeがANDならば　AND検索' do
        get :search_words,params:{ keywords: 'cat dog', type: 'AND' }
        expect(assigns :posts_results).to match_array([post_dog_cat])
        expect(assigns :posts_results).not_to include(post_dog, post_cat, post_record)
      end
      it 'Post typeがORならば　OR検索' do
        get :search_words,params:{ keywords: 'cat dog', type: 'OR' }
        expect(assigns :posts_results).to match_array([post_dog, post_cat, post_dog_cat])
        expect(assigns :posts_results).not_to include(post_record)
      end
      it 'UserはAND検索' do
        get :search_words,params:{ keywords: '田　中', type: 'OR' }
        expect(assigns :users_results).to match_array([user_tanaka])
        expect(assigns :users_results).not_to include(user_hanada, user_nakamura, another_user)
      end
    end

    context '一致する結果がない時' do
      before do
        get :search_words,params:{ keywords: 'aaaaaaa', type: 'AND' }
      end
      it 'Post none' do
        expect(assigns :posts_results).to eq []
        expect(assigns :posts_results).not_to include(post_dog, post_cat, post_dog_cat, post_record)
      end
      it 'User none' do
        expect(assigns :users_results).to eq []
        expect(assigns :users_results).not_to include(user_hanada, user_nakamura, user_tanaka, another_user)
      end
    end

  end
end