# frozen_string_literal: true
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :application, only: :default do
    get 'default'
    post 'test_post_button'
  end

  root to: 'application#default'
end
