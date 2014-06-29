class AddRootFolderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :root_folder, :string
  end
end
