class ManagersController < ApplicationController
  before_action :authenticate_user!
  def choose

  end
  def assign
    @manager = Manager.find(params[:manager][:manager_id])
    @user = User.find(params[:user][:user_id])
    @prev_manager = @user.manager
    @manager.users << @user
    @user_man = User.find_by_username @manager.username
    @tasks = Task.where("user_id = ? AND assignee_id = ? AND is_completed = ? AND is_incomplete = ?", @manager.id, @user.id, false, false)
    @tasks.each do |task|
      task.user = @user_man
      task.save
    end
    redirect_to welcome_index_path
  end
  def show_users
    @manager = Manager.find_by_username current_user.username
  end

  private

end
