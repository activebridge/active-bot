# frozen_string_literal: true
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :slacks, only: :check_project do
    collection do
      post 'check_project'
    end
  end

  root to: 'application#default'
end
