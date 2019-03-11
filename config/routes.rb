Rails.application.routes.draw do
  get 'saved_events/create'
  get 'users/index'
  get 'users/show'
  devise_for :users
  root to: 'events#index'
  resources :events, only: [:index, :show, :new] do
    resources :saved_events, only: [:create]
  end
  resources :users, only: [:index, :show]
end

# as a visitor I can view all events
# as a visitor I can see the venue info in the details of events
# as a user I can save an event from the index or show page and view my saved events on my profile when logged in
# as a user I can create a new event

