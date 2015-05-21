Rails.application.routes.draw do

  get 'contacts/index'

  root 'user#index'
  # get 'welcome/index'
  # get 'welcome/email'
  post 'emailer/email'

  get 'user/thankyou'

  match "/auth/:provider/callback", to: "sessions#create", via: [:get]
  get 'signout', to: 'sessions#destroy', as: 'signout'
  post 'user/sendemail', to: 'user#sendemail'

  resources :user, only: [:index, :show] do
    resources :contacts, only: [:index] do
    end
  end
end
