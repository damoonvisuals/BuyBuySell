class AddTagTextToListings < ActiveRecord::Migration
  def change
    add_column :listings, :tag_text, :string
  end
end
