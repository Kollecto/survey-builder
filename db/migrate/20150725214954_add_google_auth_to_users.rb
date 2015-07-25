class AddGoogleAuthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_auth_token, :string
    add_column :users, :google_auth_expires_at, :datetime
  end
end
