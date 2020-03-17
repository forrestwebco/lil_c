class ChangeSharedItemInStockType < ActiveRecord::Migration[5.0]
  def change
    change_column :shared_items, :in_stock, :string
  end
end
