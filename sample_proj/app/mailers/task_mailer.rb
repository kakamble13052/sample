class TaskMailer < ApplicationMailer
  default from: "admin@taskcreator.com"

  def task_completed_mail(user, task)
    @user = user
    @task = task
    @user_2 = User.find(@task.assignee_id)
    mail(to: @user.email, subject: 'Task completed')
  end
  def task_deadline_expired_mail(user, task)
    @user = user
    @task = task
    mail(to: @user.email, subject: 'Deadline Expiry Notice')
  end
  def task_deadline_extended_mail(user, task, prev_deadline)
    @user = user
    @task = task
    @prev_deadline = prev_deadline
    mail(to: @user.email, subject: 'Deadline Extended Notice')
  end
  def task_deadline_reduced_mail(user, task, prev_deadline)
    @user = user
    @task = task
    @prev_deadline = prev_deadline
    mail(to: @user.email, subject: 'Deadline Reduced Notice')
  end
  def task_user_commented(task, employee_comment, user_2)
    @task = task
    @user = User.find(@task.user_id)
    @employee_comment = employee_comment
    @user_2 = user_2
    mail(to: @user.email, subject: 'Employee comment on your task')
  end
  def task_assigned_mail(task)
    @task = task
    @user = User.find(@task.assignee_id)
    @user_2 = User.find(@task.user_id)
    mail(to: @user.email, subject: 'Task assigned')
  end
  def task_assignee_changed_mail(user, user_2, task)
    @user = user
    @user_2 = user_2
    @task = task
    mail(to: @user_2.email, subject: 'Task assigned to someone else')
  end
  def task_user_changed_mail(user, user_2, task)
    @user = user
    @user_2 = user_2
    @task = task
    mail(to: @user_2.email, subject: 'Task assigner changed')
  end
  def task_manager_changed_mail(user, manager, task)
    @user = user
    @manager = manager
    @task = task
    mail(to: @user.email, subject: 'Task manager changed')
  end
end
