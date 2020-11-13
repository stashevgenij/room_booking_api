module Authenticator
  extend ActiveSupport::Concern

  # Devise methods overwrites
  def current_user
    @current_user ||=
      User.find(request.headers['X-User-ID'])
  end

  def user_signed_in?
    current_user.present?
  end

  def auth_user
    head :unauthorized if request.headers['X-User-ID'].nil? || !User.exists?(request.headers['X-User-ID'])
  end
end