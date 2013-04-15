class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :description
      t.integer :user_id

      t.timestamps
    end
    add_index :listings, [:user_id, :created_at]
  end
end
