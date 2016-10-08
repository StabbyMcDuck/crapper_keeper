class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  private
  def authenticate
    redirect_to(:root, flash: {error: "Please use Facebook to log in!"}) unless current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] #User.find(1)
  end
  helper_method :current_user
end
