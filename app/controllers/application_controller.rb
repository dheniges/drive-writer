class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :setup_user

  # Grabs the current user
  def setup_user
    return unless session[:user_id]
    @user = User.find(session[:user_id]) rescue nil
    if @user
      @user.auth = OmniAuth::AuthHash.new(session[:auth]['credentials'])
      # OmniAuth uses 'token', google-api-client uses 'access_token'
      @user.auth.access_token = @user.auth['token']
      setup_api_client
    end
  end

  private

  # Requires @user and session auth
  def setup_api_client
    @api_client = ApiClient.new(@user.auth, GOOGLE_API_DRIVE)
  end

end
