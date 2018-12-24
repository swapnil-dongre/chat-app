Rails.application.routes.draw do
  devise_for :users

  resources :chatrooms do
    get :info
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
