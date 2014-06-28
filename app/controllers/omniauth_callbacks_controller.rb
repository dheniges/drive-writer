class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      #flash.notice = "Signed in Through Google!"
      sign_in_and_redirect user, :event => :authentication
    else
      session["devise.user_attributes"] = user.attributes
      
    end
  end

end
