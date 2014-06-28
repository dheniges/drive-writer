class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :name
      t.string :email, null: false, default: ""

      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at

      # Auth
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :users, :email,                unique: true
  end
end
