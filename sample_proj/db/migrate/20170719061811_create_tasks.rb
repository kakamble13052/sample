class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.text :desc
      t.datetime :due_date
      t.references :assignee, foreign_key: true
      t.references :assigned_by, foreign_key: true
      t.boolean :is_completed

      t.timestamps
    end
  end
end
