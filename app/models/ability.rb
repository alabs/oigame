class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new

    if user.role? :user
      can :read, Campaign, :moderated => false
      can :read, Campaign, :status => 'archived'
      can :create, Campaign
      can :update, Campaign, :moderated => false, :user_id => user.id
      can :participants, Campaign, :moderated => false, :user_id => user.id
      can :widget, Campaign, :moderated => false 
      can :widget_iframe, Campaign, :moderated => false
      can :petition, Campaign, :moderated => false
      can :validate, Campaign, :moderated => false
      can :validated, Campaign, :moderated => false
      can :archived, Campaign, :status => 'archived'
      # sub_oigames
      can :update, SubOigame do |sub|
        sub.users.include? user
      end
      cannot :read, SubOigame
      can :read, SubOigame do |sub|
        sub.users.include? user
      end
    end
    
    if user.role? :editor
      can :read, Campaign, :moderated => false
      can :read, Campaign, :status => 'archived'
      can :create, Campaign
      can :update, Campaign, :moderated => false
      can :widget, Campaign, :moderated => false 
      can :widget_iframe, Campaign, :moderated => false
      can :petition, Campaign, :moderated => false
      can :validate, Campaign, :moderated => false
      can :participants, Campaign, :moderated => false
      can :validated, Campaign, :moderated => false
      can :archived, Campaign, :status => 'archived'
      # sub_oigames
      can :update, SubOigame do |sub|
        sub.users.include? user
      end
      cannot :read, SubOigame
      can :read, SubOigame do |sub|
        sub.users.include? user
      end
    end

    if user.role? :admin
      can :manage, :all
    end
  end
end
