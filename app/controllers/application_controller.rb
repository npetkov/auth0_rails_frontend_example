# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate!
  layout 'application'

  private

  def authenticate!
    redirect_to '/auth/sign_in' unless session[:id_token].present?
  end
end
