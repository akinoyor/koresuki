# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::HomesController, type: :controller do
  describe 'GET #top' do
    before do
      get :top
    end
    it 'レスポンスコードが200である' do
      expect(response).to have_http_status(200)
    end
    it 'TOPページが表示される' do
      expect(response).to render_template(:top)
    end
  end
  describe 'rootへのアクセス' do
    it 'rootへのアクセスでTOP画面へ飛ぶ' do
     expect(get: '/').to route_to(controller: 'public/homes', action: 'top')
   end
  end
end
