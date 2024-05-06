Rails.application.routes.draw do

  scope module: :public do
    devise_for :users

    devise_scope :user do
    post  '/users/guest_sign_in', to: 'sessions#guest_sign_in', as: 'guest_sign_in'
    end
    root to: 'homes#top'
    resources  :users,only:[:show] do
      resources :follows, only: [:create, :destroy]
    end

    get     '/user/bookmarks',        to: 'bookmarks#index',    as: 'bookmarks'
    post    '/user/confirm',          to: 'users#confirm',      as: 'confirm'



    resources :posts, only:[:new, :index, :show, :create, :edit, :update, :destroy] do
      resources  :comments,   only: [:new, :create, :show, :edit, :update, :destroy]
      resources  :bookmarks,  only: [:create, :destroy]
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
