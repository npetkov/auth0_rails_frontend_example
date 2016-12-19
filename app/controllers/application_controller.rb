class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate!
  after_action :set_csrf_token
  layout 'application'

  private

  def authenticate!
    token = cookies[:auth_token]

    if token.nil?
      redirect_to auth_sign_in_path
    else
      begin
        @token = verify_auth_token(token)
      rescue JWT::DecodeError
        render 'auth/failure', layout: false, status: 401
      end
    end
  end

  def verify_auth_token(token)
    options = {
      iss: "https://#{ENV['AUTH_DOMAIN']}/",
      verify_iss: true,
      aud: ENV['AUTH_CLIENT_ID'],
      verify_aud: true,
      verify_iat: true,
      algorithm: 'HS256'
    }

    JWT.decode(token, ENV['AUTH_CLIENT_SECRET'], true, options)[0]
  end

  def set_csrf_token
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end
end
