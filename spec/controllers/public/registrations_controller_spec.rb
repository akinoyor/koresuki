# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::RegistrationsController, type: :controller do
  describe '遷移先確認' do
    let(:user){ FactoryBot.build(:user) }
    let!(:user_params){{ name: user.name, email: user.email, password: user.password, password_confirmation: user.password }} 
    it '新規登録後の遷移先' do
      post :create, params: { user: user_params }
      binding.irb
      expect(response).to redirect_to "/posts"
    end
  end
end
# うまくいかなかったので　requestsで作成