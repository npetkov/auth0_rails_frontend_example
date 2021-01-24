# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate!
  after_action :set_csrf_token
  layout 'application'

  private

  def authenticate!
    redirect_to '/auth/sign_in' unless session[:userinfo].present?
  end

  def set_csrf_token
    cookies['CSRF-TOKEN'] = {
      value: form_authenticity_token,
      same_site: 'Strict'
    }
  end
end
