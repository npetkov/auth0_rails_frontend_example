# frozen_string_literal: true

class IndexController < ApplicationController
  def show; end

  def api_params
    token = session[:userinfo]['credentials']['id_token']
    params = {
      csrf: OpenSSL::HMAC.hexdigest('SHA256', Rails.application.credentials.auth_client_secret, token.to_s),
      origin: ENV['API_ORIGIN']
    }
    render json: { api_params: params }, status: 200
  end
end
