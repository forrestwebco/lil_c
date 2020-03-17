class AddChosenDaysToBorrowToItemRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :item_requests, :chosen_days_to_borrow, :integer
    add_column :item_requests, :body, :text
  end
end
