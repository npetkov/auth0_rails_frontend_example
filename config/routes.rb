Rails.application.routes.draw do
  root to: 'index#show'

  post '/api_params', to: 'index#api_params'

  get  '/auth/sign_in',  to: 'auth#sign_in'
  post '/auth/sign_out', to: 'auth#sign_out'
  post '/auth/callback', to: 'auth#callback'
  get  '/auth/failure',  to: 'auth#failure'
end
