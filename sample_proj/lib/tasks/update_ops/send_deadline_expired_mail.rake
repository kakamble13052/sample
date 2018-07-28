namespace :update_ops do
  task send_deadline_expired_mail: :environment do
    t = Time.now
    Task.where("is_completed = ? AND is_incomplete = ?", false, false).each do |task|
      if(t > task.due_date)
        @user = User.find(task.assignee_id)
        task.is_completed = false
        task.is_incomplete = true
        if task.save!
          TaskMailer.task_deadline_expired_mail(@user, task).deliver_now
        end
      end
    end
  end
end