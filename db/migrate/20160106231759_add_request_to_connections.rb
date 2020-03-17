class AddRequestToConnections < ActiveRecord::Migration[6.0]
  def change
    add_column :connections, :invite, :boolean
    add_column :connections, :request, :boolean
  end
end
