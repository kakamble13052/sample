Rails.application.routes.draw do
  devise_for :users
  get 'welcome/index'
  get 'all_articles' => 'articles#all'
  patch 'articles/:id', to: 'articles#update'
  root 'welcome#index'
  get 'all_admin' => 'articles#all_admin'
  get 'add_manager_to_user' => 'managers#choose'
  post 'add_manager_to_user' => 'managers#assign'
  post 'assign_manager_to_user' => 'managers#assign'
  get 'show_users' => 'managers#show_users'
  resources :articles do
    get 'add_comment/:id', action: 'add_comment'
    resources :comments
  end
  resources :tasks do
    collection do
      post '/destroy_all', to: 'tasks#destroy_all', as: 'destroy_all'
    end
    resources :employee_comments
  end
  get 'new_self_task' => 'tasks#self_task'
  get 'all_tasks' => 'tasks#all_tasks'
  post 'new_self_task' => 'tasks#create'
  post '/send_mail/:id', to: 'tasks#send_mail', as: 'send_mail'
  post '/archive/:id', to: 'tasks#archive', as: 'archive'
  post '/unarchive/:id', to: 'tasks#unarchive', as: 'unarchive'
  get '/archived_tasks', to: 'tasks#archived_tasks', as: 'archived_tasks'
  get 'view_admin_analytics' => 'analytics#view_admin'
  get 'view_manager_analytics' => 'analytics#view_manager'
  get 'view_employee_analytics' => 'analytics#view_employee'
  post 'get_months' => 'analytics#get_months'
  #get '/tasks/:id', to: 'tasks#send_mail', as: 'send_mail'
  #patch '/tasks/:id', to: 'tasks#send_mail', as: 'send_mail'
  # put '/tasks/:id', to: 'tasks#send_mail', as: 'send_mail'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
