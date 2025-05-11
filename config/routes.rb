Rails.application.routes.draw do
  resources :tasks do
    collection do
      get :new_form
    end
    member do
      patch :toggle
    end
  end

  root "tasks#index"
end
