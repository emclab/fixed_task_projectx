Rails.application.routes.draw do

  mount FixedTaskProjectx::Engine => "/fixed_task_projectx"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount Kustomerx::Engine => '/kustomerx'
  mount SimpleTypex::Engine => '/simple_typex'
  mount TaskTemplatex::Engine => '/templatex'
  mount Searchx::Engine => '/searchx'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
