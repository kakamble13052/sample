class CreateManagers < ActiveRecord::Migration[5.1]
  def change
    create_table :managers do |t|
      t.string :email
      t.string :username
      t.string :firstname
      t.string :lastname

      t.timestamps
    end
  end
end
