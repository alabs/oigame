class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :mailing, :name, :vat, :provider, :uid
  attr_accessible :email, :password, :password_confirmation, :remember_me, :mailing, :name, :vat, :provider, :uid, :role, as: :admin

  has_many :campaigns, :dependent => :destroy
  has_and_belongs_to_many :sub_oigames

  class << self

    def get_mailing_users
      where('mailing = ?', true).all
    end

    def recent(limit = nil)
      order('created_at DESC').limit(limit)
    end

    def find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = self.where(:provider => auth.provider, :uid => auth.uid).first || self.where(:email => auth.info.email).first
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
      end
      user
    end

    def find_for_twitter_oauth(provider, uid, signed_in_resource=nil)
      user = self.where(:provider => provider, :uid => uid).first
      unless user
        user = User.new
      end
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end
  end
  
  ROLES = %w[user editor admin]
  
  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def ready_for_donation
    name.blank? || vat.blank? ? false : true
  end
end
