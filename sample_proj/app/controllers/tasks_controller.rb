class TasksController < ApplicationController
  extend TasksHelper
  before_action :authenticate_user!

  def index
    SendDeadlineExpiryMailJob.perform_now
    if current_user.admin? or current_user.manager_bool?
      @user = User.find_by_username current_user.username
      @tasks = @user.tasks.where(archived: false).all
    else
      @user = User.find_by_username current_user.username
      @tasks = Task.where(assignee_id: @user.id).all
    end
  end
  def new
    @task = Task.new
    @manager = Manager.find_by_username current_user.username
  end

  def all_tasks
    SendDeadlineExpiryMailJob.perform_now
    @tasks = Task.all.where(archived: false)
  end

  def create
    @task = current_user.tasks.build(task_params)
    @task.is_completed = false
    @task.is_incomplete = false
    @task.archived = false
    if @task.save
      TaskMailer.task_assigned_mail(@task).deliver_now
      flash[:alert] = "Task assigned"
      redirect_to root_path
    end
  end

  def show
    SendDeadlineExpiryMailJob.perform_now
    @task = Task.find(params[:id])
    # respond_to do |format|
    #   format.js
    #   format.html
    # end
  end

  def archived_tasks
    if current_user.admin?
      @tasks = Task.all.where(archived: true)
    elsif current_user.manager_bool?
      @user = User.find_by_username current_user.username
      @tasks = @user.tasks.where(archived: true).all
    end
  end

  def send_mail
    @task = Task.find(params[:id])
    @task.is_completed = true
    @user = User.find(@task.user_id)
    if @task.save!
      TaskMailer.task_completed_mail(@user, @task).deliver_now
      redirect_to root_path
    end
  end

  def archive
    @task = Task.find(params[:id])
    @task.archived = true
    if @task.save!
      redirect_to tasks_path
    end
  end

  def edit
    @task = Task.find(params[:id])
    if current_user.manager_bool?
      @manager = Manager.find_by_username current_user.username
    end
  end


  def update
    @task = Task.find(params[:id])
    prev_deadline = @task.due_date
    prev_assignee_id = @task.assignee_id
    prev_user_id = @task.user_id
    if @task.update!(task_params)
      notify_user_email @task, prev_deadline, prev_assignee_id, prev_user_id
      redirect_to tasks_path
    end
  end


  def unarchive
    @task = Task.find(params[:id])
    @task.archived = false
    if @task.save!
      redirect_to tasks_path
    end
  end

  def self_task
    @task = Task.new
    @manager = Manager.find_by_username current_user.username
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy!
      redirect_to root_path
    end
  end

  def destroy_all
    @tasks_ids = params[:ids].split(',')
    # i = 0
    # d = @tasks_ids.length
    # binding.pry
    @tasks = Task.where(id: @tasks_ids)
    @tasks.destroy_all
    redirect_to root_path
  end


  def notify_user_email(task, prev_deadline, prev_assignee_id, prev_user_id)
    @user = User.find(task.assignee_id)
    @user_2 = User.find(prev_assignee_id)
    @manager = User.find(task.user_id)
    @manager_2 = User.find(prev_user_id)
    new_deadline = task.due_date
    if new_deadline > prev_deadline
      TaskMailer.task_deadline_extended_mail(@user, task, prev_deadline).deliver_now
    elsif new_deadline < prev_deadline
      TaskMailer.task_deadline_reduced_mail(@user, task, prev_deadline).deliver_now
    elsif @user.id != @user_2.id
      TaskMailer.task_assignee_changed_mail(@user, @user_2, task).deliver_now
      TaskMailer.task_assigned_mail(task).deliver_now
    elsif @manager.id != @manager_2.id
      TaskMailer.task_user_changed_mail(@manager, @manager_2, task).deliver_now
      TaskMailer.task_manager_changed_mail(@user, @manager, task).deliver_now
    end
  end

  private
  def task_params
    params.require(:task).permit(:desc, :due_date, :assignee_id, :user_id)
  end

end
