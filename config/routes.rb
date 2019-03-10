Rails.application.routes.draw do
  devise_for :users
  root to: 'events#index'
  resources :venues, only: [:index, :show] do
    resources :events, only: [:new, :create]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
