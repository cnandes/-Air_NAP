class AddCoordinatesToNapSpace < ActiveRecord::Migration[7.0]
  def change
    add_column :nap_spaces, :latitude, :float
    add_column :nap_spaces, :longitude, :float
  end
end
