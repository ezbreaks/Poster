class AddNameToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :name, :string
  end
end
