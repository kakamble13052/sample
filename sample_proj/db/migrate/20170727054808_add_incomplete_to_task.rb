class AddIncompleteToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :is_incomplete, :boolean
  end
end
