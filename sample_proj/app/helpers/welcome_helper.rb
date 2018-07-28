module WelcomeHelper
  def check_for_user_role(c_user)
    if c_user.role == Role.find_by_name('admin') and !c_user.admin.present?
      c_user.admin = true 
      c_user.manager_bool = false
      c_user.save
      render 'welcome/admin_login'
    elsif c_user.role == Role.find_by_name('manager') and !c_user.manager_bool.present?
      c_user.admin = false
      c_user.manager_bool = true
      c_user.save
      @manager = Manager.new
      @manager.email = c_user.email
      @manager.username = c_user.username
      @manager.firstname = c_user.firstname 
      @manager.lastname = c_user.lastname
      @manager.save
      render 'welcome/manager_login'
    elsif c_user.admin?
      render 'welcome/admin_login'
    elsif c_user.manager_bool?
      render 'welcome/manager_login'
    else
      render 'welcome/login'
    end
  end

  def send_deadline_expired_mail
    t = Time.now
    Task.where("is_completed = ? AND is_incomplete = ?", false, false).each do |task|
      if(t > task.due_date)
        @user = User.find(task.assignee_id)
        task.is_incomplete = true
        if task.save!
          TaskMailer.task_deadline_expired_mail(@user, task).deliver_now
          #'Deadline Expiry mails sent'
        end
      end
    end
  end
end
