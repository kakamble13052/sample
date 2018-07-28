namespace :update_ops do
  task update_archived_values: :environment do
    Task.where(archived: nil).each do |task|
      task.archived = false
      task.save
    end
  end
end