class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_user

  # Grabs the current user
  def set_user
    @user = User.find(session[:user_id]) rescue nil
  end
end
