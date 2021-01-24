# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'index#show'

  post '/api_params', to: 'index#api_params'
  post '/api_token', to: 'index#api_token'

  get  '/auth/sign_in', to: 'oauth#sign_in'
  post '/auth/sign_out', to: 'oauth#sign_out'
  get  '/auth/:provider/callback', to: 'oauth#callback'
  get  '/auth/failure', to: 'oauth#failure'
end
