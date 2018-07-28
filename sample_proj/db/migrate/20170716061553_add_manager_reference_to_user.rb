class AddManagerReferenceToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :manager, foreign_key: true
  end
end
