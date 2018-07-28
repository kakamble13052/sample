module TasksHelper
  def self_post(form, a_id, c_user)
    if a_id.present? && a_id.to_i == c_user.id
      form.hidden_field :assignee_id, value: "#{a_id}"
    elsif c_user.admin?
      form.collection_select :assignee_id, User.where(admin: false), :id, :username
    else
      form.collection_select :assignee_id, @manager.users.all, :id, :username
    end
  end

  def admin_post(form, c_user)
    if c_user.admin?
      form.collection_select :user_id, User.where("admin = ? OR manager_bool = ?", true, true), :id, :username
    end
  end


  def check_for_self(assignee_id, id)
    if assignee_id.present? && assignee_id.to_i == id
      return true
    else
      return false
    end
  end

  def task_show_visible(bool, task)
    if bool
      link_to 'Show', task_path(task)
    end
  end

  def task_edit_visible(bool, task)
    if task.archived == false
      if bool
        link_to 'Edit', edit_task_path(task)
      end
    end

  end

  def task_destroy_visible(bool, task)
    link_to 'Destroy', task_path(task),
                 method: :delete, data: { confirm: 'Are you sure?' } if bool and task.archived == false
  end

  def task_archive_visible(bool, task)
    link_to 'Archive', archive_path(task),
               method: :post,
              data: { confirm: 'Are you sure?' } if bool and task.archived == false
  end
  def task_unarchive_visible(bool, task)
    link_to 'Unarchive', unarchive_path(task),
                 method: :post,
                 data: { confirm: 'Are you sure?' } if bool and task.archived == true
  end

  def check_for_user(task, id)
    if task.assignee_id == id
      check_box 'send', 1, {:class => 'send_a_mail',
                            data: { remote: true,
                                    url: send_mail_path,
                                    method: :post,
                                    id: task.id },
                            :checked => (task.is_completed),
                            :disabled => (task.is_completed or task.is_incomplete)}
    else
      if task.is_completed?
        'yes'
      else
        'no'
      end
    end
  end

  def check_for_destroy_all(bool, tasks_ids)
    link_to 'Destroy All', destroy_all_tasks_path(ids: tasks_ids.join(',')),
            method: :post,
            data: { confirm: 'Are you sure?'} if bool
    #binding.pry
  end

  def send_deadline_expired_mail
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

  def check_for_destroy_comment(task, employee_comment)
    if task.user_id == current_user.id
      link_to 'Delete', task_employee_comment_path(task, employee_comment),
                      method: :delete,
                      data: {confirm: 'Are you sure?'}
    end
  end
end
