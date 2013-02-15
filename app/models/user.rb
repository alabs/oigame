class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :async

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :mailing, :name, :vat, :provider, :uid
  attr_accessible :email, :password, :password_confirmation, :remember_me, :mailing, :name, :vat, :provider, :uid, :roles, as: :admin

  has_many :campaigns, :dependent => :destroy
  has_and_belongs_to_many :sub_oigames
  has_many :donations
  has_many :user_providers

  after_create :set_role

  USER_ROLES = %w[user editor admin]
  
  class << self

    def get_mailing_users
      where('mailing = ?', true).all
    end

    def recent(limit = nil)
      order('created_at DESC').limit(limit)
    end

    def find_for_facebook_oauth(auth, signed_in_resource=nil)
      unless signed_in_resource
        user_provider = UserProvider.where(:provider => auth.provider, :uid => auth.credentials.token).first
        user = user_provider ? user_provider.user : self.where(:email => auth.info.email).first
      else
        user = signed_in_resource
        user_provider = user.user_providers.where(provider: auth.provider, uid: auth.credentials.token).first
      end

      unless user
        user = User.new
        user.name = auth.extra.raw_info.name
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.confirmed_at = DateTime.now
        user.skip_confirmation!
        user.save
      else
        user_provider = UserProvider.new
        user_provider.user = user
        user_provider.provider = auth.provider
      end
      user_provider.uid = auth.credentials.token
      user_provider.save
      user
    end

    def find_for_twitter_oauth(auth, signed_in_resource=nil)
      user = self.where(:provider => auth["provider"], :uid => auth["uid"]).first
      unless user
        user = User.new
        user_provider = UserProvider.new
        user.name = auth["info"]["name"]
        user.email = nil
        user.password = Devise.friendly_token[0,20]
        user.confirmed_at = DateTime.now
        user.skip_confirmation!
        user.save
        user_provider.user = user
        user_provider.provider = auth["provider"]
        user_provider.uid = auth["uid"]
        user_provider.save
      end
      user
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end
  end
  
  #def role=(roles)
  #  roles=(roles)
  #end

  #def role
  #  roles
  #end

  def roles=(roles)
    self.roles_mask = (roles & USER_ROLES).map { |r| 2**USER_ROLES.index(r) }.inject(0, :+)
  end
  
  def roles
    USER_ROLES.reject do |r|
      ((roles_mask || 0) & 2**USER_ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def ready_for_donation
    name.blank? ? false : true
  end
  
  def ready_for_add_credit
    name.blank? ? false : true
  end

  def user?
    self.roles.include? == 'user'
  end

  def editor?
    self.roles.include? == 'editor'
  end

  def admin?
    self.roles.include? == 'admin'
  end

  # para declarative_auth
  def role_symbols
    roles.map do |role|
      role.underscore.to_sym
    end
  end

  protected

  def set_role
    self.roles = ['user']
    self.save
  end
end
