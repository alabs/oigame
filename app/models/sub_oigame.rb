class SubOigame < ActiveRecord::Base
  belongs_to :user
  has_many :campaigns

  attr_accessible :name, :slug, :html_header, :html_footer, :html_style, :logo, :from 

  before_save :generate_slug

  validates :name, :user, :presence => true

  mount_uploader :logo, LogoUploader

  before_save :generate_base64_logo

  def to_param
    slug
  end

  def generate_slug
    self.slug = self.name.parameterize
  end

  def generate_base64_logo(file = self.logo.current_path)
    if file then
      fh = File.open(file)
      # generate base64
      require 'base64'
      base64 = Base64.encode64(fh.read)
      fh.close
      self.logobase64 = base64
    end
  end
end

