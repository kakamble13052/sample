class ChangeAssignedByColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :tasks, :assigned_by_id, :user_id
  end
end
