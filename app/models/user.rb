class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :mailing, :name, :vat

  has_many :campaigns, :dependent => :destroy
  has_and_belongs_to_many :sub_oigames

  class << self

    def get_mailing_users
      where('mailing = ?', true).all
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
