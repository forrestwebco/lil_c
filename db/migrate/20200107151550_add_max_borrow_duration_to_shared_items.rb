class AddMaxBorrowDurationToSharedItems < ActiveRecord::Migration[6.0]
  def change
    add_column :shared_items, :max_borrow_duration, :string
  end
end
