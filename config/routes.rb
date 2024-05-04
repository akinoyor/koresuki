Rails.application.routes.draw do

  namespace :public do
    get 'bookmarks/index'
  end
  namespace :public do
    get 'comments/new'
    get 'comments/index'
    get 'comments/show'
    get 'comments/edit'
  end
  namespace :public do
    get 'posts/new'
    get 'posts/index'
    get 'posts/show'
    get 'posts/edit'
  end
  namespace :public do
    get 'users/show'
    get 'users/edit'
  end
  scope module: :public do
    devise_for :users
    root to: 'homes#top'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
