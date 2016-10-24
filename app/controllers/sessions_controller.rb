class SessionsController < ApplicationController
  protect_from_forgery except: :create

  def create
    skip_authorization

    auth = request.env['omniauth.auth']
    # Find an identity here
    @identity = Identity.find_with_omniauth(auth)

    if @identity.nil?
      # If no identity was found, create a brand new one here
      @identity = Identity.create_with_omniauth(auth)
    end

    if signed_in?
      if @identity.user == current_user
        # User is signed in so they are trying to link an identity with their
        # account. But we found the identity and the user associated with it
        # is the current user. So the identity is already associated with
        # this user. So let's display an error message.
        redirect_to root_url, notice: "Already linked that account!"
      else
        # The identity is not associated with the current_user so lets
        # associate the identity
        @identity.user = current_user
        @identity.save
        redirect_to root_url, notice: "Successfully linked that account!"
      end
    else
      unless @identity.user.present?
        @identity.user = User.create(name: auth.info.name)
        @identity.save
      end

      self.current_user = @identity.user
      redirect_to root_url, notice: "Signed in!"
    end
  end

  def destroy
    skip_authorization

    self.current_user = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
