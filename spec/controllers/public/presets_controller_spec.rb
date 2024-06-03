# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::PresetsController, type: :controller do
  let!(:user){ FactoryBot.create(:user) }
  let!(:preset1){ FactoryBot.create(:preset, user_id: user.id, number: 1) }
  let!(:preset2){ FactoryBot.build(:preset, user_id: user.id, number: 2) }

  describe 'Post #Create' do
    context 'ログインしている時' do
      before do
        sign_in user
        post :create, params:{ user_id: user, preset:{name: preset2.name, words: preset2.words, target: preset2.target, option: preset2.option} }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Presetが作成される' do
        expect(Preset.where( name: preset2.name, words: preset2.words, target: preset2.target, option: preset2.option )).to exist
      end
      it '"プリセットが追加されました"とフラッシュメッセージが出る' do
        expect(flash[:notice]).to match("プリセットが追加されました")
      end
      it '投稿一覧へリダイレクトを行う' do
        expect(response).to redirect_to('/posts')
      end
      it 'Presetが3個より多くは作られない' do
        post :create, params:{ user_id: user, preset:{name: preset2.name, words: preset2.words, target: preset2.target, option: preset2.option} }
        post :create, params:{ user_id: user, preset:{name: preset2.name, words: preset2.words, target: preset2.target, option: preset2.option} }
        post :create, params:{ user_id: user, preset:{name: preset2.name, words: preset2.words, target: preset2.target, option: preset2.option} }
        post :create, params:{ user_id: user, preset:{name: preset2.name, words: preset2.words, target: preset2.target, option: preset2.option} }
        expect(Preset.where(user_id: user).count).to eq 3
      end
      it 'Preset上限の時　"プリセット作成上限は3個です" とフラッシュメッセージが出る' do
        post :create, params:{ user_id: user, preset:{name: preset2.name, words: preset2.words, target: preset2.target, option: preset2.option} }
        post :create, params:{ user_id: user, preset:{name: preset2.name, words: preset2.words, target: preset2.target, option: preset2.option} }
        post :create, params:{ user_id: user, preset:{name: preset2.name, words: preset2.words, target: preset2.target, option: preset2.option} }
        post :create, params:{ user_id: user, preset:{name: preset2.name, words: preset2.words, target: preset2.target, option: preset2.option} }
        expect(flash[:notice]).to match("プリセット作成上限数は3個です")
      end
    end
  end

  describe 'Patch #Update' do
    context 'ログインしている時' do
      before do
        sign_in user
        preset_params = FactoryBot.attributes_for(:preset, name: "test", words: "test words", target: 'all_user', option: 'katu', number: preset1.number )
        patch :update, params:{ id: preset1.id, user_id: user.id, preset: preset_params }
      end
      it 'レスポンスコードが302である' do
        expect(response).to have_http_status(302)
      end
      it 'Presetが更新される' do
        preset1.reload
        expect(preset1.name).to eq('test')
      end
      it '"プリセットが更新されました"とフラッシュメッセージが出る' do
        expect(flash[:notice]).to match("プリセットが更新されました")
      end
      it '投稿一覧へリダイレクトを行う' do
        expect(response).to redirect_to('/posts')
      end

    end
  end
end