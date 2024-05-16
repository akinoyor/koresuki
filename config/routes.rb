Rails.application.routes.draw do
  # 管理者の新規登録とパスワードスキップ↓
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    get 'dashboards', to: 'dashboards#index', as: 'dashboards'
    resources :users,   only: [:destroy]
    resources :posts,   only: [:destroy]
    resources :comments,only: [:destroy]
  end



  # ↓ここからユーザー関係↓
  scope module: :public do
    devise_for :users
    devise_scope :user do
    post  '/users/guest_sign_in', to: 'sessions#guest_sign_in', as: 'guest_sign_in'
    end
    root to: 'homes#top'
    resources  :users,only:[:show] do
      resource  :follows, only: [:create, :destroy]
      resources  :presets,  only: [:create, :destroy, :edit, :update]
    end
    get     '/partial_ajax(/:id)',         to: 'posts#partial_ajax'
    get     '/user/bookmarks',        to: 'bookmarks#index',    as: 'bookmarks'
    get     'posts/search',           to: 'posts#search',       as: 'search'
    get     'posts/serch_words',       to: 'posts#search_words', as: 'search_words'
    get     'posts/search_names',      to: 'posts#search_names',  as: 'search_names'
    resources :posts, only:[:index, :show, :create, :edit, :update, :destroy] do
      resources :comments,  only: [:create, :show, :destroy]
      resource  :bookmark,  only: [:create, :destroy]
    end

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
