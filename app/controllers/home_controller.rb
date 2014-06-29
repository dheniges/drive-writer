class HomeController < ApplicationController

  def index
    if @user
      files = @api_client.request('files.list')
      @files = files.items.map(&:title)
    end
  end

  def sign_out
    @user.sign_out
    reset_session
    redirect_to root_path
  end

end
