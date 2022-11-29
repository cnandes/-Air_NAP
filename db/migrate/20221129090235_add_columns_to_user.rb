class AddColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, default: 'Mr Coolguy'
    add_column :users, :contact_number, :string
    add_column :users, :about_me, :text
    add_column :users, :avatar_url, :string
  end
end
