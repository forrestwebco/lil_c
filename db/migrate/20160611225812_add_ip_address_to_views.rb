class AddIpAddressToViews < ActiveRecord::Migration[6.0]
  def change
    add_column :views, :ip_address, :string
  end
end
