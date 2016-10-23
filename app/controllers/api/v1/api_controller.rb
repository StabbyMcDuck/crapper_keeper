class APIController < ActionController::Base
  include Pundit
  protect_from_forgery
  append_view_path(File.join(Rails.root, 'app/views/api/v1'))

  private
  def authenticate
    redirect_to(:root, flash: {error: "Please use Facebook or Github to log in!"}) unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
        #User.find(session[:user_id]) if session[:user_id]
        #User.find_by(name:"Joe Joey")
  end
  helper_method :current_user

  def signed_in?
    !!current_user
  end
  helper_method :current_user_signed_in?

  def current_user = (user)
    @current_user = user
    session[:user_id] - user.nil? ? nil : user.id
  end
end
