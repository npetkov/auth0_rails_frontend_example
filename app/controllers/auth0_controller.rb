# frozen_string_literal: true

class Auth0Controller < ActionController::Base
  layout 'application'
  skip_before_action :verify_authenticity_token, only: :callback

  def sign_in; end

  def sign_out
    cookies.delete(:auth_token)
    cookies.delete('XSRF-TOKEN')
    reset_session
    redirect_to logout_url
  end

  def callback
    data = request.env['omniauth.auth']
    token = data['credentials']['id_token']

    cookies[:auth_token] = {
      value: token,
      same_site: 'Strict',
      httponly: true
    }

    session[:userinfo] = data
    redirect_to root_path
  end

  def failure
    render :failure, layout: false, status: 401
  end

  private

  def logout_url
    domain = Rails.application.credentials.auth_domain
    client_id = Rails.application.credentials.auth_client_id
    request_params = {
      returnTo: root_url,
      client_id: client_id
    }

    URI::HTTPS.build(host: domain, path: '/v2/logout', query: to_query(request_params)).to_s
  end

  def to_query(hash)
    hash.map { |k, v| "#{k}=#{CGI.escape(v)}" unless v.nil? }.reject(&:nil?).join('&')
  end
end
