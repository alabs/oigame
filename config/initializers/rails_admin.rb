# RailsAdmin config file. Generated on August 23, 2012 12:53
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

 config.model User do
   update do
     configure :role do
       partial "user_role"
     end
   end
 end

 config.attr_accessible_role { :admin }

  config.authorize_with do |controller|
    redirect_to main_app.root_path unless current_user.role == "admin"
  end

  # https://github.com/sferik/rails_admin/wiki/CanCan
  # FIXME: da este error - 
  # The accessible_by call cannot be used with a block 'can' definition. The SQL cannot be determined for :index Campaign(id: integer, name: string, slug: string, intro: text, body: text, created_at: datetime, updated_at: datetime, user_id: integer, image: string, emails: text, moderated: boolean, published_at: datetime, target: string, duedate_at: datetime, ttype: string, status: string, sub_oigame_id: integer, default_message_subject: string, default_message_body: text, priority: boolean, deleted_at: time, messages_count: integer, petitions_count: integer, commentable: boolean)
  #config.authorize_with :cancan

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  config.current_user_method { current_user } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, User

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, User

  config.main_app_name = ['oiga.me', 'Admin']


  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 20

  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models = [Campaign, Contact, Message, Petition, SubOigame, User]

  # Add models here if you want to go 'whitelist mode':
  # config.included_models = [Campaign, Contact, Message, Petition, SubOigame, User]

  # Application wide tried label methods for models' instances
  # config.label_methods << :description # Default is [:name, :title]

  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field.
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Cross-section field configuration
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  # end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible. (visible(true))

  # config.model Campaign do
  #   # Found associations:
  #     configure :user, :belongs_to_association 
  #     configure :sub_oigame, :belongs_to_association 
  #     configure :messages, :has_many_association 
  #     configure :petitions, :has_many_association 
  #     configure :taggings, :has_many_association         # Hidden 
  #     configure :base_tags, :has_many_association         # Hidden 
  #     configure :tag_taggings, :has_many_association         # Hidden 
  #     configure :tags, :has_many_association         # Hidden   #   # Found columns:
  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :slug, :string 
  #     configure :intro, :text 
  #     configure :body, :text 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :user_id, :integer         # Hidden 
  #     configure :image, :carrierwave 
  #     configure :emails, :serialized 
  #     configure :moderated, :boolean 
  #     configure :published_at, :datetime 
  #     configure :target, :string 
  #     configure :duedate_at, :datetime 
  #     configure :ttype, :string 
  #     configure :status, :string 
  #     configure :sub_oigame_id, :integer         # Hidden 
  #     configure :default_message_subject, :string 
  #     configure :default_message_body, :text 
  #     configure :priority, :boolean 
  #     configure :deleted_at, :time 
  #     configure :messages_count, :integer 
  #     configure :petitions_count, :integer 
  #     configure :commentable, :boolean   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Contact do
  #   # Found associations:
  #   # Found columns:
  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :email, :string 
  #     configure :subject, :string 
  #     configure :body, :text 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :mailing, :boolean   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Message do
  #   # Found associations:
  #     configure :campaign, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :campaign_id, :integer         # Hidden 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :email, :string 
  #     configure :validated, :boolean 
  #     configure :token, :string 
  #     configure :body, :text 
  #     configure :subject, :string 
  #     configure :name, :string   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Petition do
  #   # Found associations:
  #     configure :campaign, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :campaign_id, :integer         # Hidden 
  #     configure :email, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :validated, :boolean 
  #     configure :token, :string 
  #     configure :name, :string   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model SubOigame do
  #   # Found associations:
  #     configure :users, :has_and_belongs_to_many_association 
  #     configure :campaigns, :has_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :name, :string 
  #     configure :slug, :string 
  #     configure :html_header, :text 
  #     configure :html_footer, :text 
  #     configure :html_style, :text 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :logo, :carrierwave 
  #     configure :logobase64, :text 
  #     configure :from, :string 
  #     configure :deleted_at, :time 
  #     configure :mail_message, :text 
  #     configure :campaigns_count, :integer   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model User do
  #   # Found associations:
  #     configure :campaigns, :has_many_association 
  #     configure :sub_oigames, :has_and_belongs_to_many_association   #   # Found columns:
  #     configure :id, :integer 
  #     configure :email, :string 
  #     configure :password, :password         # Hidden 
  #     configure :password_confirmation, :password         # Hidden 
  #     configure :reset_password_token, :string         # Hidden 
  #     configure :reset_password_sent_at, :datetime 
  #     configure :remember_created_at, :datetime 
  #     configure :sign_in_count, :integer 
  #     configure :current_sign_in_at, :datetime 
  #     configure :last_sign_in_at, :datetime 
  #     configure :current_sign_in_ip, :string 
  #     configure :last_sign_in_ip, :string 
  #     configure :confirmation_token, :string 
  #     configure :confirmed_at, :datetime 
  #     configure :confirmation_sent_at, :datetime 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 
  #     configure :mailing, :boolean 
  #     configure :role, :string 
  #     configure :name, :string 
  #     configure :vat, :string 
  #     configure :authentication_token, :string 
  #     configure :unconfirmed_email, :string 
  #     configure :campaigns_count, :integer 
  #     configure :provider, :string 
  #     configure :uid, :string   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
end
