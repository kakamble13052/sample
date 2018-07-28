class AddArchivedToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :archived, :boolean
  end
end
