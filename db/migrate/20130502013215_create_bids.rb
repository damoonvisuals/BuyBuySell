class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :amount
      t.references :biddable, polymorphic: true
      t.references :user
      t.timestamps
    end

    add_index :bids, :biddable_type
    add_index :bids, :biddable_id
    add_index :bids, :user_id
  end
end
