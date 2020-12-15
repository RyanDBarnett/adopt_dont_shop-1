class AddAddressToApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :applications, :address, :string
    add_column :applications, :state, :string
    add_column :applications, :city, :string
    add_column :applications, :zip, :integer
  end
end
