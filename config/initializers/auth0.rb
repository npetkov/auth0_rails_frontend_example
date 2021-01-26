# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    Rails.application.credentials.auth_client_id,
    Rails.application.credentials.auth_client_secret,
    Rails.application.credentials.auth_domain,
    callback_path: '/auth/auth0/callback',
    authorize_params: {
      audience: Rails.application.credentials.api_audience,
      scope: 'openid email profile index:notes create:notes'
    }
  )
end

# Commented put as newest omniauth-auth0 version (2.5.0) locks omniauth to an
# older version (1.9)
# OmniAuth.config.request_validation_phase = OmniAuth::RailsCsrfProtection::TokenVerifier.new
