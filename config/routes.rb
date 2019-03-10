Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  devise_for :users
  root to: 'events#index'
  resources :events, only: [:index, :show, :new]
  resources :users, only: [:index, :show]
end

# as a visitor I can view all events
# as a visitor I can see the venue info in the details of events
# as a user I can save an event and view the events on my profile when logged in
# as a user I can create an event
# as a user I can add a venue to the details of an event
