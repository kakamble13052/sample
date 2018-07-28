namespace :update_ops do
  task sample_tasks: :environment do
    @manager = Manager.all
    i = 0
    taska = 'a,b,c,d,e,f,g,h,i,j,k'
    assign_tasks = taska.split(',')
    @manager.each do |manager|
      @assigner = User.find_by_username manager.username
      manager.users.each do |user|
        @user = User.find_by_username user.username
        @task = Task.new
        descrip = assign_tasks[i]
        @task.desc = descrip
        @task.due_date = Time.now + (60*60*24)
        @task.created_at = Time.now - (60*60*24*30*7)
        @task.assignee_id = @user.id
        @task.user_id = @assigner.id
        @task.is_completed = false
        @task.is_incomplete = false
        @task.archived = false
        @task.save
        i = i + 1
      end
    end
  end
end