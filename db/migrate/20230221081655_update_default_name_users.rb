class UpdateDefaultNameUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :name, :string, default: 'Cool Username'
  end
end
