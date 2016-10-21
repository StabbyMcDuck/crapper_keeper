class API::V1::ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  private
  def authenticate
    redirect_to(:root, flash: {error: "Please use Facebook or Github to log in!"}) unless current_user
  end

  def current_user
    @current_user ||=
        User.find(session[:user_id]) if session[:user_id]
        #User.find_by(name:"Joe Joey")
  end
  helper_method :current_user
end
