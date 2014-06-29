class HomeController < ApplicationController

  def index
    if @user
      @projects = @user.projects
      # files = @api_client.request('files.list')
      # @files = files.items.map(&:title)
    end
  end

  def setup
    if @user.root_folder.present?
      @user.setup_projects(@api_client)
      redirect_to root_path and return
    end
    # Default to showing root folder creation screen
  end

  def setup_submit
    file = @api_client.create(params[:user][:root_folder], 'folder')
    @user.root_folder = file.id
    @user.save
    redirect_to setup_path
  end

  def sign_out
    @user.sign_out
    reset_session
    redirect_to root_path
  end

end
