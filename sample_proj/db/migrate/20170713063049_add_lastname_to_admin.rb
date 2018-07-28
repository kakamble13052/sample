class AddLastnameToAdmin < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :lastname, :string
  end
end
