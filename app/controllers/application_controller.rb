class ApplicationController < ActionController::Base
  protect_from_forgery
# All helpers are available in views but not controllers
  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
