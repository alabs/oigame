class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new

    if user.role? :user
      can :read, Campaign, :moderated => false
      can :read, Campaign do |campaign|
        unless campaign.sub_oigame.nil?
          campaign.sub_oigame.users.include? user
        end
      end
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
      can :moderated, Campaign do |campaign|
        unless campaign.sub_oigame.nil?
          campaign.sub_oigame.users.include? user
        end
      end
      can :manage, Campaign do |campaign|
        unless campaign.sub_oigame.nil?
          campaign.sub_oigame.users.include? user
        end
      end
      # sub_oigames
      cannot :read, SubOigame
      can :manage, SubOigame do |sub|
        sub.users.include? user
      end
      cannot :index, SubOigame
    end
    
    if user.role? :editor
      can :manage, Campaign do |campaign|
        campaign.sub_oigame.nil?
      end
      cannot :participants, Campaign
      can :participants, Campaign do |campaign|
        campaign.user == user
      end
      can :manage, Campaign do |campaign|
        unless campaign.sub_oigame.nil?
          campaign.sub_oigame.users.include? user
        end
      end
      # sub_oigames
      cannot :read, SubOigame
      can :manage, SubOigame do |sub|
        sub.users.include? user
      end
      cannot :index, SubOigame
    end

    if user.role? :admin
      can :manage, :all
    end
  end
end
