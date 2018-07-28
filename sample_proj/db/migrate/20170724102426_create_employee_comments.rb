class CreateEmployeeComments < ActiveRecord::Migration[5.1]
  def change
    create_table :employee_comments do |t|
      t.references :user, foreign_key: true
      t.text :comment
      t.references :task, foreign_key: true

      t.timestamps
    end
  end
end
