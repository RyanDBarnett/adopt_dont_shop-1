class RenameApplicationPetTableToAdoption < ActiveRecord::Migration[5.2]
  def change
    rename_table :application_pets, :adoptions
  end
end
