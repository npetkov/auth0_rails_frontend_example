Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    ENV['AUTH_CLIENT_ID'],
    ENV['AUTH_CLIENT_SECRET'],
    ENV['AUTH_DOMAIN'],
    callback_path: '/auth/callback'
  )
end
