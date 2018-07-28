class EmployeeCommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @employee_comment = EmployeeComment.new
  end

  def create
    @task = Task.find(params[:task_id])
    @employee_comment = @task.employee_comments.build(employee_comment_params)
    @user = User.find_by_username current_user.username
    @user.employee_comments << @employee_comment
    if @employee_comment.save!
      TaskMailer.task_user_commented(@task, @employee_comment, @user).deliver_now
      redirect_to task_path(@task)
    else
      render 'new'
    end
  end

  def show
    @task = Task.find(params[:task_id])
    @employee_comment = @task.employee_comments.find(params[:id])
  end

  def edit
    @task = Task.find(params[:task_id])
    @employee_comment = @task.employee_comments.find(params[:id])
  end

  def update
    @task = Task.find(params[:task_id])
    @employee_comment = @task.employee_comments.find(params[:id])
    if @employee_comment.update(employee_comment_params)
      redirect_to task_path(@task)
    else
      render 'edit'
    end
  end

  def destroy
    @task = Task.find(params[:task_id])
    @employee_comment = @task.employee_comments.find(params[:id])
    @employee_comment.destroy!
    redirect_to task_path(@task)
  end


  private

  def employee_comment_params
    params.require(:employee_comment).permit(:comment)
  end
end
