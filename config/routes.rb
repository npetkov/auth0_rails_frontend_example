# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'index#show'

  post '/api_params', to: 'index#api_params'

  get  '/auth/sign_in', to: 'auth0#sign_in'
  post '/auth/sign_out', to: 'auth0#sign_out'
  get  '/auth/auth0/callback', to: 'auth0#callback'
  get  '/auth/failure', to: 'auth0#failure'
end
