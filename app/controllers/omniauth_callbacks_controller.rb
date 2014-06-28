class OmniauthCallbacksController < ApplicationController #Devise::OmniauthCallbacksController

  def google
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)
    session[:auth] = auth
    if user.persisted?
      session[:user_id] = user.id
      user.track
      redirect_to root_path      
    else
      # Error state?
    end
  end

end
