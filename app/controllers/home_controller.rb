class HomeController < ApplicationController

  def index
    if @user

      apps = @api_client.execute(api_method: @drive.files.list,
                                 authorization: @api_authorization)


      puts '###### ERROR: ' + apps.data.error['message'] if apps.data && apps.data.try(:error)

      @files = apps.data.items.map(&:title)

    end
  end

  def sign_out
    @user.sign_out
    reset_session
    redirect_to root_path
  end

end
