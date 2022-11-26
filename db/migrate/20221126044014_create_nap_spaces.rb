class CreateNapSpaces < ActiveRecord::Migration[7.0]
  def change
    create_table :nap_spaces do |t|
      t.references :user, null: false, foreign_key: true
      t.string :description
      t.string :address
      t.float :cost_per_hr

      t.timestamps
    end
  end
end
