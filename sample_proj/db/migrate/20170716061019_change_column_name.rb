class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :manager, :manager_bool
  end
end
