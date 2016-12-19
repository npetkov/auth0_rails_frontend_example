class AuthController < ActionController::Base
  layout 'auth'

  def sign_in
    @sign_in_state = Digest::SHA1.hexdigest Time.now.to_s
    session[:sign_in_state] = @sign_in_state
  end

  def sign_out
    cookies.delete(:auth_token)
    cookies.delete('XSRF-TOKEN')
    cookies.delete(:_auth0_rails_frontend_example_session)
    redirect_to root_path
  end

  def callback
    data = request.env['omniauth.auth']
    token = data.credentials.id_token

    if params[:state] == session[:sign_in_state]
      cookies[:auth_token] = {
        value: token,
        httponly: true
      }
      redirect_to root_path
    else
      render :failure, layout: false, status: 401
    end
  end

  def failure
    render :failure, layout: false, status: 401
  end
end
