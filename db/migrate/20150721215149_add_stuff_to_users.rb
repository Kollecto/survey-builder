class AddStuffToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :role, :string, :default => 'User'
  end
end
