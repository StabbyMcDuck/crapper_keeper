class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  private
  def authenticate
    redirect_to(:root, flash: {error: "Please use Facebook or Github to log in!"}) unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.try!(:id)
  end

  def signed_in?
    !!current_user
  end
  helper_method :current_user_signed_in?
end
