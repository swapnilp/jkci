Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #require 'resque/server'
  resources :teachers
  resources :students
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

  resources :jkci_classes
  get "/class/:id/assign_students" => "jkci_classes#assign_students", as: "class_assign_students"
  post "/class/:id/manage_students" => "jkci_classes#manage_students", as: "class_manage_students"
  get "/jkci_class/filter_class/batch" => "jkci_classes#filter_class", as: "filter_class"
  
  resources :daily_teachs
  get "daily_teach/:id/students" => "daily_teachs#get_class_students"
  post "daily_teach/:id/fill_catlog" => "daily_teachs#fill_catlog"
  get "/daily_teach/filter_daily_teach/daily_teach" => "daily_teachs#filter_teach", as: "filter_teach"
  get "/daily_teach/:id/follow" => "daily_teachs#follow_teach", as: "follow_teach"
  get "/daily_teach/:class_catlog_id/recover" => "daily_teachs#recover_daily_teach", as: "recover_daily_teach"
  
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
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
