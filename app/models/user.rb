class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :mailing, :name, :vat, :provider, :uid

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
      user = where(:provider => auth.provider, :uid => auth.uid).first
      unless user
        user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20]
                          )
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
  
  ROLES = %w[user editor admin]
  
  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def ready_for_donation
    name.blank? || vat.blank? ? false : true
  end
end
