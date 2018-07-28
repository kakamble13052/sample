class AddFirstnameToAdmin < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :firstname, :string
  end
end
