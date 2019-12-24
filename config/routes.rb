Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
   namespace :api do
      resources :fini_registrations, param: :uid, only: [:show, :create, :destroy] do
         collection do
            get 'profile/:id',                  to: 'customers#showusing_profile'         
         end
      end
   end
   get 'app/version', to: 'application#version'
end
