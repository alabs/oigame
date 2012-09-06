Canard::Abilities.for(:editor) do

  # Define abilities for the user role here. For example:
  #
  #   if user.admin?
  #     can :manage, :all
  #   else
  #     can :read, :all
  #   end
  #
  # The first argument to `can` is the action you are giving the user permission to do.
  # If you pass :manage it will apply to every action. Other common actions here are
  # :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on. If you pass
  # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, :published => true
  #
  # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

  cannot :access, :rails_admin   # revoke access to rails_admin
  cannot :dashboard              # revoke access to the dashboard
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
