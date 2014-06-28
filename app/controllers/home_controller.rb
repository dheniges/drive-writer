class HomeController < ApplicationController

  def index
  end

  def sign_out
    @user.sign_out
    reset_session
    redirect_to root_path
  end

end
