Authorization.default_role = :anonymous

authorization do
  role :anonymous do
    has_permission_on [:campaigns], :to => [:index, :widget ,:widget_iframe, :sign, :signed, :call, :calling, :validate, :integrate, :validated, :feed, :archived, :list, :search, :add_credit, :credit_added, :credit_denied]
    has_permission_on [:campaigns], :to => [:show] do
      if_attribute :moderated => is { false }
    end
    has_permission_on [:donate], :to => [:index, :accepted, :denied, :confirm]
    has_permission_on [:pages], :to => [:index, :faq, :tutorial, :privacy_policy, :contact, :contact_received, :about, :press,
                                        :activity]
    has_permission_on [:sub_oigames], :to => [:widget, :widget_iframe, :integrate]
    has_permission_on [:banesto], :to => [:payment_accepted]
  end
  
  role :user do
    includes :anonymous
    has_permission_on [:campaigns], :to => [:new, :create]
    has_permission_on [:campaigns], :to => [:show, :edit, :update, :participants, :add_update] do
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
      :deactivate, :archive, :prioritize, :deprioritize, :show, :edit, :update, :participants, :programe, :add_update]
    has_permission_on [:sub_oigames], :to => [:index, :show, :new, :edit, :create, :update, :destroy, :programe, :add_update]
  end

  role :admin do
    has_omnipotence
  end
end
