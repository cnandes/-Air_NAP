class AddImageUrlToNapSpace < ActiveRecord::Migration[7.0]
  def change
    add_column :nap_spaces, :image_url, :string
  end
end
