class IndexController < ApplicationController
  def show
  end

  def api_params
    params = {
      csrf: OpenSSL::HMAC.hexdigest('SHA256', ENV['AUTH_CLIENT_SECRET'], @token.to_s),
      origin: ENV['API_ORIGIN']
    }
    render json: { api_params: params }, status: 200
  end
end
