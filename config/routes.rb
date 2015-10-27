Rails.application.routes.draw do
  devise_for :users, :controllers => {sessions: 'user/sessions', :registrations => "user/registrations"}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #require 'resque/server'
  resources :teachers
  resources :students
  get "/students/filter_student/student" => "students#filter_students", as: "filter_students"
  get "/student/:id/enable_sms" => "students#enable_sms", as: "enable_student_sms"
  get "/student/:id/select_user" => "students#select_user", as: "select_login_user"
  get "/student/:id/disable_student" => "students#disable_student", as: "disable_student"
  get "/student/:id/filter_student_data" => "students#filter_students_data", as: "filter_students_data"
  get "/student/:id/download_report" => "students#download_report", as: "download_progress_report"
  resources :parents
  resources :parents_meeting
  
  resources :organisations do
    member do
      get "manage_organisation", as: "manage"
      get 'manage_courses', as: 'manage_courses'
      get 'manage_users', as: 'manage_users'
      get 'remaining_cources', as: 'remaining_cources'
      post 'add_remaining_cources', as: 'add_remaining_cources'
      get 'new_users', as: 'new_users'
      post 'create_users', as: 'create_users'
    end
  end
  
  get 'organisation/:id/regenerate_mobile_code' => "organisations#regenerate_organisation_code", as: 'regenerate_organisation_code'
  
  get '/parents_meeting/:id/send_sms' => "parents_meeting#sms_send", as: "meeting_sms_send"
  
  resources :parents_list, only: [:index]
  get '/parents_list/get_parent_list' => "parents_list#get_parent_list"
  resources :promotional_mails

  resources :exams, except: [:new, :create, :edit, :update, :destroy]
  get 'exam/:id/download_data' => "exams#download_data", as: 'download_exam_data'
  get 'exam/:id/verify_create_exam' => "exams#verify_create_exam", as: 'verify_create_exam'
  get 'exam/:id/verify_exam_absenty' => "exams#verify_exam_absenty", as: 'verify_exam_absenty'
  get 'exam/:id/verify_exam_result' => "exams#verify_exam_result", as: 'verify_exam_result'
  get 'exam/:id/absent_students' => "exams#absunts_students", as: 'exam_absent_students'
  get 'exam/:id/exam_students' => "exams#exams_students", as: 'exams_students'
  get 'exam/:id/add_absent_students' => "exams#add_absunt_students", as: 'add_exam_absent_students'
  get 'exam/:id/add_exam_results' => "exams#add_exam_results", as: 'add_exam_results'
  get 'exam/:id/publish_exam_result' => "exams#publish_exam_result", as: "publish_result"
  get 'exam/:id/publish_absent_exam' => "exams#publish_absent_exam", as: "publish_absent_exam"
  get 'exam/:id/exam_completed' => "exams#exam_completed", as: "exam_completed"
  get "/exams/filter_exam/exam" => "exams#filter_exam", as: "filter_exam"
  get '/exams/download_exams_report/exam' => "exams#download_exams_report", as: "download_exams_report"
  get "/exam/:id/abesnt_student/:student_id/remove" =>  "exams#remove_exam_absent", as: "remove_exam_absent"
  get "/exam/:id/ignore_student/:student_id" =>  "exams#ignore_student", as: "ignore_exam_student"
  get "/exam/:id/remove_ignore_student/:student_id" =>  "exams#remove_ignore_student", as: "remove_ignore_exam_student"
  get "/exam/:id/exam_result/:exam_catlog_id/remove" =>  "exams#remove_exam_result", as: "remove_exam_result"
  get "/exam/:id/exam_recover/:exam_catlog_id/recover" =>  "exams#recover_exam", as: "recover_exam"
  post "/exam/:id/upload_paper" => "exams#upload_paper", as: "upload_exam_paper"
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
  
  resources :subjects
  resources :standards do
    #resources :jkci_classes, only: [:new, :create, :edit, :update]
  end
  get "/subject/:id/chapters" => "subjects#chapters", as: "subject_chapters"

  resources :jkci_classes, except: [:new, :create, :edit, :update] do 
    resources :sub_classes
    get '/sub_class/:id/get_students' => 'sub_classes#get_students', as: "class_students"
    get '/sub_class/:id/add_students' => 'sub_classes#add_students'
    get '/sub_class/:id/remove_students' => 'sub_classes#remove_students'
    
    resources :exams, only: [:new, :create, :edit, :update, :destroy]
    resources :daily_teachs, only: [:new, :create, :edit, :update, :destroy]
  end
  
  get "/class/:id/assign_students" => "jkci_classes#assign_students", as: "class_assign_students"
  get "/class/:id/download_class_catlog" => "jkci_classes#download_class_catlog", as: "download_class_catlog"
  get "/class/:id/download_class_syllabus" => "jkci_classes#download_class_syllabus", as: "download_class_syllabus"
  get "/jkci_class/:id/daily_teaches" => "jkci_classes#class_daily_teaches", as: "class_daily_teaches"
  get "/jkci_class/:id/filter_class_exams" => "jkci_classes#filter_class_exams", as: "filter_class_exams"
  get "/jkci_class/:id/filter_daily_teach" => "jkci_classes#filter_daily_teach", as: "filter_daily_teach"
  get "/jkci_class/:jkci_class_id/chapters" => "jkci_classes#chapters", as: "chapters"
  post "/class/:id/manage_students" => "jkci_classes#manage_students", as: "class_manage_students"
  get "/jkci_class/filter_class/batch" => "jkci_classes#filter_class", as: "filter_class"


  resources :galleries
  resources :daily_teachs, except: [:new, :create, :edit, :update, :destroy]
  get "/daily_teach/:id/students" => "daily_teachs#get_class_students"
  post "/daily_teach/:id/fill_catlog" => "daily_teachs#fill_catlog"
  get "/daily_teach/filter_daily_teach/daily_teach" => "daily_teachs#filter_teach", as: "filter_teach"
  get "/daily_teach/:id/follow" => "daily_teachs#follow_teach", as: "follow_teach"
  get "/daily_teach/:class_catlog_id/recover" => "daily_teachs#recover_daily_teach", as: "recover_daily_teach"
  get "/daily_teach/:id/class_absent_verification" => "daily_teachs#class_absent_verification", as: "class_absent_verification"
  post "/daily_teach/:id/send_class_absent_sms" => "daily_teachs#send_class_absent_sms", as: "class_absent_sms"
  #get "/daily_teach/:class_catlog_id/recover" => 
  
  resources :chapters do
    resources :chapters_points
  end
  
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
  get '/timetable' => "home#timetable", as: 'timetable'
  get '/our_facilities' => "home#our_facilities", as: 'facilities'
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
