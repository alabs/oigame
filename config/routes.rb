Oigame::Application.routes.draw do

  resources :sub_oigames, :path => "o" do
    resources :campaigns do
      member do
        post 'petition'
        get 'petition'
        get 'validate/:token' => 'campaigns#validate', :as => 'validate'
        get 'validated'
        post 'message'
        get 'message'
        get 'widget'
        get 'widget-iframe.html' => 'campaigns#widget_iframe', :as => 'widget_iframe'
        post 'activate'
        post 'deactivate'
        post 'archive'
      end
      collection do
        get 'tag'
        get 'tags-archived' => 'campaigns#tags_archived', :as => 'tags_archived'
        get 'moderated'
        get 'feed', :defaults => { :format => 'rss' }
        get 'archived'
      end
    end
  end

  get 'donate' => 'donate#index', :as => 'donate'
  get 'donate/init' => 'donate#init', :as => 'donate_init'
  get 'donate/accepted' => 'donate#accepted'
  get 'donate/denied' => 'donate#denied'
  get 'answers' => redirect('/help')
  get 'help' => 'pages#help', :as => 'help'
  get 'tutorial' => 'pages#tutorial', :as => 'tutorial'
  get 'privacy-policy' => 'pages#privacy_policy', :as => 'privacy_policy'
  get 'contact' => 'pages#contact', :as => 'contact'
  post 'contact' => 'pages#contact', :as => 'contact'
  get 'contact/received' => 'pages#contact_received', :as => 'contact_received'
  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup' }, :controllers => { :registrations => "users/registrations" }

  resources :campaigns do
    member do
      post 'petition'
      get 'petition'
      get 'validate/:token' => 'campaigns#validate', :as => 'validate'
      get 'validated'
      post 'message'
      get 'message'
      get 'widget'
      get 'widget-iframe.html' => 'campaigns#widget_iframe', :as => 'widget_iframe'
      post 'activate'
      post 'deactivate'
      post 'archive'
    end
    collection do
      get 'tag'
      get 'tags-archived' => 'campaigns#tags_archived', :as => 'tags_archived'
      get 'moderated'
      get 'feed', :defaults => { :format => 'rss' }
      get 'archived'
    end
  end

  root :to => 'pages#index'

end
