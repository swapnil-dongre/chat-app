Rails.application.routes.draw do
  devise_for :users

  get '/chatrooms/search_result', to: 'chatrooms#search_result'
  resources :chatrooms do
    get :info
    post :change_image
    resource :chatroom_users
    resources :messages
  end

  resources :users do
    post :upload_image
  end

  resources :direct_messages
  devise_scope :user do
    root to: "chatrooms#index"
  end
end
