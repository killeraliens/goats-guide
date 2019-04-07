Rails.application.routes.draw do
  # get 'bands/create'
  # get 'bands/destroy'
  # get 'saved_events/create'
  # get 'users/index'
  # get 'users/show'
  devise_for :users
  root to: 'events#index'
  resources :venues, only: [:create]
  resources :events, only: [:index, :show, :new, :create] do
    resources :saved_events, only: [:create, :destroy]
  end
  get 'past_events', to: 'events#index_past'
  resources :users, only: [:index, :show, :edit, :update]
  get 'users/:id/created', to: 'users#created', as: 'user_created'
  resources :url_links, only: [:create, :destroy]
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end

# as a visitor I can view all events
# as a visitor I can see the venue info in the details of events
# as a user I can save an event from the index or show page and view my saved events on my profile when logged in
# as a user I can create a new event

