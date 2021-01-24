# frozen_string_literal: true

class IndexController < ApplicationController
  def show; end

  def api_params
    params = {
      apiToken: create_api_token(),
      apiOrigin: ENV['API_ORIGIN']
    }
    render json: { api_params: params }, status: 200
  end

  def api_token
    render json: create_api_token(), status: 201
  end

  private

  def create_api_token
    oauth_token = session[:userinfo]['credentials']['id_token']
    decoded_token = decode_oauth_token(oauth_token)
    JWT.encode(
      {
        iat: Time.now.to_i,
        exp: [Time.now.to_i + 10.minutes.to_i, decoded_token['exp']].min,
        aud: decoded_token['aud'],
        sub: decoded_token['user_id'],
        scopes: decoded_token['scopes'] || {}
      }, Rails.application.credentials.api_secret, 'HS256'
    )
  end

  def decode_oauth_token(token)
    options = { algorithm: 'HS256' }
    decoded_token = JWT.decode(token, Rails.application.credentials.auth_client_secret, true, options)
    decoded_token[0]
  end
end
