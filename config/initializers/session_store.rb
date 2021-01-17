# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_auth0_rails_frontend_example_session'
Rails.application.config.action_dispatch.cookies_same_site_protection = :lax
