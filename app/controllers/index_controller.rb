# frozen_string_literal: true

class IndexController < ApplicationController
  def show; end

  def api_params
    params = {
      apiToken: session[:api_access_token],
      apiOrigin: ENV['API_ORIGIN']
    }
    render json: { api_params: params }, status: 200
  end

  def api_token
    render json: session[:api_access_token], status: 200
  end
end
