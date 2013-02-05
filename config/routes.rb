Oigame::Application.routes.draw do
  campaign_routes = lambda do
    resources :wizard
    member do
      # Controllers for sign the petitions
      # LEGACY <-----
      post 'petition' => 'campaigns#sign'
      post 'message' => 'campaigns#sign'
      post 'fax' => 'campaigns#sign'

      # New controller for signing
      post 'sign' => 'campaigns#sign'
      get 'signed'

      # Validation controller
      get 'validate/:token' => 'campaigns#validate', :as => 'validate'
      get 'validated'
      get 'participants'
      get 'integrate'
      get 'widget'
      get 'widget-iframe.html' => 'campaigns#widget_iframe', :as => 'widget_iframe'

      # Admin controllers
      post 'activate'
      post 'deactivate'
      post 'prioritize'
      post 'deprioritize'
      post 'archive'
      post 'programe'

      # Fax creadit gw
      #post 'new_comment'
      get 'add-credit' => 'campaigns#add_credit', :as => 'add_credit'
      get 'transaction-accepted' => 'campaigns#credit_added', :as => 'credit_added'
      get 'transaction-denied' => 'campaigns#credit_denied', :as => 'credit_denied'
    
      post 'ok' => 'banesto#payment_accepted', :as => 'payment_accepted'
    end

    collection do
      get 'moderated'
      get 'feed', :defaults => { :format => 'rss' }
      get 'archived'
      get 'search' => 'campaigns#search'
    end

  end


  resources :categories

  scope "(:locale)", :locale => /en|es|gl/ do
    # solucionar el tema de acceso por rol
    mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

    resources :campaigns, &campaign_routes
  
    resources :sub_oigames, :path => "o" do
      resources :campaigns, &campaign_routes

      get 'integrate'
      get 'widget'
      get 'widget-iframe.html' => 'sub_oigames#widget_iframe', :as => 'widget_iframe'
    end

    get '/profile/:username' => 'profiles#show', :as => 'profile'
    get 'donate' => 'donate#index', :as => 'donate'
    get 'donate/init' => 'donate#init', :as => 'donate_init'
    get 'donate/accepted' => 'donate#accepted'
    get 'donate/denied' => 'donate#denied'
    get 'answers' => redirect('/help')
    get 'help' => 'pages#faq', :as => 'help'
    get 'faq' => 'pages#faq', :as => 'faq'
    get 'press' => 'pages#press', :as => 'press'
    get 'activity' => 'pages#activity', :as => 'activity'
    get 'tutorial' => 'pages#tutorial', :as => 'tutorial'
    get 'privacy-policy' => 'pages#privacy_policy', :as => 'privacy_policy'
    get 'contact' => 'pages#contact', :as => 'contact'
    post 'contact' => 'pages#contact', :as => 'contact'
    get 'contact/received' => 'pages#contact_received', :as => 'contact_received'
    get 'about' => 'pages#about', :as => 'about'
    devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup' }, :controllers => { :registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks" }
    devise_scope :user do
      get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
    end

    # http://dev.af83.com/2012/06/04/request-authentication-from-the-router-with-devise.html
    authenticate :user do
      mount Tolk::Engine => '/translate', :as => 'tolk'
    end


    get 'facebook/auth' => 'facebook#auth', :as => 'facebook_auth'
    get 'facebook/callback' => 'facebook#callback', :as => 'facebook_callback'
    root :to => 'pages#index'
  end

  # para el servidor de tareas en background
  constraints CanAccessResque do
    mount Resque::Server, at: 'jobs'
  end

  match '*path', to: redirect {|params,request| "/#{I18n.default_locale}/#{CGI::unescape(params[:path])}" },
        constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }

  match '', to: redirect("/#{I18n.default_locale}")

end
