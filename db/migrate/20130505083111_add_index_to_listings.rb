class AddIndexToListings < ActiveRecord::Migration
  def change
    add_index :listings, :title
  end
end
