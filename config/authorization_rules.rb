Authorization.default_role = :anonymous

authorization do
  role :anonymous do
    has_permission_on [:campaigns], :to => [:index, :widget ,:widget_iframe, :message, :petition,
      :validate, :integrate, :validated, :feed, :archived, :search]
    has_permission_on [:campaigns], :to => [:show] do
      if_attribute :moderated => is { false }
    end
    has_permission_on [:donate], :to => [:index, :accepted, :denied]
    has_permission_on [:pages], :to => [:index, :help, :tutorial, :privacy_policy, :contact, :contact_received]
    has_permission_on [:sub_oigames], :to => [:widget, :widget_iframe, :integrate]
  end
  
  role :user do
    includes :anonymous
    has_permission_on [:campaigns], :to => [:new, :create]
    has_permission_on [:campaigns], :to => [:show, :edit, :update, :participants] do
      if_attribute :user_id => is { user.id } 
    end
    # crear el permiso para moderated teniendo en cuenta el sub_oigame
    has_permission_on [:campaigns], :to => [:moderated] do
      if_attribute :sub_oigame => { :users => contains { user } }
    end
    has_permission_on [:donate], :to => [:init]
  end

  role :editor do
    includes :user
    has_permission_on [:campaigns], :to => [:participants, :update, :destroy, :moderated, :activate,
      :deactivate, :archive, :prioritize, :deprioritize, :show, :edit, :update, :participants]
    has_permission_on [:sub_oigames], :to => [:index, :show, :new, :edit, :create, :update, :destroy]
  end

  role :admin do
    includes :editor
  end
end
