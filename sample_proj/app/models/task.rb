class Task < ApplicationRecord
  belongs_to :user, :foreign_key => 'assignee_id'
  belongs_to :user, :foreign_key => 'user_id'
  has_many :employee_comments, dependent: :destroy
  def self.total_on_month(month)
    where("strftime('%m', created_at) = ?", month).count()
  end

  def self.total_completed_user_tasks(u_id, month)
    where("assignee_id = ? AND strftime('%m', created_at) = ? AND is_completed = ? AND is_incomplete = ?", u_id, month, true, false).count()
  end

  def self.total_incomplete_user_tasks(u_id, month)
    where("assignee_id = ? AND strftime('%m', created_at) = ? AND is_completed = ? AND is_incomplete = ?", u_id, month, false, true).count()
  end

  def self.total_ongoing_user_tasks(u_id, month)
    where("assignee_id = ? AND strftime('%m', created_at) = ? AND is_completed = ? AND is_incomplete = ?", u_id, month, false, false).count()
  end

  def self.total_assigned_user_tasks(u_id, month)
    where("assignee_id = ? AND strftime('%m', created_at) = ?", u_id, month).count()
  end

  def self.total_completed_tasks(date)
    where("date(due_date) = ? AND is_completed = ? AND is_incomplete = ?", date, true, false).group("strftime('%m', created_at)").count()
  end

  def self.total_incomplete_tasks(date)
    where("date(due_date) = ? AND is_completed = ? AND is_incomplete = ?", date, false, true).group("strftime('%m', created_at)").count()
  end

  def self.total_assigned_by_manager(manager, month)
    @user = User.find_by_username manager.username
    where("user_id = ? AND strftime('%m', created_at) = ?", @user.id, month).count()
  end

  def self.total_assigned_to_user_by_manager(manager, user, month)
    @user = User.find_by_username manager.username
    @user_2 = User.find_by_username user.username
    where("user_id = ? AND assignee_id = ? AND strftime('%m', created_at) = ?", @user.id, @user_2.id, month).count()
  end

  def self.total_completed_by_user_manager(manager, user, month)
    @user = User.find_by_username manager.username
    @user_2 = User.find_by_username user.username
    where("user_id = ? AND assignee_id = ? AND strftime('%m', created_at) = ? AND is_completed = ? AND is_incomplete = ?", @user.id, @user_2.id, month, true, false).count()
  end

  def self.total_incomplete_by_user_manager(manager, user, month)
    @user = User.find_by_username manager.username
    @user_2 = User.find_by_username user.username
    where("user_id = ? AND assignee_id = ? AND strftime('%m', created_at) = ? AND is_completed = ? AND is_incomplete = ?", @user.id, @user_2.id, month, false, true).count()
  end

  def self.total_ongoing_by_user_manager(manager, user, month)
    @user = User.find_by_username manager.username
    @user_2 = User.find_by_username user.username
    where("user_id = ? AND assignee_id = ? AND strftime('%m', created_at) = ? AND is_completed = ? AND is_incomplete = ?", @user.id, @user_2.id, month, false, false).count()
  end

  def self.total_completed_by_manager(manager, month)
    @user = User.find_by_username manager.username
    where("user_id = ? AND strftime('%m', created_at) = ? AND is_completed = ? AND is_incomplete = ?", @user.id, month, true, false).count()
  end

  def self.total_incomplete_by_manager(manager, month)
    @user = User.find_by_username manager.username
    where("user_id = ? AND strftime('%m', created_at) = ? AND is_completed = ? AND is_incomplete = ?", @user.id, month, false, true).count()
  end

  def self.total_ongoing_by_manager(manager, month)
    @user = User.find_by_username manager.username
    where("user_id = ? AND strftime('%m', created_at) = ? AND is_completed = ? AND is_incomplete = ?", @user.id, month, false, false).count()
  end
end
