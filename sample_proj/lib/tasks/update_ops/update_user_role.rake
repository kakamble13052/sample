namespace :update_ops do
  task update_role: :environment do
    User.where(firstname: '').each do |user|
      firstname = user.username
      user.firstname = firstname[0..3]
      user.save
    end
    User.where(lastname: '').each do |user|
      lastname = user.username
      user.lastname = lastname[4..6]
      user.save
    end
    User.where(admin: nil).each do |user|
      user.admin = false
      user.save
    end
    User.where(role_id: nil).each do |user|
      if user.admin?
        user.role = Role.find_by_name('admin')
      else
        user.role = Role.find_by_name('employee')
      end
      user.save
    end
    User.where(manager_bool: nil).each do |user|
      if user.role == Role.find_by_name('manager')
        user.manager_bool = true
        user.manager = Manager.find_by_username('manager')
      elsif user.role == Role.find_by_name('admin') or user.admin?
        user.manager_bool = false
        user.manager = Manager.find_by_username('manager')
      else
        user.manager_bool = false
        user.manager = Manager.find_by_username('justice')
      end
      user.save
    end
    User.where(manager_bool: false).each do |user|
      if user.admin? and Manager.find_by_username(user.username).nil?
        @admin = Manager.new
        @admin.email = user.email
        @admin.username = user.username
        @admin.firstname = user.firstname
        @admin.lastname = user.lastname
        @admin.save
        user.manager = Manager.find_by_username @admin.username
        user.save
      end
    end
  end
end