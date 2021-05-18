# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    Rails.application.credentials.auth_client_id,
    Rails.application.credentials.auth_client_secret,
    Rails.application.credentials.auth_domain,
    callback_path: '/auth/auth0/callback',
    authorize_params: {
      audience: Rails.application.credentials.api_identifier,
      scope: 'openid email profile index:notes create:notes'
    }
  )
end

OmniAuth.config.request_validation_phase = OmniAuth::RailsCsrfProtection::TokenVerifier.new
