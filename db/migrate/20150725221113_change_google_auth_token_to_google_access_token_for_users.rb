class ChangeGoogleAuthTokenToGoogleAccessTokenForUsers < ActiveRecord::Migration
  def up
    add_column :users, :google_access_token, :string
    remove_column :users, :google_auth_token
  end
  def down
    add_column :users, :google_auth_token, :string
    remove_column :users, :google_access_token
  end
end
