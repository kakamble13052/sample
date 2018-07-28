class SendDeadlineExpiryMailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    t = Time.now
    Task.where("is_completed = ? AND is_incomplete = ?", false, false).each do |task|
      if(t > task.due_date)
        @user = User.find(task.assignee_id)
        task.is_incomplete = true
        if task.save!
          TaskMailer.task_deadline_expired_mail(@user, task).deliver_now
          # Deadline Expiry mails sent
        end
      end
    end
  end
end
