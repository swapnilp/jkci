Rails.application.routes.draw do
  devise_for :users, :controllers => {sessions: 'sessions'}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #require 'resque/server'
  resources :teachers
  resources :students
  get "/students/filter_student/student" => "students#filter_students", as: "filter_students"
  get "/student/:id/enable_sms" => "students#enable_sms", as: "enable_student_sms"
  get "/student/:id/select_user" => "students#select_user", as: "select_login_user"
  resources :parents
  resources :parents_meeting
  get '/parents_meeting/:id/send_sms' => "parents_meeting#sms_send", as: "meeting_sms_send"
  resources :exams
  get 'exam/:id/absent_students' => "exams#absunts_students", as: 'exam_absent_students'
  get 'exam/:id/exam_students' => "exams#exams_students", as: 'exams_students'
  get 'exam/:id/add_absent_students' => "exams#add_absunt_students", as: 'add_exam_absent_students'
  get 'exam/:id/add_exam_results' => "exams#add_exam_results", as: 'add_exam_results'
  get 'exam/:id/publish_exam_result' => "exams#publish_exam_result", as: "publish_result"
  get 'exam/:id/exam_completed' => "exams#exam_completed", as: "exam_completed"
  get "/exams/filter_exam/exam" => "exams#filter_exam", as: "filter_exam"
  get "/exam/:id/abesnt_student/:student_id/remove" =>  "exams#remove_exam_absent", as: "remove_exam_absent"
  get "/exam/:id/exam_result/:exam_catlog_id/remove" =>  "exams#remove_exam_result", as: "remove_exam_result"
  get "/exam/:id/exam_recover/:exam_catlog_id/recover" =>  "exams#recover_exam", as: "recover_exam"
  get "/exam/follow_exam_absent_student/:exam_catlog_id" =>  "exams#follow_exam_absent_student", as: "follow_exam_absent_student"
  
  resources :exam_absents, only: [:destroy]
  resources :exam_results, only: [:destroy]
  
  resources :events, only: [:index, :show] do
    collection do
      get 'manage_events', as: 'manage'
    end
  end

  
  
  get 'parent_desk' => "parent_desk#parent_desk"
  get 'parent_desk/student_info/:id' => "parent_desk#student_info", as: 'parent_student_info'
  get 'parent_desk/student_info/:id/teached_info' => "parent_desk#teached_info", as: 'parent_teached_info'
  get 'parent_desk/student_info/:id/exam_info' => "parent_desk#exam_info", as: 'parent_exam_info'
  get 'parent_desk/student_info/:id/paginate_catlog' => "parent_desk#paginate_catlog", as: 'parent_paginate_catlog'
  


  resources :jkci_classes
  get "/class/:id/assign_students" => "jkci_classes#assign_students", as: "class_assign_students"
  get "/class/:id/daily_teaches" => "jkci_classes#class_daily_teaches", as: "class_daily_teaches"
  post "/class/:id/manage_students" => "jkci_classes#manage_students", as: "class_manage_students"
  get "/jkci_class/filter_class/batch" => "jkci_classes#filter_class", as: "filter_class"
  

  resources :galleries
  resources :daily_teachs
  get "daily_teach/:id/students" => "daily_teachs#get_class_students"
  post "daily_teach/:id/fill_catlog" => "daily_teachs#fill_catlog"
  get "/daily_teach/filter_daily_teach/daily_teach" => "daily_teachs#filter_teach", as: "filter_teach"
  get "/daily_teach/:id/follow" => "daily_teachs#follow_teach", as: "follow_teach"
  get "/daily_teach/:class_catlog_id/recover" => "daily_teachs#recover_daily_teach", as: "recover_daily_teach"
  
  resources :chapters
  resources :albums do 
    get 'manage_albums', on: :collection, as: 'manage'
  end

  resources :about_us, only: [:index]
  resources :courses, olny: [:index]
  resources :batch_results
  resources :results do 
    post 'add_result_photo', on: :collection, as: 'add_image'
  end

  resources :career, only: [:index]

  get 'contact_us' => "about_us#contact_us"

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
  get '/admin_desk' => "home#admin_desk"
  get '/batch2015/jksaitalent' => "talent#new_talent2015"
  get '/batch2015/createjksaitalent' => "talent#create_talent2015"
  get '/batch2015/talents' => "talent#index", as: 'talent2015'
  get '/batch2015/talents/download' => "talent#download_talent_2015", as: 'talent2015_download' 
  root 'home#index'
  #root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
