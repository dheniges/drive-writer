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
    # client = Google::APIClient.new(
    #   :application_name => 'Writer',
    #   :application_version => '1.0.0'
    # )

    # client.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
    # client.authorization.client_secret = ENV['GOOGLE_SECRET_KEY']
    # client.authorization.scope = ['https://www.googleapis.com/auth/drive']

    @api_client = GOOGLE_API_CLIENT

    @api_authorization = (
      auth = @api_client.authorization.dup
      #auth.redirect_uri = to('/oauth2callback')
      auth.update_token!(@user.auth)
      auth
    )

    #client.authorization.update_token!(access_token: @user.auth.token) #= @user.auth['token']

    #@api_client = client

    # @api_client = GOOGLE_API_CLIENT.dup
    # binding.pry
    # # Set user specific auth
    # auth = @api_client.authorization.dup
    # auth.access_token = @user.auth['token']
    # @api_client.authorization = auth
    # #@api_client.authorization.dup.update_token!(token = @user.auth['token'])
    @drive = GOOGLE_API_DRIVE
  end

end
